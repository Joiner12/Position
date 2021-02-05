function Copy_of_blu_data_analyse_dynamic()
%功能：动态数据分析。
%详细描述：蓝牙接收器在不同位置扫描数据，本函数将扫描到的不同位置的数据按ap提取，
%         并将每个ap在不同位置扫描到的rssi数据的均值绘制在图中，同时将每个ap在
%         不同位置的丢包率绘制在图中，可分析ap信号随距离的衰减趋势
%备注：待解析文件名格式必须为 *_dist，文件名中最后一个_后的dist表示数据采集距离

%获取文件
if false
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\apdata.mat');
else
    file_ap_info = struct([]); % struct
    different_ap = struct([]);
    
    % →file_name : cell
    [file_name, path] = uigetfile('*.*', 'MultiSelect', 'on');
    if ~iscell(file_name)
        tmp = file_name;
        file_name = {''};
        file_name{1} = tmp;
    end
    
    %获取每个文件的数据
    for i = 1:length(file_name)
        %获取文件名
        % file = [path, file_name{i}];
        file = strcat(path,file_name{i});
        
        %依据文件名提取数据采集的距离
        file_split = strsplit(file, '_');
        info = file_split{end};
        
        %判断文件格式是否正确（*_dist，此处还未对dist进行判断）
        if isempty(info) || (length(file_split) < 2)
            error('文件名错误：%s', file);
        end
        
        %去除文件类型（.txt .m等）
        info_split = strsplit(info, '.');
        dist = info_split{1};
        
        %判断距离信息是否正确（dist是否为有效数字）
        match = regexp(dist, '\d', 'match');
        if isempty(match) || (length(match) ~= length(dist))
            error('文件名错误：%s', file);
        end
        file_ap_info(i).dist = str2double(dist);
        
        % 单文件解析后数据 data:cell
        [data, file_ap_info(i).frame_num_total] = blu_data_file_parsing(file);
        
        % 提取出扫描到的所有数据中各个不同ap的信息
        file_ap_info(i).ap_info = extract_different_ap_info(data);
    end
    
    %按照数据采集距离和ap整理所有文件的数据
    % different_ap:struct
    different_ap = settle_different_file_ap_in_dist(file_ap_info);
    % save('apdata.mat','different_ap','file_ap_info');
    
    %整理rssi与距离数据
    different_ap_num = length(different_ap);
    ap_rssi = cell(1, different_ap_num);
    ap_dist = cell(1, different_ap_num);
    ap_frame_lose_rate = cell(1, different_ap_num);
    for i = 1:different_ap_num
        num = 0;
        for j = 1:length(different_ap(i).dist)
            if isempty(different_ap(i).frame_rssi_mean{j}) || ...
                    (different_ap(i).dist(j) == 0)
                continue;
            else
                num = num + 1;
                ap_rssi{i}{num} = different_ap(i).frame_rssi_mean{j};
                ap_dist{i}(num) = different_ap(i).dist(j);
                ap_frame_lose_rate{i}(num) = ...
                    different_ap(i).frame_lose_rate(j);
            end
        end
    end
    save apdata.mat
end
disp('load data finished');
return
%% figure-1 绘制rssi与距离的对应关系 √
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    rssi_mean = zeros(1, len);
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
    end
    % targ = [different_ap(i).name, 'rssi与距离的对应关系'];
    targ = strcat(different_ap(i).name, 'rssi与距离的对应关系');
    draw_rssi_correspondence_distance(dist,rssi_mean,targ)
end

%% figure-2绘制丢包率随距离的变化趋势图 √
for i = 1:different_ap_num
    frame_lose_rate = ap_frame_lose_rate{i};
    dist = ap_dist{i};
    targ = strcat(different_ap(i).name, '丢包率随距离的变化趋势');
    draw_packet_loss_rate(dist,frame_lose_rate,targ)
end

%% 拟合工具cftool
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    targ = strcat(different_ap(i).name, '环境参数随距离的变化趋势');
    draw_parameter_fitting(dist,rssi,targ)
end

end