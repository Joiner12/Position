% ParseBLEData parses origin Bluetooth equipment frame data
% parse the bluetooth origin frame data
% e.g:
% ===> origin data frame
% HEAD         NAME    MAC        RSSI      LAT      LON
% ------ -------------------- ----------------- ---- -------------------- --------------------
% $APMSG onepos mi10          d1:33:c6:a3:2f:70 -76  0.0000000            0.0000000
% $APMSG onepos mate9         e7:e3:48:a6:15:55 -77  0.0000000            0.0000000
% $APMSG onepos mate9         e7:e3:48:a6:15:55 -78  0.0000000            0.0000000
% $APMSG onepos mi10          d1:33:c6:a3:2f:70 -77  0.0000000            0.0000000
% $APMSG onepos mi10          d1:33:c6:a3:2f:70 -76  0.0000000            0.0000000
% $APMSG onepos mate9         e7:e3:48:a6:15:55 -75  0.0000000            0.0000000
% $APMSG onepos mi10          d1:33:c6:a3:2f:70 -77  0.0000000            0.0000000
% $APMSG onepos mate9         e7:e3:48:a6:15:55 -78  0.0000000            0.0000000
% $APMSG onepos mi10          d1:33:c6:a3:2f:70 -77  0.0000000            0.0000000
% ===> final output data
% data : cell �� array �� struct
% struct
% {
%     string name;
%     string mac;
%     double rssi;
%     double lat;
%     double lon;
% }
classdef ParseBLEData < handle
    %%
    properties(Access=private)
        file = '';
        parsed_data = cell(0); % parsed data
    end
    %%
    properties(Access=public)
        file_name = '';
        file_path = '';
    end
    %%
    methods
        %============================================%
        function obj = ParseBLEData(file)
            %Definition:
            %  obj=ParseBLEData()
            %Paramter:
            %   file:full abspath of file,e.g: d:a\b\file.txt
            %Output:
            %   obj
            if isequal(nargin,1)
                if isfile(file)
                    obj.file = file;
                else
                    obj.file = 'not exist';
                end
                return;
            end
            
            % selet log.txt file
            [file_name, path] = uigetfile('*.txt*', ...
                'Select One or More Files', ...
                'MultiSelect', 'on');
            
            % no file selected
            if isequal(path,0) || isequal(file_name,0)
                obj.file_path = '';
                obj.file_name = cell(0);
                obj.parsed_data = cell(0);
                warning('file select canceled,no file selected')
                return;
            end
            
            % single file or multi_file
            file = cell(0);
            if ischar(file_name)
                % file = cell(length(file_name), 1);
                file{1} = [path,file_name];
            else
                for i = 1:max(size(file_name))
                    file{i} = [path, file_name{i}];
                end
            end
            
            %parse data
            data = cell(size(file));
            for i = 1:length(data)
                [data{i}, ~] = obj.bluetoothDataParsing_private(file{i});
            end
            obj.parsed_data = data;
        end
    end
    %%
    methods (Access=private)
        %============================================%
        function ShowClassInfo(~,~)
            %Definition:
            %  obj=ParseBLEData()
            %Paramter:
            %   None
            %Output:
            %   None
            disp('this is a class')
        end
        
        %============================================%
        % Function:
        %   parse origin frame into common data
        % file:
        %   originBleData.txt
        %
        % data:
        %   data from per frame
        % frame_num_total:
        %   total frame number
        function [data, frame_num_total] = bluetoothDataParsing_private(~,file)
            data = cell(0);
            frame_num_total = 0;
            if ~isfile(file)
                warning('load data from %s failed', file);
                return;
            end
            
            data_log = '$';
            ap_data_log = 'APMSG';
            frame_num = 0;
            frame_head = '  HEAD         NAME                MAC        RSSI';
            ap_num = 0;
            head_len = 6;
            name_len = 20;
            mac_len = 17;
            rssi_len = 4;
            lat_len = 20;
            data_break_len = 1;
            
            %�ж������ļ��Ƿ����
            if exist(file, 'file') ~= 2
                error('���������ļ� %s ������', file);
            end
            
            %�������ļ�
            file_handle = fopen(file, 'r');
            frame_num_total = 0;
            while ~feof(file_handle) %�ж��Ƿ�Ϊ�ļ�ĩβ
                line = fgetl(file_handle); %��ȡһ������
                
                %�ж��Ƿ�Ϊһ֡��ʼ
                if contains(line, frame_head)
                    frame_num = frame_num + 1;
                    ap_num = 0;
                    frame_num_total = frame_num_total + 1; %��֡����һ
                    continue; % todo:??
                end
                
                if contains(line, data_log) %�ж��Ƿ�Ϊ����
                    if contains(line, ap_data_log) %�ж��Ƿ�Ϊap����
                        if ~frame_num %�ж��ļ�ͷ�Ƿ����
                            fclose(file_handle);
                            error('���������ļ� %s ���ݸ�ʽ����', file);
                        end
                        
                        %ȡ����ӦԪ�ص��������ݣ�name, mac, rssi, lat, lon��
                        start_idx = head_len + data_break_len + 1;
                        end_idx = start_idx + name_len - 1;
                        name_all = line(start_idx:end_idx);
                        
                        start_idx = end_idx + data_break_len + 1;
                        end_idx = start_idx + mac_len - 1;
                        mac_all = line(start_idx:end_idx);
                        
                        start_idx = end_idx + data_break_len + 1;
                        end_idx = start_idx + rssi_len - 1;
                        rssi_all = line(start_idx:end_idx);
                        
                        start_idx = end_idx + data_break_len + 1;
                        end_idx = start_idx + lat_len - 1;
                        lat_all = line(start_idx:end_idx);
                        
                        start_idx = end_idx + data_break_len + 1;
                        lon_all = line(start_idx:end);
                        
                        %ȡ����Ӧ��ЧԪ�أ��ж������Ƿ���ȷ
                        name = strtrim(name_all);
                        
                        mac = strtrim(mac_all);
                        expression = '[:a-z0-9]';
                        match = regexp(mac, expression, 'match');
                        if length(match) ~= length(mac)
                            fclose(file_handle);
                            error('mac ���ݴ��� %s', mac);
                        end
                        
                        rssi = strtrim(rssi_all);
                        expression = '[-]|[0-9]';
                        match = regexp(rssi, expression, 'match');
                        if length(match) ~= length(rssi)
                            fclose(file_handle);
                            error('rssi ���ݴ��� %s', rssi);
                        end
                        
                        lat = strtrim(lat_all);
                        expression = '[.0-9]';
                        match = regexp(lat, expression, 'match');
                        if length(match) ~= length(lat)
                            fclose(file_handle);
                            error('lat ���ݴ��� %s', lat);
                        end
                        
                        lon = strtrim(lon_all);
                        expression = '[.0-9]';
                        match = regexp(lon, expression, 'match');
                        if length(match) ~= length(lon)
                            fclose(file_handle);
                            error('lon ���ݴ��� %s', lon);
                        end
                        
                        % adjust the struct of parsed data
                        if false || true
                            ap_num = ap_num + 1;
                            data{frame_num,1}(ap_num).name = name;
                            data{frame_num,1}(ap_num).mac = mac;
                            data{frame_num,1}(ap_num).rssi = str2double(rssi);
                            data{frame_num,1}(ap_num).lat = str2double(lat);
                            data{frame_num,1}(ap_num).lon = str2double(lon);
                        else
                            ap_num = ap_num + 1;
                            data{frame_num,1}.name = name;
                            data{frame_num,1}.mac = mac;
                            data{frame_num,1}.rssi = str2double(rssi);
                            data{frame_num,1}.lat = str2double(lat);
                            data{frame_num,1}.lon = str2double(lon);
                        end
                    end
                end
            end
            
            fclose(file_handle);
        end
    end
    %%
    methods(Access=public)
        function parseData = GetParsedData(obj,~)
            % Function:
            %   get parsed data
            % Definition:
            %   parseData = GetParsedData(obj,~)
            % Parameter:
            %   None
            if length(obj.parsed_data) < 1
                parseData = rand();
            else
                parseData = obj.parsed_data;
            end
        end
    end
end
