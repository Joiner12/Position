function trilateration_ap = secondary_selector(pre_trilateration_ap, varargin)
    % 功能:
    %       根据BS(base station)的地理位置信息,选择最有可能作为定位BS的三点;
    % 定义:
    %       trilateration_ap = secondary_selector(pre_trilateration_ap, varargin)
    % 参数:
    %       pre_trilateration_ap,存储BS信息的结构体数组;
    %       varargin,扩展参数
    % 输出:
    %       trilateration_ap,处理后存储BS信息的结构体数组;
    % 说明:
    %       1.由于蓝牙RSSI传播过程中，会受到外部环境的影响，接收器收到的信号包含直射、折射、反射等
    %       多种分量，导致在距离较远的情况下，RSSI较大。
    %       2.ap_selector预先选择出四个BS，然后再根据BS的位置信息筛选掉RSSI较大，但真实距离相对较远
    %       的BS.
    %       3.选择依据：任意三点构成一个三角形，所构成三角形三点到质心欧式距离和最小的三角形作为选择点.
    beacon_s = pre_trilateration_ap;
    trilateration_ap = pre_trilateration_ap;

    % 待选BS数目不足，返回
    if length(pre_trilateration_ap) <= 3
        return
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
    table_cnt = 0;
    min_centroid = struct('sum_dist', intmax('uint32'), 'bs_index', [1, 2, 3]); % 最小质心距离和BS
    select_beacon_index = nchoosek(1:length(pre_trilateration_ap), 3); % 可能的三角形组合

    for j = 1:size(select_beacon_index, 1)
        t_indextemp = select_beacon_index(j, :);
        table_cnt = table_cnt + 1;
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
        end

        centroid_point = mean(ABC_pos);
        centroid_dist = zeros(0);

        for k_1 = 1:3
            centroid_dist(k_1) = norm(ABC_pos(k_1, :) - centroid_point);
        end

        if sum(centroid_dist) < min_centroid.sum_dist
            min_centroid.bs_index = t_indextemp;
        end

    end

    trilateration_ap = beacon_s(t_indextemp);
end
