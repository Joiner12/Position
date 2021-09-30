function position_error_statistics(position, true_position, varargin)
    %功能：位置误差统计
    %定义：position_error_statistics(position, true_position, varargin)
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
    %可变参数：
    %    成组传入,组数和各组顺序不做限制,但各组内数据格式必须严格遵从[type, param]
    %    格式,现支持的各组功能如下：
    %    第一组：
    %          格式：'filter_point', filter_points
    %          参数说明：
    %          'filter_point'：点位过滤
    %          filter_points：过滤的点位,表示方式为下标号, 即[1, 2, 3]表示过滤掉
    %                         track_position(1)、track_position(2)、
    %                         track_position(3)表示的点位,若传入的点位中存在点不在
    %                         位置集中,则运行时警告,并只过滤在位置集中的那部分点位
    %输出：
    %

    %% 误差数据统计
    if length(position) ~= length(true_position)
        flag = ['位置信息与其真值个数不同, position:', num2str(length(position)), ...
                ', true_position: ', num2str(length(true_position))];
        error(flag);
    end

    %处理可变参
    filter_flag = 0;

    if ~isempty(varargin)
        var_num = length(varargin);

        if mod(var_num, 2) ~= 0
            error('可变参传入个数错误');
        end

        var_type = cell(var_num / 2, 1);
        var_param = cell(var_num / 2, 1);
        var_type(:) = varargin(1:2:end);
        var_param(:) = varargin(2:2:end);

        for i = 1:(var_num / 2)

            switch var_type{i}
                case 'filter_point'
                    filter_dist_var = -1;
                    filter_flag = 1;
                    all_idx = 1:length(position);
                    filter_idx = var_param{i};

                    if isempty(filter_idx)
                        filter_idx = [];
                        statistics_idx = all_idx;
                        continue;
                    end

                    if ~isempty(find(ismember(filter_idx, all_idx) == 0, length(filter_idx)))
                        warning('输入的过滤点中,存在点不在位置集内');
                    end

                    filter_idx = filter_idx(ismember(filter_idx, all_idx) == 1);
                    statistics_idx = all_idx(ismember(all_idx, filter_idx) == 0);
                otherwise
                    error(['不支持', var_type{i}, '类型的功能']);
            end

        end

    end

    %统计个点的位置误差及最大误差、最小误差、误差的标准差、误差的方差、误差的均方根
    num = length(position);
    dist = zeros(num, 1);

    for i = 1:num
        position_temp = position{i};
        % dist(i) = utm_distance(position(i).lat, position(i).lon, ...
        %     true_position(i).lat, true_position(i).lon);
        dist(i) = utm_distance(position_temp.lat, position_temp.lon, ...
            true_position(i).lat, true_position(i).lon);

    end

    if filter_flag
        error_statistics_dist = dist(statistics_idx);
        dist(filter_idx) = filter_dist_var;
    else
        error_statistics_dist = dist;
    end

    error_statistics_dist = error_statistics_dist(~isnan(error_statistics_dist));
    max_dist = max(error_statistics_dist);
    min_dist = min(error_statistics_dist);
    std_dist = std(error_statistics_dist);
    var_dist = var(error_statistics_dist);
    rms_dist = sqrt(sum(error_statistics_dist.^2) / length(error_statistics_dist));

    %统计各个区间范围内位置点个数,统计的数据范围如下：
    %[0, 3]米,(3, 5]米,(5, 7]米,(7, 10]米,(10, 15]米,(15, 20]米,(20, ~]米,
    %若存在过滤值,统计过滤值个数'过滤值'
    section_num = 7;

    if filter_flag
        section_num = section_num + 1;
    end

    dist_num = zeros(section_num, 1);
    dist_rate = zeros(section_num, 1);
    dist_num(1) = length(find(error_statistics_dist <= 3));
    dist_num(2) = length(find((error_statistics_dist > 3) & (error_statistics_dist <= 5)));
    dist_num(3) = length(find((error_statistics_dist > 5) & (error_statistics_dist <= 7)));
    dist_num(4) = length(find((error_statistics_dist > 7) & (error_statistics_dist <= 10)));
    dist_num(5) = length(find((error_statistics_dist > 10) & (error_statistics_dist <= 15)));
    dist_num(6) = length(find((error_statistics_dist > 15) & (error_statistics_dist <= 20)));
    dist_num(7) = length(find(error_statistics_dist > 20));

    if filter_flag
        dist_num(8) = length(filter_idx);
    end

    dist_all = length(dist);

    for i = 1:section_num
        dist_rate(i) = dist_num(i) / dist_all;
    end

    %% 绘制误差统计图
    handle = figure('color', 'w');
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

    if filter_flag
        plot([1, length(dist)], [filter_dist_var, filter_dist_var], 'y--');
        hold on;
    end

    if filter_flag
        legend({'误差', ...
                ['最大误差：', num2str(max_dist), '米'], ...
                ['最小误差：', num2str(min_dist), '米'], ...
                ['误差的标准差：', num2str(std_dist)], ...
                ['误差的方差：', num2str(var_dist)], ...
                ['误差的均方根：', num2str(rms_dist)], ...
                '被过滤的点位'});
    else
        legend({'误差', ...
                ['最大误差：', num2str(max_dist), '米'], ...
                ['最小误差：', num2str(min_dist), '米'], ...
                ['误差的标准差：', num2str(std_dist)], ...
                ['误差的方差：', num2str(var_dist)], ...
                ['误差的均方根：', num2str(rms_dist)]});
    end

    title('各个位置的误差（单位：米）');
    ylabel('误差：米');
    axis auto;

    %绘制误差范围分布图
    subplot(2, 1, 2);
    bar(1:length(dist_rate), dist_rate);

    if filter_flag
        set(gca, 'XTickLabel', {'[0, 3]米', '(3, 5]米', '(5, 7]米', '(7, 10]米', ...
                    '(10, 15]米', '(15, 20]米', '(20, ~]米', '过滤值'});
    else
        set(gca, 'XTickLabel', {'[0, 3]米', '(3, 5]米', '(5, 7]米', '(7, 10]米', ...
                    '(10, 15]米', '(15, 20]米', '(20, ~]米'});
    end

    for i = 1:length(dist_rate)
        str = [num2str(dist_rate(i) * 100, 3), '%(', num2str(dist_num(i)), ')'];
        text(i, dist_rate(i), str, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end

    title('误差范围分布统计');
    ylabel('误差点个数百分比');
    axis auto;

    % 保存结果
    system_config = sys_config();
    if system_config.save_position_error_statistics_pic
        saveas(handle, system_config.position_error_statistics_pic)
    end

end
