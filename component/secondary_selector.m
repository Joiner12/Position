function trilateration_ap = secondary_selector(pre_trilateration_ap, model_select, varargin)
    % 功能:
    %       1.根据BS(base station)的地理位置信息,选择最有可能作为定位BS的三点;
    %       2.删除三边定位奇异点BS组合;
    % 定义:
    %       trilateration_ap = secondary_selector(pre_trilateration_ap, varargin)
    % 参数:
    %       pre_trilateration_ap,存储BS信息的结构体数组;
    %       model_select,函数模式选择,'singularvalue'(处理奇异值问题),'selector'(次级选择器+奇异值问题)
    %       varargin,扩展参数
    % 输出:
    %       trilateration_ap,处理后存储BS信息的结构体数组;
    % 说明:
    %       1.由于蓝牙RSSI传播过程中，会受到外部环境的影响，接收器收到的信号包含直射、折射、反射等
    %       多种分量，导致在距离较远的情况下，RSSI较大。
    %       2.ap_selector预先选择出四个BS，然后再根据BS的位置信息筛选掉RSSI较大，但真实距离相对较远
    %       的BS.
    %       3.选择依据：任意三点构成一个三角形，所构成三角形三点到质心欧式距离和最小的三角形作为选择点.
    %       4.奇异值问题:输入的pre_trilateration_ap为有序节点,检查前三个节点是否在一条直线上(近似).
    beacon_s = pre_trilateration_ap;
    trilateration_ap = pre_trilateration_ap;

    % 待选BS数目不足，返回
    if length(pre_trilateration_ap) <= 3
        return;
    end

    x = zeros(0);
    y = zeros(0);

    for k = 1:1:length(beacon_s)
        [x(k), y(k), ~] = latlon_to_xy(beacon_s(k).lat, beacon_s(k).lon);
    end

    %  相对坐标
    for k = 1:1:length(beacon_s)
        beacon_s(k).rel_x = x(k) - min(x);
        beacon_s(k).rel_y = y(k) - min(y);
    end

    beacon_t = struct2table(beacon_s);

    %  nchoosek,按照的是先后循序进行组合输出
    select_beacon_index = nchoosek(1:length(pre_trilateration_ap), 3); % 可能的三角形组合

    switch model_select
            %次级选择器+奇异值问题
        case 'selector'
            min_centroid = struct('sum_dist', intmax('uint32'), 'bs_index', [1, 2, 3]); % 最小质心距离和BS

            for j = 1:size(select_beacon_index, 1)
                t_indextemp = select_beacon_index(j, :);
                ABC_pos = [beacon_t.rel_x(t_indextemp(1), :), beacon_t.rel_y(t_indextemp(1), :); ...
                            beacon_t.rel_x(t_indextemp(2), :), beacon_t.rel_y(t_indextemp(2), :); ...
                            beacon_t.rel_x(t_indextemp(3), :), beacon_t.rel_y(t_indextemp(3), :); ];

                cos_theta = dot(ABC_pos(1, :) - ABC_pos(2, :), ABC_pos(3, :) - ABC_pos(1, :));
                cos_theta = cos_theta ...
                    / norm(ABC_pos(1, :) - ABC_pos(2, :)) ...
                    / norm(ABC_pos(3, :) - ABC_pos(1, :));
                % θ < 5° 为近似同一条直线上点
                % 三边定位过程中的奇异解,由于奇异解的质心距离和相比较于正常解大,因此不用进行特别处理;
                if abs(cos_theta) >= cosd(5)
                    % warning('奇异节点');
                    continue;
                end

                centroid_point = mean(ABC_pos);
                centroid_dist = zeros(0);

                for k_1 = 1:3
                    centroid_dist(k_1) = norm(ABC_pos(k_1, :) - centroid_point);
                end

                if sum(centroid_dist) < min_centroid.sum_dist
                    min_centroid.bs_index = t_indextemp;
                    min_centroid.sum_dist = sum(centroid_dist);
                end

            end

            trilateration_ap = beacon_s(min_centroid.bs_index);
        case 'singularvalue'
            loop_cnt = 0;

            while true
                loop_cnt = loop_cnt + 1;
                t_indextemp = select_beacon_index(loop_cnt, :);
                ABC_pos = [beacon_t.rel_x(t_indextemp(1), :), beacon_t.rel_y(t_indextemp(1), :); ...
                            beacon_t.rel_x(t_indextemp(2), :), beacon_t.rel_y(t_indextemp(2), :); ...
                            beacon_t.rel_x(t_indextemp(3), :), beacon_t.rel_y(t_indextemp(3), :); ];

                cos_theta = dot(ABC_pos(1, :) - ABC_pos(2, :), ABC_pos(3, :) - ABC_pos(1, :));
                cos_theta = cos_theta ...
                    / norm(ABC_pos(1, :) - ABC_pos(2, :)) ...
                    / norm(ABC_pos(3, :) - ABC_pos(1, :));
                % θ < 5° 为近似同一条直线上点
                if abs(cos_theta) <= cosd(5) || loop_cnt > length(select_beacon_index) - 1
                    break;
                end

                if loop_cnt > 1
                    t_indextemp = linspace(1, 4, 4);
                end

            end

        otherwise
            t_indextemp = linspace(1, length(pre_trilateration_ap), length(pre_trilateration_ap));
    end

    trilateration_ap = beacon_s(t_indextemp);

end
