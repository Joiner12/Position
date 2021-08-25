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
            cos_theta = dot(ABC_pos(1, :) - ABC_pos(2, :), ABC_pos(3, :) - ABC_pos(1, :));
            cos_theta = cos_theta ...
                / norm(ABC_pos(1, :) - ABC_pos(2, :)) ...
                / norm(ABC_pos(3, :) - ABC_pos(1, :));
            % θ < 5° 为近似同一条直线上点
            if abs(cos_theta) >= cosd(5)
                warning('奇异结点');
            end

        end

    end

    %% k-means clustering n*p → n*1
    pos_x = beacon_t.rel_x;
    pos_y = beacon_t.rel_y;
    pos_xy = [pos_x(1:4) pos_y(1:4)];
    opts = statset('Display', 'final');
    [idx, C] = kmeans(pos_xy, 2, 'Distance', 'sqeuclidean', ...
        'Replicates', 5, 'Options', opts);
    disp('k-means');
    % tcf('clustering-1');
    % figure('color', 'white', 'name', 'clustering-1');
    % hold on
    % plot(data_rssi_x, data_rssi_y);
    % plot(data_rssi_x(idx == 1), data_rssi_y(idx == 1), 'r*', 'MarkerSize', 12)
    % plot(data_rssi_x(idx == 2), data_rssi_y(idx == 2), 'b*', 'MarkerSize', 12)
    % plot(data_rssi_x(idx == 3), data_rssi_y(idx == 3), 'c*', 'MarkerSize', 12)
    % line([1, length(data_rssi_y)], [C(1, 1), C(1, 1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '--')
    % line([1, length(data_rssi_y)], [C(2, 1), C(2, 1)], 'LineWidth', 1, 'color', 'g', 'LineStyle', '--')
    % line([1, length(data_rssi_y)], [C(3, 1), C(3, 1)], 'LineWidth', 1, 'color', 'c', 'LineStyle', '--')
    % legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 2', 'Location', 'NW')
    % title('Cluster Assignments and Origin')
    % hold off
end
