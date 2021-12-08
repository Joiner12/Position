function position_error_statistics(position, true_position, varargin)
    %���ܣ�λ�����ͳ��
    %���壺position_error_statistics(position, true_position, varargin)
    %������
    %    position����ͳ�Ƶ�λ����Ϣ,�ṹ������,����Ԫ�����£�
    %              position(i).lat��γ��
    %              position(i).lon������
    %    true_position��position�и������ʵλ����Ϣ,�ṹ������,������ÿ���ṹ��Ϊ
    %                   position�ж�Ӧλ�ýṹ���ʾ��λ�õ���ֵ,��true_position(i)
    %                   Ϊposition(i)����ʵֵ,�����鳤�ȱ�����positionһ��,����Ԫ��
    %                   ���£�
    %                   true_position(i).lat��γ��
    %                   true_position(i).lon������
    %�ɱ������
    %    ���鴫��,�����͸���˳��������,�����������ݸ�ʽ�����ϸ����[type, param]
    %    ��ʽ,��֧�ֵĸ��鹦�����£�
    %    ��һ�飺
    %          ��ʽ��'filter_point', filter_points
    %          ����˵����
    %          'filter_point'����λ����
    %          filter_points�����˵ĵ�λ,��ʾ��ʽΪ�±��, ��[1, 2, 3]��ʾ���˵�
    %                         track_position(1)��track_position(2)��
    %                         track_position(3)��ʾ�ĵ�λ,������ĵ�λ�д��ڵ㲻��
    %                         λ�ü���,������ʱ����,��ֻ������λ�ü��е��ǲ��ֵ�λ
    %�����
    %

    %% �������ͳ��
    if length(position) ~= length(true_position)
        % todo:��ʵ��עλ�úͶ�λλ����Ŀ��һ��
        if false
            flag = ['λ����Ϣ������ֵ������ͬ, position:', num2str(length(position)), ...
                    ', true_position: ', num2str(length(true_position))];
            error(flag);
        else
            true_position = true_position(1:length(position));
        end

    end

    % �˵�
    filter_flag = 0;

    if any(strcmpi(varargin, 'filter_point'))
        filter_idx = varargin{find(strcmpi(varargin, 'filter_point'), 1) + 1};
        filter_dist_var = -1;
        filter_flag = 1;
        all_idx = 1:length(position);

        if isempty(filter_idx)
            filter_idx = [];
            statistics_idx = all_idx;
        end

        if ~isempty(find(ismember(filter_idx, all_idx) == 0, length(filter_idx)))
            warning('����Ĺ��˵���,���ڵ㲻��λ�ü���');
        end

        filter_idx = filter_idx(ismember(filter_idx, all_idx) == 1);
        statistics_idx = all_idx(ismember(all_idx, filter_idx) == 0);
    end

    %ͳ�Ƹ����λ�����������С�����ı�׼����ķ�����ľ�����
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

    %ͳ�Ƹ������䷶Χ��λ�õ����,ͳ�Ƶ����ݷ�Χ���£�
    %[0, 3]��,(3, 5]��,(5, 7]��,(7, 10]��,(10, 15]��,(15, 20]��,(20, ~]��,
    %�����ڹ���ֵ,ͳ�ƹ���ֵ����'����ֵ'
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

    %% �������ͳ��ͼ
    tcf('errorstatic');
    figure_visible = 'on';

    if any(strcmpi(varargin, 'figure_visible'))
        figure_visible = varargin{find(strcmpi(varargin, 'figure_visible'), 1) + 1};
    end

    % if visibleflag
    handle = figure('Color', 'w', 'Name', 'errorstatic', 'Visible', figure_visible);
    set(handle, 'name', 'λ�����ͳ��ͼ');

    %���Ƹ���������
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
        legend({'���', ...
                ['�����', num2str(max_dist), '��'], ...
                ['��С��', num2str(min_dist), '��'], ...
                ['���ı�׼�', num2str(std_dist)], ...
                ['���ķ��', num2str(var_dist)], ...
                ['���ľ�������', num2str(rms_dist)], ...
                '�����˵ĵ�λ'});
    else
        legend({'���', ...
                ['�����', num2str(max_dist), '��'], ...
                ['��С��', num2str(min_dist), '��'], ...
                ['���ı�׼�', num2str(std_dist)], ...
                ['���ķ��', num2str(var_dist)], ...
                ['���ľ�������', num2str(rms_dist)]});
    end

    title('����λ�õ�����λ���ף�');
    ylabel('����');
    axis auto;

    %������Χ�ֲ�ͼ
    subplot(2, 1, 2);
    bar(1:length(dist_rate), dist_rate);

    if filter_flag
        set(gca, 'XTickLabel', {'[0, 3]��', '(3, 5]��', '(5, 7]��', '(7, 10]��', ...
                    '(10, 15]��', '(15, 20]��', '(20, ~]��', '����ֵ'});
    else
        set(gca, 'XTickLabel', {'[0, 3]��', '(3, 5]��', '(5, 7]��', '(7, 10]��', ...
                    '(10, 15]��', '(15, 20]��', '(20, ~]��'});
    end

    for i = 1:length(dist_rate)
        str = [num2str(dist_rate(i) * 100, 3), '%(', num2str(dist_num(i)), ')'];
        text(i, dist_rate(i), str, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    end

    title('��Χ�ֲ�ͳ��');
    ylabel('��������ٷֱ�');
    axis auto;

    %% saveflag parameter
    save_figure_flag = false;

    if any(strcmpi(varargin, 'save_figure'))
        save_figure_flag = varargin{find(strcmpi(varargin, 'save_figure'), 1) + 1};
    end

    if save_figure_flag

        if any(strcmpi(varargin, 'target_pic'))
            pic_file = varargin{find(strcmpi(varargin, 'target_pic'), 1) + 1};
            saveas(handle, pic_file);
            fprintf('save figure to:%s\n', pic_file);
        end

    end

end
