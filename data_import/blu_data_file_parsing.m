function [data, frame_num_total] = blu_data_file_parsing(file)
%功能：解析数据文件
%定义：[data, frame_num_total] = blu_data_file_parsing(file)
%参数：
%file：待解析的文件（包含路径，函数将直接按file_name打开文件）
%输出：
%data：解析出的每帧的数据
%frame_num_total：总帧数

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
    
    %判断数据文件是否存在
    if exist(file, 'file') ~= 2
        error('待解析的文件 %s 不存在', file);
    end
    
    %打开数据文件
    file_handle = fopen(file, 'r');
    frame_num_total = 0;
    while ~feof(file_handle) %判断是否为文件末尾
       line = fgetl(file_handle); %读取一行数据
       
       %判断是否为一帧起始
       if contains(line, frame_head) 
           frame_num = frame_num + 1;
           ap_num = 0;
           frame_num_total = frame_num_total + 1; %总帧数加一
           continue;
       end
       
       if contains(line, data_log) %判断是否为数据
           if contains(line, ap_data_log) %判断是否为ap数据
               if ~frame_num %判断文件头是否错误
                   fclose(file_handle);
                   error('待解析的文件 %s 数据格式错误', file);
               end
               
               %取出对应元素的所有数据（name, mac, rssi, lat, lon）
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
               
               %取出对应有效元素，判断数据是否正确
               name = strtrim(name_all);
               
               mac = strtrim(mac_all);
               expression = '[:a-z0-9]';
               match = regexp(mac, expression, 'match');
               if length(match) ~= length(mac)
                   fclose(file_handle);
                   error('mac 数据错误： %s', mac);
               end
               
               rssi = strtrim(rssi_all);
               expression = '[-]|[0-9]';
               match = regexp(rssi, expression, 'match');
               if length(match) ~= length(rssi)
                   fclose(file_handle);
                   error('rssi 数据错误： %s', rssi);
               end
               
               lat = strtrim(lat_all);
               expression = '[.0-9]';
               match = regexp(lat, expression, 'match');
               if length(match) ~= length(lat)
                   fclose(file_handle);
                   error('lat 数据错误： %s', lat);
               end
               
               lon = strtrim(lon_all);
               expression = '[.0-9]';
               match = regexp(lon, expression, 'match');
               if length(match) ~= length(lon)
                   fclose(file_handle);
                   error('lon 数据错误： %s', lon);
               end
               
               ap_num = ap_num + 1;
               data{frame_num}.ap_msg(ap_num).name = name;
               data{frame_num}.ap_msg(ap_num).mac = mac;
               data{frame_num}.ap_msg(ap_num).rssi = str2double(rssi);
               data{frame_num}.ap_msg(ap_num).lat = str2double(lat);
               data{frame_num}.ap_msg(ap_num).lon = str2double(lon);
           end
           
           if contains(line, true_position_log) %判断是否为真值数据
               if ~frame_num %判断文件头是否错误
                   fclose(file_handle);
                   error('待解析的文件 %s 数据格式错误', file);
               end
               
               %取出真实位置的经纬度信息
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
                   error('lat 数据错误： %s', lat);
               end
               
               lon = strtrim(lon_all);
               expression = '[.0-9]';
               match = regexp(lon, expression, 'match');
               if length(match) ~= length(lon)
                   fclose(file_handle);
                   error('lon 数据错误： %s', lon);
               end
               
               data{frame_num}.true_pos.lat = str2double(lat);
               data{frame_num}.true_pos.lon = str2double(lon);
           end
       end
    end
    
    fclose(file_handle);
end

