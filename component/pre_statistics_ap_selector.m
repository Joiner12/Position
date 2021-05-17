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
    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);

        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;

        % 新节点

        if ~any(strcmp(selector_name, name))
            ap_selector.NAME(rows + 1) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);

            if recv_rssi_len > length(ap_selector.RECVRSSI(rows + 1, :)) - 1
                ap_selector.RECVRSSI(rows + 1, :) = cur_frame_piece.recv_rssi(1:length(ap_selector.RECVRSSI(rows + 1, :)));
            else
                ap_selector.RECVRSSI(rows + 1, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            end

            ap_selector.LAT(rows + 1) = cur_frame_piece.lat;
            ap_selector.LON(rows + 1) = cur_frame_piece.lon;
            ap_selector.MAC(rows + 1) = cur_frame_piece.mac;
            ap_selector.RSSI(rows + 1) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(rows + 1) = cur_frame_piece.rssi_reference;
        else % 更新已有节点
            index = find(strcmp(selector_name, name));
            ap_selector.NAME(index) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);

            if recv_rssi_len > length(ap_selector.RECVRSSI(index, :)) - 1
                ap_selector.RECVRSSI(index, :) = cur_frame_piece.recv_rssi(1:length(ap_selector.RECVRSSI(index, :)));
            else
                ap_selector.RECVRSSI(index, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            end

            ap_selector.LAT(index) = cur_frame_piece.lat;
            ap_selector.LON(index) = cur_frame_piece.lon;
            ap_selector.MAC(index) = cur_frame_piece.mac;
            ap_selector.RSSI(index) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(index) = cur_frame_piece.rssi_reference;
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

    %%
    % rssi_statictis = zeros()
    rssi_s = trilat_table.RECVRSSI;

    act_rssi = zeros(0);
    meanval_rssi = zeros(0);
    var_rssi = zeros(0);

    for i = 1:1:size(rssi_s, 1)
        cur_rssi = rssi_s(i, :);
        cur_rssi = cur_rssi(cur_rssi ~= 0);

        if ~isempty(cur_rssi)
            act_rssi(i, 1) = length(cur_rssi);
            meanval_rssi(i, 1) = mean(cur_rssi);
            var_rssi(i, 1) = var(cur_rssi);
        end

    end

    % 重排序 & 避免使用去重复
    % 此处存在问题,act_rssi完全相等时,maxk不能达到正确排序的目的；
    [sort_act_rssi, sort_act_rssi_index] = maxk(act_rssi, 5);
    [~, sort_meanval_rssi_index] = maxk(meanval_rssi, 5);
    [~, sort_var_rssi_index] = mink(var_rssi, 5);

    % 特征值
    for j = 1:1:length(sort_act_rssi_index)
        trilat_table.CHARAC_ACT(sort_act_rssi_index(j)) = int8(sort_act_rssi(j) / 2);
        trilat_table.CHARAC_MEAN(sort_meanval_rssi_index(j)) = length(sort_meanval_rssi_index) + 1 - j;
        trilat_table.CHARAC_VAR(sort_var_rssi_index(j)) = length(sort_var_rssi_index) + 1 - j;
    end

    % 神经元
    charac_weight = [0.6, 0.3, 0.1]; % 特征值权重
    charc_temp = [trilat_table.CHARAC_ACT, trilat_table.CHARAC_MEAN, trilat_table.CHARAC_VAR];
    trilat_table.SELECT_WEIGHT = charc_temp * charac_weight';

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
            trilateration_ap(valid_ap_cnt).rssi = mean(rssi_temp);
            trilateration_ap(valid_ap_cnt).rssi_wma = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).rssi_gf = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).rssi_kf = trilat_table.RSSI(table_index);
            trilateration_ap(valid_ap_cnt).dist = 0; % with a hammer dist
            valid_ap_cnt = valid_ap_cnt + 1;
        end

        debug_line = 1;
    end

end
