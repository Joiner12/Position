function [trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector, varargin)
    % ����:
    %       ������ʷAPͳ������ѡ����ж�λ��AP�㡣
    % ����:
    %       [trilateration_ap,ap_selector] = pre_statistics_ap_selector(cur_frame,ap_selector,scope,varargin)
    % ����:
    %       cur_frame: ��ǰ֡����
    %       ap_selector: ap_selector���ݣ����Ա�����ʷ����(�ṹ������)
    %       varargin����չ����
    % ���:
    %       trilateration_ap:���Զ�λ��ap��Ϣ
    %       ap_selector: ap_selector���ݣ����Ա�����ʷ����

    %%
    % ���нڵ��е�ǰ֡���������ݵĽڵ�
    updated_node_names = strings(0);

    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);

        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;
        updated_node_names(length(updated_node_names) + 1) = name;
        % �½ڵ�

        if ~any(strcmp(selector_name, name))
            ap_selector.NAME(rows + 1) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            % fifo(first in fisrt out)
            recv_rssi_temp = cur_frame_piece.recv_rssi;
            % recv_rssi_temp = fliplr(recv_rssi_temp); % ���鷭ת

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
        else % ���нڵ��е�ǰ֡����������
            index = find(strcmp(selector_name, name));
            ap_selector.NAME(index) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            % fifo(first in fisrt out)
            recv_rssi_temp = cur_frame_piece.recv_rssi;
            % recv_rssi_temp = fliplr(recv_rssi_temp); % ���鷭ת

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

    % ����ap_selector�����м�¼����ǰ֡�����ݵĽڵ�
    selector_name_temp = ap_selector.NAME(2:end);
    %selector_name_temp = selector_name(2:end); % ɾ�����п�����
    index_temp = find(~contains(selector_name_temp, updated_node_names));

    if ~isempty(index_temp)

        for k_2 = 1:length(index_temp)
            name = selector_name_temp(index_temp(k_2));
            selector_name = ap_selector.NAME;
            index = find(strcmp(selector_name, name)); %ap_selector�еĵ�ַ
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = 1;
            % fifo(first in fisrt out)
            recv_rssi_temp = 0;
            ap_selector.RECVRSSI(index, :) = [pre_rssi_temp(recv_rssi_len + 1:end), recv_rssi_temp];
        end

    end

    %% ����apselector��Ϣѡ��λ��
    %{
    ap selector ѡ�����ݣ�
    1.ap��Ծ�ȣ�������������ЧRSSIֵ�ĸ�����
    2.ap rssi ͳ�����ܣ����أ���Ծ�� > ��ֵ > ����
    %}
    trilat_table = ap_selector(2:end, :);
    trilat_table.CHARAC_ACT = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[rssi�ź��ȶ���]
    trilat_table.CHARAC_MEAN = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[RSSI��ֵ����]
    trilat_table.CHARAC_VAR = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[RSSI��������]
    trilat_table.SELECT_WEIGHT = zeros(size(trilat_table, 1), 1); % ap���Ȩ��
    % trilat_table.CALCDIST = zeros(size(trilat_table.RECVRSSI)); % �ڵ��źŽ���RSSI����
    % trilat_table.MEANVAL = zeros(size(trilat_table, 1), 1); % RSSI��ֵ
    % trilat_table.VARVAL = zeros(size(trilat_table, 1), 1); % RSSI����

    for k = 1:size(trilat_table, 1)
        rssi_s = trilat_table.RECVRSSI(k, :);
        valid_rssi = rssi_s(rssi_s ~= 0);
        % ͳһ����ֵ(��֤���Ϊ5)
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

    % ��Ԫ
    charac_weight = [0.3, 0.6, 0.1]; % ����ֵȨ��
    charc_temp = [trilat_table.CHARAC_ACT, trilat_table.CHARAC_MEAN, trilat_table.CHARAC_VAR];
    trilat_table.SELECT_WEIGHT = charc_temp * charac_weight';

    % ��λ�ڵ�������
    [~, index_temp] = maxk(trilat_table.SELECT_WEIGHT, 3);
    selected_ap_name = trilat_table.NAME(index_temp);

    %%
    % ƴ��ap���
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
            % ѡ���Ծ����������ap��RSSI�ľ�ֵ��Ϊ��λѡ�����
            % trilateration_ap(valid_ap_cnt).rssi = trilat_table.rssi(table_index);
            rssi_temp = trilat_table.RECVRSSI(table_index, :);
            rssi_temp = rssi_temp(rssi_temp ~= 0);

            if false
                trilateration_ap(valid_ap_cnt).rssi = mean(rssi_temp); % ��ֵ�˲�
            elseif true
                % ȡmax recieved rssi
                trilateration_ap(valid_ap_cnt).rssi = max(rssi_temp); % ���ֵ
            else
                rssi_temp_sorted = sort(rssi_temp); % �Է���RSSI�����������

                if isequal(mod(length(rssi_temp_sorted), 2), 1)
                    % ȡ��ֵ
                    index_temp = ceil(length(rssi_temp) / 2);
                    trilateration_ap(valid_ap_cnt).rssi = rssi_temp_sorted(index_temp);
                else
                    % ���ֲ�ֵ
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
