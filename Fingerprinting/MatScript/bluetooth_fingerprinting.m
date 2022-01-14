classdef bluetooth_fingerprinting < handle
    % ����ָ����,��������ָ�ƶ�λ
    %% ���Զ���
    properties (SetAccess = private)
        frame_buffer_size; % ��������֡��С
        frame_buffer; % cell���Ա�����ʷ��������֡,��С��frame_buffer_size��.
    end

    %% ���б���
    properties (SetAccess = public)
        buffer_fingerprints; % ָ������
    end

    %% ���캯��
    % ˵��:
    %   1.��ʼ����������֡buffer
    % ����:
    %   frame_gap,��������֡���;

    methods

        function obj = bluetooth_fingerprinting(frame_gap, varargin)
            obj.frame_buffer_size = frame_gap;
            obj.frame_buffer = cell(frame_gap, 1);
            obj.buffer_fingerprints = [-100, -100];
        end

    end

    %% ����frame���ݻ���
    % ˵��:
    %   ˢ��frame����,FIFO�ṹ;
    % ����:
    %   cur_frame_data,��ǰ��������֡
    methods (Access = public)

        function obj = update_frame_data(obj, cur_frame_data)
            date_temp = obj.frame_buffer(2:obj.frame_buffer_size, :);
            obj.frame_buffer = cell(obj.frame_buffer_size, 1);
            obj.frame_buffer{end, :} = cur_frame_data;
            obj.frame_buffer(1:obj.frame_buffer_size - 1, :) = date_temp;
            % ����ָ������
            obj.build_fingerprinting_info();
        end

    end

    %% ��frame buffer�й���ָ������
    % ˵��:
    %   ����buffer��ap�˲���Ϣ����ָ������:
    %   1.ָ�ƿ��б����ָ����Ϣ��ʽ:
    %      'Beacon0','Beacon1','Beacon6','Beacon7','POS'
    %      -66	-42	-62	-65	[0,0]
    %   2.ָ�ƹ��췽ʽ:
    %       ����ap����,��ȡframe buffer�е����ж�ӦRSSI,��ȡ��ֵ|��˹�˲�ֵ,Ȼ��ƴ�ӳ�ָ������.
    % ����:
    %   ap_filter:ָ��ap����
    % ����:
    %   �������ݽṹ�ο�bluetooth_position_main.m
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
            % ��Ч֡����
            for k = 1:obj.frame_buffer_size
                cur_frame_temp = obj.frame_buffer{k, :};

                if ~isempty(cur_frame_temp)
                    frame_buffer_temp{length(frame_buffer_temp) + 1} = cur_frame_temp;
                end

            end

            % ָ��������ȡ,
            % ��ʽ:
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

            % ��ЧRSSI��ֵ
            obj.buffer_fingerprints = [mean(ap_rssi_beacon0), ...
                                    mean(ap_rssi_beacon1), ...
                                        mean(ap_rssi_beacon6), ...
                                        mean(ap_rssi_beacon7)];
        end

    end

    %% knn����
    % ����:
    %   ����frame_data��ȡָ����Ϣ,����knn�㷨Ԥ��λ��
    % ����:
    %   None
    % ����:
    %   relative_pos,���λ��[x,y];
    % ˵��:
    %   ָ�������е�������������ԭ����:Beacon1,����[30.5478754, 104.0585674];
    methods (Access = public)

        function [relative_pos, obj] = knn_prediction(obj, varargin)
            % fprintf('lalala\n');
            % knn��������
            n_neigherbors = 3;
            test_fingerprinting = obj.buffer_fingerprints;
            weight_select = "reverse_distance";
            % �쳣����Nan
            % 1.��ʽ1:�����������NaNԪ��,��relative_pos����ȱʡֵ[-100,-100]
            % 2.��ʽ2:��NaNԪ���滻Ϊ��С��һ��RSSIֵ,RSSI_SMALL=-80dBm
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
