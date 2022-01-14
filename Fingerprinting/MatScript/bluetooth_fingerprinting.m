classdef bluetooth_fingerprinting < handle
    % 蓝牙指纹类,用于蓝牙指纹定位
    %% 属性定义
    properties (SetAccess = private)
        frame_buffer_size; % 蓝牙数据帧大小
        frame_buffer; % cell用以保存历史蓝牙数据帧,大小由frame_buffer_size定.
    end

    %% 公有变量
    properties (SetAccess = public)
        buffer_fingerprints; % 指纹数据
    end

    %% 构造函数
    % 说明:
    %   1.初始化蓝牙数据帧buffer
    % 参数:
    %   frame_gap,蓝牙数据帧间隔;

    methods

        function obj = bluetooth_fingerprinting(frame_gap, varargin)
            obj.frame_buffer_size = frame_gap;
            obj.frame_buffer = cell(frame_gap, 1);
            obj.buffer_fingerprints = [-100, -100];
        end

    end

    %% 更新frame数据缓存
    % 说明:
    %   刷新frame数据,FIFO结构;
    % 参数:
    %   cur_frame_data,当前蓝牙数据帧
    methods (Access = public)

        function obj = update_frame_data(obj, cur_frame_data)
            date_temp = obj.frame_buffer(2:obj.frame_buffer_size, :);
            obj.frame_buffer = cell(obj.frame_buffer_size, 1);
            obj.frame_buffer{end, :} = cur_frame_data;
            obj.frame_buffer(1:obj.frame_buffer_size - 1, :) = date_temp;
            % 更新指纹数据
            obj.build_fingerprinting_info();
        end

    end

    %% 从frame buffer中构造指纹数据
    % 说明:
    %   根据buffer和ap滤波信息构造指纹数据:
    %   1.指纹库中保存的指纹信息格式:
    %      'Beacon0','Beacon1','Beacon6','Beacon7','POS'
    %      -66	-42	-62	-65	[0,0]
    %   2.指纹构造方式:
    %       依据ap名字,获取frame buffer中的所有对应RSSI,并取均值|高斯滤波值,然后拼接成指纹数据.
    % 参数:
    %   ap_filter:指定ap名字
    % 其他:
    %   具体数据结构参考bluetooth_position_main.m
    methods (Access = private)

        function obj = build_fingerprinting_info(obj, varargin)
            ap_filter = ["Beacon0", "Beacon1", "Beacon6", "Beacon7"];

            if any(strcmpi(varargin, "beacon_filter"))
                ap_filter = varargin{find(strcmpi(varargin, "beacon_filter"))};
            end

            ap_rssi_beacon0 = zeros(0); % Beacon0
            ap_rssi_beacon1 = zeros(0); % Beacon1
            ap_rssi_beacon6 = zeros(0); % Beacon6
            ap_rssi_beacon7 = zeros(0); % Beacon7

            frame_buffer_temp = cell(0);
            % 有效帧数据
            for k = 1:obj.frame_buffer_size
                cur_frame_temp = obj.frame_buffer{k, :};

                if ~isempty(cur_frame_temp)
                    frame_buffer_temp{length(frame_buffer_temp) + 1} = cur_frame_temp;
                end

            end

            % 指纹数据提取,
            % 格式:
            % [name0,name1,...,name*]
            % [rssi0,rssi1,...,rssi*]
            for j = 1:length(frame_buffer_temp)
                cur_frame_data_temp = frame_buffer_temp{j};

                for j1 = 1:length(cur_frame_data_temp)
                    cur_ap_name = cur_frame_data_temp(j1).name;
                    cur_rssi = cur_frame_data_temp(j1).recv_rssi;
                    % Beacon0
                    if strcmpi("Beacon0", cur_ap_name)
                        ap_rssi_beacon0 = append_data(ap_rssi_beacon0, cur_rssi);
                    end

                    % Beacon0
                    if strcmpi("Beacon1", cur_ap_name)
                        ap_rssi_beacon1 = append_data(ap_rssi_beacon1, cur_rssi);
                    end

                    % Beacon0
                    if strcmpi("Beacon6", cur_ap_name)
                        ap_rssi_beacon6 = append_data(ap_rssi_beacon6, cur_rssi);
                    end

                    % Beacon0
                    if strcmpi("Beacon7", cur_ap_name)
                        ap_rssi_beacon7 = append_data(ap_rssi_beacon7, cur_rssi);
                    end

                end

            end

            % 有效RSSI均值
            obj.buffer_fingerprints = [mean(ap_rssi_beacon0), ...
                                    mean(ap_rssi_beacon1), ...
                                        mean(ap_rssi_beacon6), ...
                                        mean(ap_rssi_beacon7)];
        end

    end

    %% knn分类
    % 函数:
    %   根据frame_data获取指纹信息,调用knn算法预测位置
    % 参数:
    %   None
    % 返回:
    %   relative_pos,相对位置[x,y];
    % 说明:
    %   指纹数据中的相对坐标的坐标原点是:Beacon1,坐标[30.5478754, 104.0585674];
    methods (Access = public)

        function [relative_pos, obj] = knn_prediction(obj, varargin)
            % fprintf('lalala\n');
            % knn参数设置
            n_neigherbors = 3;
            test_fingerprinting = obj.buffer_fingerprints;
            weight_select = "reverse_distance";
            % 异常处理Nan
            % 1.方式1:如果数组中有NaN元素,则relative_pos返回缺省值[-100,-100]
            % 2.方式2:将NaN元素替换为较小的一个RSSI值,RSSI_SMALL=-80dBm
            if any(isnan(test_fingerprinting))
                test_fingerprinting(isnan(test_fingerprinting)) = -80;
            end

            relative_pos = ble_knn_classify(test_fingerprinting, n_neigherbors, weight_select);

        end

    end

end

% static function
function data_appened = append_data(org_data, data_in, varargin)
    data_appened = org_data;
    in_data_len = length(data_in);
    org_data_len = length(org_data);

    if in_data_len > 1
        data_appened(org_data_len + 1:org_data_len + in_data_len) = reshape(data_in, [in_data_len, 1]);
    elseif in_data_len == 1
        data_appened(org_data_len + 1) = data_in;
    else

    end

end
