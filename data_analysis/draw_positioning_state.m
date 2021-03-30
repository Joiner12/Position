function draw_positioning_state(cur_axes, cur_ap, varargin)
    % 功能:
    %       绘制三边定位过程图
    % 定义:
    %       function draw_positioning_state(cur_ap,varargin)
    % 输入:
    %       cur_ap:接入点信息([struct,struct,struct])
    %       name                 mac                  lat       lon       recv_rssi      rssi_reference    rssi     rssi_kf     dist
    %       ______________    ___________________    ______    ______    ____________    ______________    _____    _______    ______

    %       'onepos_HLK_2'    'e1:04:00:3c:d6:40'    30.548    104.06    [       -61]       -50.068          -61       -61     16.012
    %       'onepos_HLK_6'    'c2:04:00:3c:d6:40'    30.548    104.06    [       -71]       -50.068          -71       -71     16.089
    %       'onepos_HLK_4'    '1c:06:00:3c:d6:40'    30.548    104.06    [1×2 double]       -50.068        -60.5     -60.5     12.929
    %       'onepos_HLK_1'    'a0:04:00:3c:d6:40'    30.548    104.06    [       -74]       -50.068          -74       -74      59.25
    % 输出:
    %       none
    % varargin(key:value):
    % 'estimated_positon':定位结果(latitude,longitude)|(x,y)
    % 'true_pos':真实位置(latitude,longitude)|(x,y)

    %% base map

    basemap = tencent_lib_environment();
    min_xy = [2^31, 2^31];

    for i = 1:1:length(basemap)
        item_x = zeros(0);
        item_y = zeros(0);

        for j = 1:1:length(basemap{i}.position)
            item_x(j) = basemap{i}.position(j).x;
            item_y(j) = basemap{i}.position(j).y;
            % update min positon
            if min_xy(1) > min(item_x)
                min_xy(1) = min(item_x);
            end

            if min_xy(2) > min(item_y)
                min_xy(2) = min(item_y);
            end

        end

        if strcmp(basemap{i}.type, 'closed_cycle')
            item_x = reshape(item_x, [1, length(item_x)]);
            item_y = reshape(item_y, [1, length(item_y)]);
            item_x = [item_x, item_x(1)] - min_xy(1);
            item_y = [item_y, item_y(1)] - min_xy(2);
        end

        line(cur_axes, item_x, item_y) % 绘制
        hold on
    end

    %% beacon
    beacon = hlk_beacon_location();
    beacon_x = zeros(0);
    beacon_y = zeros(0);
    labels = cell(0);

    for k = 1:1:length(beacon)
        beacon_x(k) = beacon(k).x;
        beacon_y(k) = beacon(k).y;
        name_temp = beacon(k).name;
        labels{k} = strcat('anchor-', strrep(name_temp, 'onepos_HLK_', ''));
    end

    beacon_x = reshape(beacon_x, [1, length(beacon_x)]);
    beacon_y = reshape(beacon_y, [1, length(beacon_y)]);

    beacon_x_d = beacon_x - min_xy(1);
    beacon_y_d = beacon_y - min_xy(2);
    plot(cur_axes, beacon_x_d, beacon_y_d, 'g^');
    text(cur_axes, beacon_x_d, beacon_y_d, labels)

    if true
        %% circle
        hold on

        for ii = 1:1:length(cur_ap)
            ap_temp = cur_ap(ii);
            cur_color = rand(1, 3);
            index_temp = strrep(ap_temp.name, 'onepos_HLK_', '');
            index_temp = int8(str2double(index_temp));
            circles(beacon_x_d(index_temp), beacon_y_d(index_temp), ap_temp.dist, ...
                'facecolor', 'none', 'edgecolor', cur_color)
            line([beacon_x_d(index_temp), beacon_x_d(index_temp) + cos(15 * ii) * ap_temp.dist], ...
                [beacon_y_d(index_temp), beacon_y_d(index_temp) + sin(15 * ii) * ap_temp.dist], ...
                'Color', cur_color)
        end

        % 定位结果
        if any(strcmp(varargin, 'estimated_positon'))
            est_pos = varargin{find(any(strcmp(varargin, 'estimated_positon'))) + 1};
            [est_pos_x, est_pos_y, ~] = latlon_to_xy(est_pos(1), est_pos(2));
            est_pos_x = est_pos_x - min_xy(1);
            est_pos_y = est_pos_y - min_xy(2);
            plot(cur_axes, est_pos_x, est_pos_y, 'Marker', '*', ...
                'MarkerSize', 10, 'Color', 'r');
            text(cur_axes, est_pos_x, est_pos_y, '定位位置')
        end

        % 'true_pos':真实位置(latitude,longitude)|(x,y)
        if any(strcmp(varargin, 'true_pos'))
            [true_pos_x, true_pos_y, ~] = varargin{find(any(strcmp(varargin, 'true_pos'))) + 1};
            true_pos_x = true_pos_x - min_xy(1);
            true_pos_y = true_pos_y - min_xy(2);
            plot(cur_axes, true_pos_x, true_pos_y, 'b*')
            text(cur_axes, true_pos_x, true_pos_y, '真实位置')
            circles(true_pos_x, true_pos_y, 5, ...
                'facecolor', [174, 206, 187] ./ 255, 'edgecolor', 'none', 'facealpha', 0.5)
        end

    end

    hold off
    title(gca, '单帧定位效果')
    box on
    axis equal
    grid on
    set(get(gca, 'XLabel'), 'String', '笛卡尔坐标系-x/m');
    set(get(gca, 'YLabel'), 'String', '笛卡尔坐标系-y/m');
end
