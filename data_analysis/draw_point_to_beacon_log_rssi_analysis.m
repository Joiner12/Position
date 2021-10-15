function draw_point_to_beacon_log_rssi_analysis(point, ...
                                                frame_ap_info, ...
                                                loss_coef, ...
                                                beacon_info)
%功能：绘制依据对数模型的rssi分析图
%定义：drwa_point_to_beacon_log_rssi_analysis(point, ...
%                                             frame_ap_info, ...
%                                             loss_coef, ...
%                                             beacon_info)
%参数： 
%    point：点位经纬度,结构体,具体形式如下：
%          point.lat：纬度
%          point.lat：经度
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).id：第i个信标的ID号
%                   frame_ap_info(i).rssi：点位接收到的第i个信标的rssi
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%                   frame_ap_info(i).rssi_reference：第i个信标的1米处rssi
%    loss_coef：路径损耗系数
%    beacon_info：各个信标的位置信息,结构体数组,具体形式如下：
%                beacon_info(i).name：第i个信标的名称
%                beacon_info(i).id：第i个信标的ID号
%                beacon_info(i).lat：第i个信标的纬度
%                beacon_info(i).lon：第i个信标的经度
%输出：
%
%备注：frame_ap_info(i)和beacon_info(i)元素可多于说明中所提到的元素,但说明中所提到的元素必须存在

    %% 数据预处理
    %判断接收到的ap数据中是否存在相同的信标
    ap_num = length(frame_ap_info);
    ap_name = cell(ap_num, 1);
    for i = 1:ap_num
       ap_name{i} = frame_ap_info(i).name; 
    end
    
    if length(unique(ap_name)) ~= ap_num
        error('传入的ap集中存在相同的ap,本函数不支持相同ap的处理');
    end    
    
    %计算点位到信标的真实距离
    beacon = point_to_beacon_dist(point, beacon_info);
    
    %确定当前ap的信标号
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    beacon_id = zeros(beacon_num, 1);
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
        beacon_id(i) = beacon_info(i).id;
    end
    
    if length(unique(beacon_name)) ~= beacon_num
        error('传入的信标集中存在相同名称的信标,本函数不支持相同名称信标的处理');
    end
    
    if length(unique(beacon_id)) ~= beacon_num
        error('传入的信标集中存在相同的信标号,本函数不支持相同信标号的处理');
    end
    
    beacon_index = zeros(ap_num, 1);
    for i = 1:ap_num
        index = find(ismember(beacon_name, frame_ap_info(i).name), beacon_num);
        if isempty(index)
            error(['检测到ap(', frame_ap_info(i).name, ')在信标空间内不存在,本函数不支持信标空间内不存在的ap的数据分析']);
        end
        
        frame_ap_info(i).id = beacon_id(index);
        beacon_index(i) = index;
    end
    
    %提取收到的真实rssi
    rssi = zeros(ap_num, 1);
    for i = 1:ap_num
        rssi(i) = frame_ap_info(i).rssi;
    end
    
    %通过计算距离逆推rssi
    for i = 1:ap_num
        frame_ap_info(i).dist = beacon(beacon_index(i)).dist;
    end
    ap = reverse_rssi_basis_log(frame_ap_info, loss_coef);
    
    %提取逆推的rssi
    reverse_log_rssi = zeros(ap_num, 1);
    for i = 1:ap_num
        reverse_log_rssi(i) = ap(i).reverse_log_rssi;
    end
    
    %提取rssi误差
    log_rssi_error = zeros(ap_num, 1);
    for i = 1:ap_num
        log_rssi_error(i) = ap(i).log_rssi_error;
    end
    
    log_rssi_error_max = max(log_rssi_error);
    log_rssi_error_min = min(log_rssi_error);
    
    %判断是否存在相同的信标号
    ap_id = zeros(ap_num, 1);
    for i = 1:ap_num
        ap_id(i) = ap(i).id;
    end
    
    if length(unique(ap_id)) ~= ap_num
        error('传入的ap集中存在ap映射到了相同的信标号,本函数不支持相同信标号的处理');
    end    
    
    %% 绘制分析图
    handle = figure();
    set(handle, 'name', '点位到信标的距离分析图');
    
    %绘制rssi图
    subplot(2, 1, 1);
    
    [x, sort_index] = sort(ap_id);
    y = rssi(sort_index);
    plot(x, y, 'r*');
    hold on;
    
    y = reverse_log_rssi(sort_index);
    plot(x, y, 'g*');
    hold on;
    
    xlabel('信标号');
    ylabel('rssi');
    legend({'检测的rssi', '依据真实距离逆推的rssi'});
    axis auto;
    
    %绘制误差图
    subplot(2, 1, 2);
    [x, sort_index] = sort(ap_id);
    y = log_rssi_error(sort_index);
    
    plot(x, y, 'b*-');
    hold on;
    
    y = repelem(log_rssi_error_max, length(x));
    plot(x, y, 'r--');
    hold on;
    
    y = repelem(log_rssi_error_min, length(x));
    plot(x, y, 'g--');
    hold on;
    
    xlabel('信标号');
    ylabel('rssi误差');
    legend({'rssi误差', ...
            ['rssi误差最大值：', num2str(log_rssi_error_max)], ...
            ['rssi误差最小值：', num2str(log_rssi_error_min)]});
    axis auto;
end