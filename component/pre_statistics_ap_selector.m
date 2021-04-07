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
    trilateration_ap = struct();

    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);

        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;

        % �½ڵ�

        if ~any(strcmp(selector_name, name))
            ap_selector.NAME(rows + 1) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            ap_selector.RECVRSSI(rows + 1, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            ap_selector.LAT(rows + 1) = cur_frame_piece.lat;
            ap_selector.LON(rows + 1) = cur_frame_piece.lon;
            ap_selector.MAC(rows + 1) = cur_frame_piece.mac;
            ap_selector.RSSI(rows + 1) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(rows + 1) = cur_frame_piece.rssi_reference;
        else % �������нڵ�
            index = find(strcmp(selector_name, name));
            ap_selector.NAME(index) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(index, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            ap_selector.RECVRSSI(index, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            ap_selector.LAT(index) = cur_frame_piece.lat;
            ap_selector.LON(index) = cur_frame_piece.lon;
            ap_selector.MAC(index) = cur_frame_piece.mac;
            ap_selector.RSSI(index) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(index) = cur_frame_piece.rssi_reference;
        end

    end

    %% �����
    ap_names = strings(0);

    for j = 1:1:length(cur_frame)
        cur_frame_piece = cur_frame(j);
        name = string(cur_frame_piece.name);
        ap_names(j) = name;
    end

    for k = 1:1:size(ap_selector, 1)
        cur_selector_name = ap_selector.NAME(k);
        cmp_temp = strcmp(ap_names, cur_selector_name);

        if any(cmp_temp)
            ap_selector.ACTIVTION(k) = ap_selector.ACTIVTION(k) + length(find(cmp_temp));
        else

            if ap_selector.ACTIVTION(k) > 0
                ap_selector.ACTIVTION(k) = ap_selector.ACTIVTION(k) - 1;
            end

            pre_rssi_temp = ap_selector.RECVRSSI(k, :);
            ap_selector.RECVRSSI(k, :) = [0, pre_rssi_temp(1:end - 1)];
        end

    end

    %% ����apselector��Ϣѡ��λ��
    %{
    ap selector ѡ�����ݣ�
    1.ap��Ծ�ȣ�������������ЧRSSIֵ�ĸ�����
    2.ap rssi ͳ�����ܣ����أ���Ծ�� > ��ֵ > ����
    %}

    rssi_s = ap_selector.RECVRSSI;

    act_rssi = zeros(0);

    for i = 1:1:size(rssi_s, 1)
        act_rssi(i, 1) = length(find(rssi_s(i, :)));
    end

    % ƴ����������ap����Ϣ
    [~, max_points_index] = maxk(act_rssi, 3);

    for j = 1:1:length(max_points_index)
        trilateration_ap(j).name = ap_selector.NAME(max_points_index(j));
        trilateration_ap(j).mac = ap_selector.MAC(max_points_index(j));
        trilateration_ap(j).lat = ap_selector.LAT(max_points_index(j));
        trilateration_ap(j).lon = ap_selector.LON(max_points_index(j));
        trilateration_ap(j).recv_rssi = ap_selector.RSSI(max_points_index(j));
        trilateration_ap(j).rssi_reference = ap_selector.RSSI_REF(max_points_index(j));
        % ѡ���Ծ����������ap��RSSI�ľ�ֵ��Ϊ��λѡ�����
        % trilateration_ap(j).rssi = ap_selector.rssi(max_points_index(j));
        rssi_temp = ap_selector.RECVRSSI(max_points_index(j));
        rssi_temp = rssi_temp(rssi_temp ~= 0);
        trilateration_ap(j).rssi = mean(rssi_temp);
        trilateration_ap(j).rssi_wma = ap_selector.RSSI(max_points_index(j));
        trilateration_ap(j).rssi_gf = ap_selector.RSSI(max_points_index(j));
        trilateration_ap(j).rssi_kf = ap_selector.RSSI(max_points_index(j));
        trilateration_ap(j).dist = 0; % with a hammer dist
    end

end
