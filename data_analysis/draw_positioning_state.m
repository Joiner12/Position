function f1 = draw_positioning_state(drawmode, data, varargin)
    % ����:
    %       �������߶�λ����ͼ
    % ����:
    %       f1 = draw_positioning_state(drawmode, data, varargin)
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
    %       f1,figure
    % varargin(key:value):
    % 'estimated_positon':��λ���(latitude,longitude)|(x,y)
    % 'true_pos':��ʵλ��(latitude,longitude)|(x,y)
    % 'visible',�Ƿ���ʾfigure
    % 'pic_file',���浱ǰfigureΪ�����ļ���ʽ

    %% Visible
    visible_flag = true;

    if any(strcmpi(varargin, 'visible'))
        visible_flag = varargin{find(strcmpi(varargin, 'visible'), 1) + 1};
    end

    tcf('Positining');
    f1 = figure('name', 'Positining', 'Color', 'w', 'Visible', visible_flag);
    hold on
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

    % base map
    % ref_point_xy = [beacon_x(1).x, beacon_y(1).y]; % ��ope1�ű�Ϊ�ο�(0,0)λ��
    ref_point_xy = [min(beacon_x), min(beacon_y)]; % ����Сx����Сy��Ϊ�ο�λ��
    beacon_x = reshape(beacon_x, [1, length(beacon_x)]);
    beacon_y = reshape(beacon_y, [1, length(beacon_y)]);

    beacon_x_d = beacon_x - ref_point_xy(1);
    beacon_y_d = beacon_y - ref_point_xy(2);
    plot(beacon_x_d, beacon_y_d, 'LineStyle', 'none', ...
        'Marker', 'v', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
    text(beacon_x_d, beacon_y_d, labels)
    % circle[X;Y]
    circle_line = [-1, -1, 17, 17, -1; -1, 9, 9, -1, -1];
    line(circle_line(1, :), circle_line(2, :), 'LineWidth', 2);
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
        est_pos_x = est_pos_x - ref_point_xy(1);
        est_pos_y = est_pos_y - ref_point_xy(2);
        plot(est_pos_x, est_pos_y, 'Marker', '*', ...
            'MarkerSize', 10, 'Color', 'r');
        text(est_pos_x, est_pos_y, '��λλ��')
    end

    % 'true_pos':��ʵλ��(latitude,longitude)|(x,y)
    if any(strcmp(varargin, 'true_pos'))
        vartemp = varargin{find(strcmp(varargin, 'true_pos')) + 1};
        [true_pos_x, true_pos_y, ~] = latlon_to_xy(vartemp(1), vartemp(2));
        true_pos_x = true_pos_x - ref_point_xy(1);
        true_pos_y = true_pos_y - ref_point_xy(2);
        plot(true_pos_x, true_pos_y, 'b*')
        text(true_pos_x, true_pos_y, '��ʵλ��')
        circles(true_pos_x, true_pos_y, 3, ...
            'facecolor', [174, 206, 187] ./ 255, 'edgecolor', 'none', 'facealpha', 0.5)

    end

    % ��̬�ο��켣
    % rectangle('Position', [0.8, 8, 30, 5], ...
        %     'edgecolor', 'g', 'curvature', 0.1);
    % line([2, 23], [10, 10], 'Color', 'r', 'LineWidth', 1.8)
    % line([23, 23], [3, 10], 'Color', 'r', 'LineWidth', 1.8)
    % line([2, 2], [1, 10], 'Color', 'r', 'LineWidth', 1.8)
    %% ���ƶ�|��ͼ
    if isempty(data)
        warning("��ͼ����Ϊ��");
        return;
    end

    switch drawmode
        case 'static'
            %% circle access point
            cur_ap = data;

            for ii = 1:1:length(cur_ap)
                ap_temp = cur_ap(ii);
                cur_color = rand(1, 3);
                [c_x, c_y, ~] = latlon_to_xy(ap_temp.lat, ap_temp.lon);
                c_x = c_x - ref_point_xy(1);
                c_y = c_y - ref_point_xy(2);
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
                cur_dmx = dynamic_data{k}.x - ref_point_xy(1);
                cur_dmy = dynamic_data{k}.y - ref_point_xy(2);
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
                    % kf_params = kf_init(kf_data{j}.x - ref_point_xy(1), kf_data{j}.y - ref_point_xy(2), 0, 0);
                    kf_params = kf_init(20, 5, 0, 0);
                else
                    kf_params = kf_update(kf_params, ...
                        [kf_data{j}.x - ref_point_xy(1); kf_data{j}.y - ref_point_xy(2)]);
                end

                X_state{j} = kf_params.x;
            end

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
    %% saveflag parameter

    if any(strcmpi(varargin, 'target_pic'))
        pic_file = varargin{find(strcmpi(varargin, 'target_pic'), 1) + 1};
        saveas(f1, pic_file);
        fprintf('save figure to:%s\n', pic_file);
    end

end
