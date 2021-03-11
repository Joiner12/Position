function position_error_statistics(position, true_position)
%功能：位置误差统计
%参数：
%    position：待统计的位置信息,结构体数组,具体元素如下：
%              position(i).lat：纬度
%              position(i).lon：经度
%    true_position：position中各点的真实位置信息,结构体数组,数组中每个结构体为
%                   position中对应位置结构体表示的位置的真值,即true_position(i)
%                   为position(i)的真实值,其数组长度必须与position一致,具体元素
%                   如下：
%                   true_position(i).lat：纬度
%                   true_position(i).lon：经度

    if length(position) ~= length(true_position)
        flag = ['位置信息与其真值个数不同, position:', num2str(length(position)), ...
                ', true_position: ', num2str(length(true_position))];
        error(flag);
    end

    %% 误差数据统计
    %统计个点的位置误差及最大误差、最小误差、误差的标准差、误差的方差、误差的均方根
    num = length(position);
    dist = zeros(num, 1);
    
    for i = 1:num
        dist(i) = utm_distance(position(i).lat, position(i).lon, ...
                               true_position(i).lat, true_position(i).lon);
    end
    
    max_dist = max(dist);
    min_dist = min(dist);
    std_dist = std(dist);
    var_dist = var(dist);
    rms_dist = sqrt(sum(dist.^2) / length(dist));
    
    %统计各个区间范围内位置点个数,统计的数据范围如下：
    %[0, 5]米,(5, 10]米,(10, 15]米,(15, 20]米,(20, ~]米
    dist_num = zeros(5, 1);
    dist_rate = zeros(5, 1);
    dist_num(1) = length(find(dist <= 5));
    dist_num(2) = length(find((dist > 5) & (dist <= 10)));
    dist_num(3) = length(find((dist > 10) & (dist <= 15)));
    dist_num(4) = length(find((dist > 15) & (dist <= 20)));
    dist_num(5) = length(find(dist > 20));
    
    dist_all = length(dist);
    for i = 1:5
        dist_rate(i) = dist_num(i) / dist_all;
    end
    
    %% 绘制误差统计图
    handle = figure();
    set(handle, 'name', '位置误差统计图');
    
    %绘制各个点的误差
    subplot(2, 1, 1);
    plot(dist, 'b*-');
    hold on;
    plot([1, length(dist)], [max_dist, max_dist], 'r--');
    hold on;
    plot([1, length(dist)], [min_dist, min_dist], 'g--');
    hold on;
    plot([1, length(dist)], [std_dist, std_dist], 'c--');
    hold on;
    plot([1, length(dist)], [var_dist, var_dist], 'm--');
    hold on;
    plot([1, length(dist)], [rms_dist, rms_dist], 'k--');
    hold on;
%     str = {['最大误差：', num2str(max_dist), '米'], ...
%            ['最小误差：', num2str(min_dist), '米'],  ...
%            ['误差的标准差：', num2str(std_dist)], ...
%            ['误差的方差：', num2str(var_dist)], ...
%            ['误差的均方根：', num2str(rms_dist)]};
% 
%     dim = [.6, .8, .2, .2];       
%     annotation('textbox', dim, 'String',str,'FitBoxToText','on');   
    
%     str = ['最大误差：', num2str(max_dist), '米', newline, ...
%            '最小误差：', num2str(min_dist), '米', newline, ...
%            '误差的标准差：', num2str(std_dist), newline, ...
%            '误差的方差：', num2str(var_dist), newline, ...
%            '误差的均方根：', num2str(rms_dist)];
    legend('误差', ...
           ['最大误差：', num2str(max_dist), '米'], ...
           ['最小误差：', num2str(min_dist), '米'], ...
           ['误差的标准差：', num2str(std_dist)], ...
           ['误差的方差：', num2str(var_dist)], ...
           ['误差的均方根：', num2str(rms_dist)]);
    
    title('各个位置的误差（单位：米）');
    ylabel('误差：米');
    axis auto;
    
    %绘制误差范围分布图
    subplot(2, 1, 2);
    bar(1:length(dist_rate), dist_rate);
    set(gca,'XTickLabel',{'[0, 5]米','(5, 10]米','(10, 15]米','(15, 20]米','(20, ~]米'});
    
    for i = 1:length(dist_rate)
        str = [num2str(dist_rate(i) * 100, 3), '%(', num2str(dist_num(i)), ')'];
        text(i, dist_rate(i), str, 'HorizontalAlignment','center', 'VerticalAlignment','bottom');
    end
    
    title('误差范围分布统计');
    ylabel('误差点个数百分比');
    axis auto;
    
end