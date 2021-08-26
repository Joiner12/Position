function trilateration_ap = secondary_selector(pre_trilateration_ap, varargin)
    % ����:
    %       ����BS(base station)�ĵ���λ����Ϣ,ѡ�����п�����Ϊ��λBS������;
    % ����:
    %       trilateration_ap = secondary_selector(pre_trilateration_ap, varargin)
    % ����:
    %       pre_trilateration_ap,�洢BS��Ϣ�Ľṹ������;
    %       varargin,��չ����
    % ���:
    %       trilateration_ap,�����洢BS��Ϣ�Ľṹ������;
    % ˵��:
    %       1.��������RSSI���������У����ܵ��ⲿ������Ӱ�죬�������յ����źŰ���ֱ�䡢���䡢�����
    %       ���ַ����������ھ����Զ������£�RSSI�ϴ�
    %       2.ap_selectorԤ��ѡ����ĸ�BS��Ȼ���ٸ���BS��λ����Ϣɸѡ��RSSI�ϴ󣬵���ʵ������Խ�Զ
    %       ��BS.
    %       3.ѡ�����ݣ��������㹹��һ�������Σ����������������㵽����ŷʽ�������С����������Ϊѡ���.
    beacon_s = pre_trilateration_ap;
    trilateration_ap = pre_trilateration_ap;

    % ��ѡBS��Ŀ���㣬����
    if length(pre_trilateration_ap) <= 3
        return
    end

    x = zeros(0);
    y = zeros(0);

    for k = 1:1:length(beacon_s)
        [x(k), y(k), ~] = latlon_to_xy(beacon_s(k).lat, beacon_s(k).lon);
    end

    %  �������
    for k = 1:1:length(beacon_s)
        beacon_s(k).rel_x = x(k) - min(x);
        beacon_s(k).rel_y = y(k) - min(y);
    end

    beacon_t = struct2table(beacon_s);
    table_cnt = 0;
    min_centroid = struct('sum_dist', intmax('uint32'), 'bs_index', [1, 2, 3]); % ��С���ľ����BS
    select_beacon_index = nchoosek(1:length(pre_trilateration_ap), 3); % ���ܵ����������

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
        % �� < 5�� Ϊ����ͬһ��ֱ���ϵ�
        % ���߶�λ�����е������,�������������ľ������Ƚ����������,��˲��ý����ر���;
        if abs(cos_theta) >= cosd(5)
            % warning('����ڵ�');
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
