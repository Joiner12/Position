function blu_data_analyse_dynamic()
%功能：动态数据分析。
%详细描述：蓝牙接收器在不同位置扫描数据，本函数将扫描到的不同位置的数据按ap提取，
%         并将每个ap在不同位置扫描到的rssi数据的均值绘制在图中，同时将每个ap在
%         不同位置的丢包率绘制在图中，可分析ap信号随距离的衰减趋势
%备注：待解析文件名格式必须为 *_dist，文件名中最后一个_后的dist表示数据采集距离

%获取文件
% 定义全局变量，方便调试分析
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
save('apdata.mat','different_ap','file_ap_info');
disp('finished');
% return
%% 
%绘制动态分析图
handle = [];
figur_num = 0;

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

%% figure-1 绘制rssi与距离的对应关系 √
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    targ = [different_ap(i).name, ' rssi与距离的对应关系'];
    
    rssi_mean = zeros(1, len);
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
    end
    
    rssi_mean_max = max(rssi_mean);
    rssi_mean_min = min(rssi_mean);
    dist_max = max(dist);
    dist_min = min(dist);
    
    %绘制rssi基于距离dist的状态图
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, rssi_mean, 'r*-');
    if dist_min == dist_max
        dist_max = dist_max + 1;
    end
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = rssi_mean_min - 5;
    y_idx_high = rssi_mean_max + 5;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('距离');
    ylabel('rssi均值');
end

%% figure-2绘制丢包率随距离的变化趋势图 √
for i = 1:different_ap_num
    frame_lose_rate = ap_frame_lose_rate{i};
    dist = ap_dist{i};
    targ = [different_ap(i).name, ' 丢包率随距离的变化趋势'];
    
    lose_rate_max = max(frame_lose_rate);
    dist_max = max(dist);
    dist_min = min(dist);
    
    %绘制rssi基于距离dist的状态图
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, frame_lose_rate, 'r*-');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = 0;
    y_idx_high = lose_rate_max + 0.3;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    %         axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    axis auto;
    title(targ);
    xlabel('距离');
    ylabel('丢包率');
end

%% 拟合参数分析
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    
    rssi_mean = zeros(1, len);
    rssi_max = zeros(1, len);
    rssi_min = zeros(1, len);
    
    %计算各距离中各帧rssi的均值及最大最小值
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
        rssi_max(j) = max(rssi{j});
        rssi_min(j) = min(rssi{j});
    end
    %计算各个距离的环境参数
    rssi_reference = rssi_mean(1);
    loss_coef = zeros(1, len);
    for j = 2:len
        loss_coef(j) = abs(rssi_mean(j) - rssi_reference) / ...
            (10 * log10(dist(j)));
    end
    
    if len >= 2
        loss_coef(1) = loss_coef(2);
    else
        loss_coef(1) = 0;
    end
    
    log_dist_max = zeros(1, len);
    log_dist_min = zeros(1, len);
    log_dist_mean = zeros(1, len);
    log_dist_max_mean = zeros(1, len);
    log_dist_min_mean = zeros(1, len);
    log_dist_mean_mean = zeros(1, len);
    loss_coef_mean = mean(loss_coef);
    for j = 1:len
        log_dist_min(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_max(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_min_mean(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
        log_dist_max_mean(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
        log_dist_mean_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
    end
    
    %% figure-4绘制环境参数基于距离dist的变化图
    targ = [different_ap(i).name, ' 环境参数随距离的变化趋势'];
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, loss_coef, 'r*-');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = 0;
    y_idx_high = max(loss_coef) + 0.3;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('距离');
    ylabel('环境参数');
    
    %% figure-5绘制各个距离基于各自环境参数的距离范围
    targ = [different_ap(i).name, ' 在个距离的距离转换范围'];
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, log_dist_max, 'r*-');
    hold on;
    plot(dist, log_dist_min, 'b*-');
    hold on;
    plot(dist, log_dist_mean, 'g*-');
    hold on;
    plot(dist, log_dist_max_mean, 'm*-');
    hold on;
    plot(dist, log_dist_min_mean, 'c*-');
    hold on;
    plot(dist, log_dist_mean_mean, 'k*-');
    hold on;
    legend('各自环境变量转换距离最大值', '各自环境变量转换距离最小值', ...
        '各自环境变量转换距离均值', '环境变量均值转换距离最大值', ...
        '环境变量均值转换距离最小值', '环境变量均值转换距离均值');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    tmp1 = max(log_dist_max);
    tmp2 = max(log_dist_min);
    tmp3 = min(log_dist_max);
    tmp4 = min(log_dist_min);
    y_idx_low = min(tmp3, tmp4) - 1;
    y_idx_high = max(tmp1, tmp2) + 1;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('距离');
    ylabel('rssi转换后距离');
end
end