function draw_point_to_beacon_dist_analysis_chart(point, ...
                                                  frame_ap_info, ...
                                                  beacon_info)
%功能：绘制点位到信标的距离分析图
%定义：draw_point_to_beacon_dist_analysis_chart(point, ...
%                                               frame_ap_info, ...
%                                               beacon_info)
%参数： 
%    point：点位经纬度,结构体,具体形式如下：
%          point.lat：纬度
%          point.lat：经度
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).name：第i个信标的名称
%                   frame_ap_info(i).lat：第i个信标的纬度
%                   frame_ap_info(i).lon：第i个信标的经度
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%    beacon_info：各个信标的位置信息,结构体数组,具体形式如下：
%                beacon_info(i).name：第i个信标的名称
%                beacon_info(i).id：第i个信标的ID号
%                beacon_info(i).lat：第i个信标的纬度
%                beacon_info(i).lon：第i个信标的经度
%输出：
%    
%备注：frame_ap_info(i)及beacon_info(i)元素可多于说明中所提到的元素,但说明中所
%     提到的元素必须存在

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
    
    %判断是否存在相同的信标
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
    end
    
    if length(unique(beacon_name)) ~= beacon_num
        error('传入的信标集中存在相同的信标,本函数不支持相同信标的处理');
    end
    
    %计算点位到信标的真实距离
    beacon = point_to_beacon_dist(point, beacon_info);
    
    %计算点位到信标的计算距离误差
    ap = point_to_beacon_dist_error(frame_ap_info, beacon);
    
    %判断是否存在相同的信标号
    ap_id = zeros(ap_num, 1);
    
    for i = 1:ap_num
        ap_id(i) = ap(i).id; 
    end
    
    if length(unique(ap_id)) ~= ap_num
        error('传入的ap集中存在ap映射到了相同的信标号,本函数不支持相同信标号的处理');
    end    
    
    %提取计算距离
    calc_dist = zeros(ap_num, 1);
    for i = 1:ap_num
        calc_dist(i) = ap(i).dist;
    end
    
    %提取真实距离
    true_dist = zeros(ap_num, 1);
    for i = 1:ap_num
        true_dist(i) = ap(i).true_dist;
    end
    
    %提取距离误差
    dist_error = zeros(ap_num, 1);
    for i = 1:ap_num
        dist_error(i) = ap(i).dist_error;
    end
    
    error_max = max(dist_error);
    error_min = min(dist_error);
    
    %% 绘制分析图
    handle = figure();
    set(handle, 'name', '点位到信标的距离分析图');
    
    %绘制距离图
    subplot(2, 1, 1);
    
    [x, sort_index] = sort(ap_id);
    y = calc_dist(sort_index);
    plot(x, y, 'r*');
    hold on;
    
    y = true_dist(sort_index);
    plot(x, y, 'g*');
    hold on;
    
    xlabel('信标号');
    ylabel('距离：米');
    legend({'计算距离', '真实距离'});
    axis auto;
    
    %绘制误差图
    subplot(2, 1, 2);
    [x, sort_index] = sort(ap_id);
    y = dist_error(sort_index);
    
    plot(x, y, 'b*-');
    hold on;
    
    y = repelem(error_max, length(x));
    plot(x, y, 'r--');
    hold on;
    
    y = repelem(error_min, length(x));
    plot(x, y, 'g--');
    hold on;
    
    xlabel('信标号');
    ylabel('距离误差：米');
    legend({'距离误差', ...
            ['距离误差最大值：', num2str(error_max)], ...
            ['距离误差最小值：', num2str(error_min)]});
    axis auto;
end