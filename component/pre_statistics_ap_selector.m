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
    trilateration_ap = 0;

    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);
        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;
        % �½ڵ�
        if ~any(strcmp(selector_name, name))
            ap_selector.NAME(rows + 1) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1,:);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            ap_selector.RECVRSSI(rows + 1,:) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            ap_selector.LAT(rows + 1) = cur_frame_piece.lat;
            ap_selector.LON(rows + 1) = cur_frame_piece.lon;
            ap_selector.MAC(rows + 1) = cur_frame_piece.mac;
            ap_selector.RSSI(rows + 1) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(rows + 1) = cur_frame_piece.rssi_reference;
        else % �������нڵ�
            index = find(strcmp(selector_name, name));
            ap_selector.NAME(index) = name;
            pre_rssi_temp = ap_selector.RECVRSSI(index,:);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            ap_selector.RECVRSSI(rows + 1,:) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            ap_selector.LAT(index) = cur_frame_piece.lat;
            ap_selector.LON(index) = cur_frame_piece.lon;
            ap_selector.MAC(index) = cur_frame_piece.mac;
            ap_selector.RSSI(index) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(index) = cur_frame_piece.rssi_reference;
        end

    end

end
