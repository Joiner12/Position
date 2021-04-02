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
    trilateration_ap = 0;

    for i = 1:1:length(cur_frame)
        rows = size(ap_selector, 1);
        cur_frame_piece = cur_frame(i);
        name = string(cur_frame_piece.name);
        selector_name = ap_selector.NAME;
        % 新节点
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
        else % 更新已有节点
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
