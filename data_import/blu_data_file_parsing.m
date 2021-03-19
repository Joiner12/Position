function [data, frame_num_total] = blu_data_file_parsing(file)
%���ܣ����������ļ�
%���壺[data, frame_num_total] = blu_data_file_parsing(file)
%������
%file�����������ļ�������·����������ֱ�Ӱ�file_name���ļ���
%�����
%data����������ÿ֡������
%frame_num_total����֡��

    data = [];
    data_log = '$';
    ap_data_log = 'APMSG';
    true_position_log = 'TRUPS';
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
           continue;
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
               
               ap_num = ap_num + 1;
               data{frame_num}.ap_msg(ap_num).name = name;
               data{frame_num}.ap_msg(ap_num).mac = mac;
               data{frame_num}.ap_msg(ap_num).rssi = str2double(rssi);
               data{frame_num}.ap_msg(ap_num).lat = str2double(lat);
               data{frame_num}.ap_msg(ap_num).lon = str2double(lon);
           end
           
           if contains(line, true_position_log) %�ж��Ƿ�Ϊ��ֵ����
               if ~frame_num %�ж��ļ�ͷ�Ƿ����
                   fclose(file_handle);
                   error('���������ļ� %s ���ݸ�ʽ����', file);
               end
               
               %ȡ����ʵλ�õľ�γ����Ϣ
               start_idx = head_len + data_break_len + ...
                           name_len + data_break_len + ...
                           mac_len + data_break_len + ...
                           rssi_len + data_break_len + 1;
               end_idx = start_idx + lat_len - 1;
               lat_all = line(start_idx:end_idx);
               
               start_idx = end_idx + data_break_len + 1;
               lon_all = line(start_idx:end);
               
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
               
               data{frame_num}.true_pos.lat = str2double(lat);
               data{frame_num}.true_pos.lon = str2double(lon);
           end
       end
    end
    
    fclose(file_handle);
end

