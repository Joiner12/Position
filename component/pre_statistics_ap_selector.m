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
            pre_rssi_temp = ap_selector.RECVRSSI(rows + 1, :);
            recv_rssi_len = length(cur_frame_piece.recv_rssi);
            ap_selector.RECVRSSI(rows + 1, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
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
            ap_selector.RECVRSSI(index, :) = [cur_frame_piece.recv_rssi, pre_rssi_temp(1:end - recv_rssi_len)];
            ap_selector.LAT(index) = cur_frame_piece.lat;
            ap_selector.LON(index) = cur_frame_piece.lon;
            ap_selector.MAC(index) = cur_frame_piece.mac;
            ap_selector.RSSI(index) = cur_frame_piece.rssi;
            ap_selector.RSSI_REF(index) = cur_frame_piece.rssi_reference;
        end

    end

    %% 激活度
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

    %% 根据apselector信息选择定位点
    %{
        ap selector 选择依据：
        1.ap活跃度；
        2.ap rssi 统计性能；
    %}
    rssi_s = ap_selector.RECVRSSI;
    act_rssi =  zeros(0);
    for i = 1:1:size(rssi_s,1)
        act_rssi(i) = length(find(rssi_s(i,:)));
    end
    
    % rssi_s = rssi_s(rssi_s~=0);
    ap_activtion = ap_selector.ACTIVTION;

    trilateration_ap = 0;


end
