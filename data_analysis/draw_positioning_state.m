function draw_positioning_state(cur_axes, drawmode, data, varargin)
    % ����:
    %       �������߶�λ����ͼ
    % ����:
    %       function draw_positioning_state(cur_ap,varargin)
    % ����:
    %       drawmode����ͼ����('dynamic_point'|'static'|'dynamic_line')
    %       ѡ��'static',��ͼ����Ϊ��
    %       cur_ap���������Ϣ([struct,struct,struct])
    %       name                 mac                  lat       lon       recv_rssi      rssi_reference    rssi     rssi_kf     dist
    %       ______________    ___________________    ______    ______    ____________    ______________    _____    _______    ______

    %       'onepos_HLK_2'    'e1:04:00:3c:d6:40'    30.548    104.06    [       -61]       -50.068          -61       -61     16.012
    %       'onepos_HLK_6'    'c2:04:00:3c:d6:40'    30.548    104.06    [       -71]       -50.068          -71       -71     16.089
    %       'onepos_HLK_4'    '1c:06:00:3c:d6:40'    30.548    104.06    [1��2 double]       -50.068        -60.5     -60.5     12.929
    %       'onepos_HLK_1'    'a0:04:00:3c:d6:40'    30.548    104.06    [       -74]       -50.068          -74       -74      59.25
    %       varargin
    %       ѡ��'dynamic'����ͼ����Ϊ��
    %       dynamic_data(struct{lat,lon,x,y})
    % ���:
    %       none
    % varargin(key:value):
    % 'estimated_positon':��λ���(latitude,longitude)|(x,y)
    % 'true_pos':��ʵλ��(latitude,longitude)|(x,y)

    %% base map

    basemap = tencent_lib_environment();
    min_xy = [2^31, 2^31];
    hold on

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

        line(cur_axes, item_x, item_y) % ����
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
        labels{k} = strcat('', strrep(name_temp, 'onepos_HLK_', ''));
    end

    beacon_x = reshape(beacon_x, [1, length(beacon_x)]);
    beacon_y = reshape(beacon_y, [1, length(beacon_y)]);

    beacon_x_d = beacon_x - min_xy(1);
    beacon_y_d = beacon_y - min_xy(2);
    plot(cur_axes, beacon_x_d, beacon_y_d, 'g^');
    text(cur_axes, beacon_x_d, beacon_y_d, labels)

    title(gca, '��λЧ��')
    box on
    axis equal
    grid on
    set(get(gca, 'XLabel'), 'String', '�ѿ�������ϵ-x/m');
    set(get(gca, 'YLabel'), 'String', '�ѿ�������ϵ-y/m');
    % ��λ���
    if any(strcmp(varargin, 'estimated_positon'))
        est_pos = varargin{find(strcmp(varargin, 'estimated_positon')) + 1};
        [est_pos_x, est_pos_y, ~] = latlon_to_xy(est_pos(1), est_pos(2));
        est_pos_x = est_pos_x - min_xy(1);
        est_pos_y = est_pos_y - min_xy(2);
        plot(cur_axes, est_pos_x, est_pos_y, 'Marker', '*', ...
            'MarkerSize', 10, 'Color', 'r');
        text(cur_axes, est_pos_x, est_pos_y, '��λλ��')
    end

    % 'true_pos':��ʵλ��(latitude,longitude)|(x,y)
    if any(strcmp(varargin, 'true_pos'))
        vartemp = varargin{find(strcmp(varargin, 'true_pos')) + 1};
        [true_pos_x, true_pos_y, ~] = latlon_to_xy(vartemp(1), vartemp(2));
        true_pos_x = true_pos_x - min_xy(1);
        true_pos_y = true_pos_y - min_xy(2);
        plot(cur_axes, true_pos_x, true_pos_y, 'b*')
        text(cur_axes, true_pos_x, true_pos_y, '��ʵλ��')
        circles(true_pos_x, true_pos_y, 5, ...
            'facecolor', [174, 206, 187] ./ 255, 'edgecolor', 'none', 'facealpha', 0.5)

    end

    %% ���ƶ�|��ͼ
    switch drawmode
        case 'static'
            %% circle access point
            cur_ap = data;

            for ii = 1:1:length(cur_ap)
                ap_temp = cur_ap(ii);
                cur_color = rand(1, 3);
                [c_x, c_y, ~] = latlon_to_xy(ap_temp.lat, ap_temp.lon);
                c_x = c_x - min_xy(1);
                c_y = c_y - min_xy(2);
                circles(c_x, c_y, ap_temp.dist, ...
                    'facecolor', 'none', 'edgecolor', cur_color)
                line([c_x, c_x + cos(15 * ii) * ap_temp.dist], ...
                    [c_y, c_y + sin(15 * ii) * ap_temp.dist], ...
                    'Color', cur_color)
            end

        case 'dynamic_point'
            % '��̬�켣'����̬�켣ͼ
            dynamic_data = data;
            hd = animatedline('color', [86, 141, 223] ./ 255, 'marker', '*', 'linestyle', 'none');

            for k = 1:1:length(dynamic_data)
                cur_dmx = dynamic_data{k}.x - min_xy(1);
                cur_dmy = dynamic_data{k}.y - min_xy(2);
                addpoints(hd, cur_dmx, cur_dmy);
                pause(0.1);

                if strcmpi(get(gcf, 'CurrentCharacter'), char(27))
                    disp('��ͼ��ֹ');
                    break;
                end

            end

        case 'dynamic_line'
            %% �Թ켣����kalman�˲�
            kf_data = data;
            X_state = cell(0);

            for j = 1:1:length(kf_data)

                if isequal(j, 1)
                    % kf_params = kf_init(kf_data{j}.x - min_xy(1), kf_data{j}.y - min_xy(2), 0, 0);
                    kf_params = kf_init(2, 10, 0, 0);
                else
                    kf_params = kf_update(kf_params, ...
                        [kf_data{j}.x - min_xy(1); kf_data{j}.y - min_xy(2)]);
                end

                X_state{j} = kf_params.x;
            end

            rectangle('Position', [0.8, 9, 16.5, 3], ...
                'edgecolor', 'g', 'curvature', 0.1);
            line([1, 16], [11, 11], 'Color', 'r')
            hd = animatedline('color', [86, 141, 223] ./ 255, 'marker', '*', 'linestyle', '-');

            for k = 1:1:length(X_state)
                temp = X_state{k};
                cur_dmx = temp(1);
                cur_dmy = temp(2);
                addpoints(hd, cur_dmx, cur_dmy);
                pause(0.1);

                if strcmpi(get(gcf, 'CurrentCharacter'), char(27))
                    disp('��ͼ��ֹ');
                    break;
                end

            end

    end

    hold off
end
