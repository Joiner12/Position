function secondary_selector()
    % 功能:
    %       根据BS(base station)的布局信息,选择最有可能作为定位BS的三点;
    % 定义:
    % ...
    beacon_s = hlk_beacon_location();
    x = zeros(0);
    y = zeros(0);
    name = cell(0);
    lat = zeros(0);
    lon = zeros(0);

    for k = 1:1:length(beacon_s)
        x(k) = beacon_s(k).x;
        y(k) = beacon_s(k).y;
        lat(k) = beacon_s(k).lat;
        lon(k) = beacon_s(k).lon;
        name{k} = beacon_s(k).name;
    end

    %  相对坐标
    for k = 1:1:length(beacon_s)
        beacon_s(k).rel_x = x(k) - min(x);
        beacon_s(k).rel_y = y(k) - min(y);
    end

    beacon_t = struct2table(beacon_s);
    % todo:需要考虑奇异解情况，三点近似位于同一直线上;
    % rel_position_x = [];
    % rel_position_y = 0;
    % 假设:距离质心欧式距离和最小的点作为选择点.
    choose_index = nchoosek(1:1:6, 4);
    % 4 in 6
    for k = 1:size(choose_index, 1)
        % 3 in 4
        select_beacon_index = nchoosek(choose_index(k, :), 3);

        for j = 1:size(select_beacon_index, 1)
            t_indextemp = select_beacon_index(j, :);
            ABC_pos = [beacon_t.rel_x(t_indextemp(1), :), beacon_t.rel_y(t_indextemp(1), :); ...
                        beacon_t.rel_x(t_indextemp(2), :), beacon_t.rel_y(t_indextemp(2), :); ...
                        beacon_t.rel_x(t_indextemp(3), :), beacon_t.rel_y(t_indextemp(3), :); ];
            fprintf('selected beacons:%s,%s,%s\n', ...
                beacon_t.name(t_indextemp(1), :), ...
                beacon_t.name(t_indextemp(2), :), ...
                beacon_t.name(t_indextemp(3), :));
            % 判断是否为近似同一条直线上点
            % todo:角度计算
            theta = cross(ABC_pos(1, :) - ABC_pos(2, :), ABC_pos(3, :) - ABC_pos(1, :));
            theta = thata / mod(ABC_pos(1, :) - ABC_pos(2, :)) / mod(ABC_pos(3, :) - ABC_pos(1, :));
            disp(asin(theta));
        end

    end

end
