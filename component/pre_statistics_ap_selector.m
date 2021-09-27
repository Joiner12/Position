function [trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector, varargin)
    % 功能:
    %       根据历史AP统计数量选择进行定位的AP点。
    % 定义:
    %       [trilateration_ap,ap_selector] = pre_statistics_ap_selector(cur_frame,ap_selector,scope,varargin)
    % 输入:
    %       cur_frame: 当前帧数据
    %       ap_selector: ap_selector数据，用以保存历史数据(结构体数组)
    %       varargin：扩展参数
    % 输出:
    %       trilateration_ap:用以定位的ap信息
    %       ap_selector: ap_selector数据，用以保存历史数据

    %%
    % 已有节点中当前帧无蓝牙数据的节点
    updated_node_names = strings(0);

    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);

        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;
        updated_node_names(length(updated_node_names) + 1) = name;
        % 新节点

        if ~any(strcmp(selector_name, name))
            ap_selector.NAME(rows + 1) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            % fifo(first in fisrt out)
            recv_rssi_temp = cur_frame_piece.recv_rssi;
            % recv_rssi_temp = fliplr(recv_rssi_temp); % 数组翻转

            if recv_rssi_len > length(ap_selector.RECVRSSI(rows + 1, :)) - 1
                ap_selector.RECVRSSI(rows + 1, :) = recv_rssi_temp(1:length(ap_selector.RECVRSSI(rows + 1, :)));
            else
                ap_selector.RECVRSSI(rows + 1, :) = [pre_rssi_temp(recv_rssi_len + 1:end), recv_rssi_temp];
            end

            ap_selector.LAT(rows + 1) = cur_frame_piece.lat;
            ap_selector.LON(rows + 1) = cur_frame_piece.lon;
            ap_selector.MAC(rows + 1) = cur_frame_piece.mac;
            ap_selector.RSSI(rows + 1) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(rows + 1) = cur_frame_piece.rssi_reference;
        else % 已有节点中当前帧有蓝牙数据
            index = find(strcmp(selector_name, name));
            ap_selector.NAME(index) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            % fifo(first in fisrt out)
            recv_rssi_temp = cur_frame_piece.recv_rssi;
            % recv_rssi_temp = fliplr(recv_rssi_temp); % 数组翻转

            if recv_rssi_len > length(ap_selector.RECVRSSI(index, :)) - 1
                ap_selector.RECVRSSI(index, :) = recv_rssi_temp(1:length(ap_selector.RECVRSSI(index, :)));
            else
                ap_selector.RECVRSSI(index, :) = [pre_rssi_temp(recv_rssi_len + 1:end), recv_rssi_temp];
            end

            ap_selector.LAT(index) = cur_frame_piece.lat;
            ap_selector.LON(index) = cur_frame_piece.lon;
            ap_selector.MAC(index) = cur_frame_piece.mac;
            ap_selector.RSSI(index) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(index) = cur_frame_piece.rssi_reference;
        end

    end

    % 更新ap_selector中已有记录但当前帧无数据的节点
    selector_name_temp = ap_selector.NAME(2:end);
    %selector_name_temp = selector_name(2:end); % 删除首行空数据
    index_temp = find(~contains(selector_name_temp, updated_node_names));

    if ~isempty(index_temp)

        for k_2 = 1:length(index_temp)
            name = selector_name_temp(index_temp(k_2));
            selector_name = ap_selector.NAME;
            index = find(strcmp(selector_name, name)); %ap_selector中的地址
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = 1;
            % fifo(first in fisrt out)
            recv_rssi_temp = 0;
            ap_selector.RECVRSSI(index, :) = [pre_rssi_temp(recv_rssi_len + 1:end), recv_rssi_temp];
        end

    end

    %% 根据apselector信息选择定位点
    %{
    ap selector 选择依据：
    1.ap活跃度；窗口周期内有效RSSI值的个数。
    2.ap rssi 统计性能，比重：活跃度 > 均值 > 方差
    %}
    trilat_table = ap_selector(2:end, :);
    trilat_table.CHARAC_ACT = zeros(size(trilat_table, 1), 1); % ap选择特征值[rssi信号稳定度]
    trilat_table.CHARAC_MEAN = zeros(size(trilat_table, 1), 1); % ap选择特征值[RSSI均值排序]
    trilat_table.CHARAC_VAR = zeros(size(trilat_table, 1), 1); % ap选择特征值[RSSI方差排序]
    trilat_table.SELECT_WEIGHT = zeros(size(trilat_table, 1), 1); % ap输出权重
    % trilat_table.CALCDIST = zeros(size(trilat_table.RECVRSSI)); % 节点信号接收RSSI序列
    % trilat_table.MEANVAL = zeros(size(trilat_table, 1), 1); % RSSI均值
    % trilat_table.VARVAL = zeros(size(trilat_table, 1), 1); % RSSI方差

    for k = 1:size(trilat_table, 1)
        rssi_s = trilat_table.RECVRSSI(k, :);
        valid_rssi = rssi_s(rssi_s ~= 0);
        % 统一特征值(保证最带为5)
        trilat_table.CHARAC_ACT(k) = ceil(5 * length(valid_rssi) / length(rssi_s));
        trilat_table.CHARAC_MEAN(k) = mean(valid_rssi);
        trilat_table.CHARAC_VAR(k) = var(valid_rssi);
    end

    % mean sort character
    gen_index_mean = 1:1:length(trilat_table.CHARAC_MEAN);
    [~, charac_mean_index] = maxk(trilat_table.CHARAC_MEAN, 5);

    for k1 = 1:length(charac_mean_index)
        trilat_table.CHARAC_MEAN(charac_mean_index(k1)) = length(charac_mean_index) + 1 - k1;
    end

    trilat_table.CHARAC_MEAN(gen_index_mean(~ismember(gen_index_mean, charac_mean_index))) = 0;
    % variance sort character
    gen_index_var = 1:1:length(trilat_table.CHARAC_VAR);
    [~, charac_var_index] = mink(trilat_table.CHARAC_VAR, 5);

    for k2 = 1:length(charac_var_index)
        trilat_table.CHARAC_VAR(charac_var_index(k2)) = length(charac_var_index) + 1 - k2;
    end

    trilat_table.CHARAC_VAR(gen_index_var(~ismember(gen_index_var, charac_var_index))) = 0;

    % 神经元
    charac_weight = [0.3, 0.6, 0.1]; % 特征值权重
    charc_temp = [trilat_table.CHARAC_ACT, trilat_table.CHARAC_MEAN, trilat_table.CHARAC_VAR];
    trilat_table.SELECT_WEIGHT = charc_temp * charac_weight';

    % 定位节点最多个数
    [~, index_temp] = maxk(trilat_table.SELECT_WEIGHT, 3);
    selected_ap_name = trilat_table.NAME(index_temp);

    %%
    % 拼接ap输出
    trilateration_ap = struct();
    valid_ap_cnt = 1;

    for j = 1:1:length(selected_ap_name)
        table_index = find(strcmp(trilat_table.NAME, selected_ap_name(j)));
        rssi_temp = trilat_table.RECVRSSI(table_index, :);

        if ~isempty(find(rssi_temp))
            trilateration_ap(valid_ap_cnt).name = trilat_table.NAME(table_index);
            trilateration_ap(valid_ap_cnt).mac = trilat_table.MAC(table_index);
            trilateration_ap(valid_ap_cnt).lat = trilat_table.LAT(table_index);
            trilateration_ap(valid_ap_cnt).lon = trilat_table.LON(table_index);
            trilateration_ap(valid_ap_cnt).recv_rssi = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).rssi_reference = trilat_table.RSSI_REF(table_index);
            % 选择活跃度最大的三个ap的RSSI的均值作为定位选择输出
            % trilateration_ap(valid_ap_cnt).rssi = trilat_table.rssi(table_index);
            rssi_temp = trilat_table.RECVRSSI(table_index, :);
            rssi_temp = rssi_temp(rssi_temp ~= 0);

            if false
                trilateration_ap(valid_ap_cnt).rssi = mean(rssi_temp); % 均值滤波
            elseif true
                % 取max recieved rssi
                trilateration_ap(valid_ap_cnt).rssi = max(rssi_temp); % 最大值
            else
                rssi_temp_sorted = sort(rssi_temp); % 对非零RSSI数组进行排序

                if isequal(mod(length(rssi_temp_sorted), 2), 1)
                    % 取中值
                    index_temp = ceil(length(rssi_temp) / 2);
                    trilateration_ap(valid_ap_cnt).rssi = rssi_temp_sorted(index_temp);
                else
                    % 二分插值
                    index_temp = floor(length(rssi_temp) / 2);
                    trilateration_ap(valid_ap_cnt).rssi = mean(rssi_temp_sorted(index_temp:index_temp + 1));
                end

            end

            trilateration_ap(valid_ap_cnt).rssi_wma = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).rssi_gf = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).rssi_kf = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).dist = 0; % with a hammer dist
            valid_ap_cnt = valid_ap_cnt + 1;
        end

    end

end
