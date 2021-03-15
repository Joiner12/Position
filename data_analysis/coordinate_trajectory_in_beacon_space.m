function coordinate_trajectory_in_beacon_space(env_feat, ...
                                               beacon_position, ...
                                               track_position, ...
                                               draw_type, ...
                                               varargin)
%���ܣ��ű�ռ��ڵ�����켣
%���壺coordinate_trajectory_in_beacon_space(env_feat, ...
%                                            beacon_position, ...
%                                            track_position, ...
%                                            draw_type, ...
%                                            varargin)
%������
%    env_feat����������,ϸ������,ÿ��ϸ����ʾһ����������������Ϊ�ṹ��,������ 
%              ����ʾ��
%              env_feat{i}.type�������������Ʒ�ʽ,����������ʾ��
%                                'closed_cycle'�����Ʊջ�ͼ��
%                                'not_closed'�����ƷǱջ�ͼ��
%              env_feat{i}.position���ؼ����λ����Ϣ,�ṹ������,��ͼʱ�Ὣ��
%                                    ����ؼ���λ��������,����˳��
%                                    env_feat{i}.position˳��,��
%                                    env_feat{i}.position(1)Ϊ��һ����,
%                                    env_feat{i}.position(2)Ϊ�ڶ�����,
%                                    �Դ�����,����Ԫ�����£�
%                                    env_feat{i}.position(j).lat��γ��
%                                    env_feat{i}.position(j).lon������
%    beacon_position���ű�λ����Ϣ,�ṹ������,����Ԫ�����£�
%                     beacon_position(i).id���ű���
%                     beacon_position(i).lat��γ��
%                     beacon_position(i).lon������
%    track_position�������켣��λ����Ϣ,�ṹ������,����Ԫ�����£�
%                    track_position(i).lat��γ��
%                    track_position(i).lon������
%    draw_type���켣���Ʒ�ʽ,�������£�
%               'splashes'������ɢ�㣬�����ƹ켣
%               'trajectory'�����ƹ켣���켣����˳��track_position˳��,��
%                             track_position(1)Ϊ��һ�����λ��,track_position(2)
%                             Ϊ�ڶ������λ��,�Դ�����
%�ɱ������
%    ���鴫��,�����͸���˳��������,�����������ݸ�ʽ�����ϸ����[type, param]
%    ��ʽ,��֧�ֵĸ��鹦�����£�
%    ��һ�飺
%          ��ʽ��'true_value', true_position
%          ����˵����
%          'true_value'���켣��ֵ
%          true_position����ֵλ��,�ṹ������,���Ʒ�ʽ���draw_type,��ֵ��켣
%                         λ�õĶ�Ӧ��ϵ��ʹ���߿���,�������£�
%                         true_position(i).lat��γ��
%                         true_position(i).lon������
%    �ڶ��飺
%          ��ʽ��'filter_point', filter_points
%          ����˵����
%          'filter_point'����λ����
%          filter_points�����˵ĵ�λ,��ʾ��ʽΪ�±��, ��[1, 2, 3]��ʾ���˵�
%                         track_position(1)��track_position(2)��
%                         track_position(3)��ʾ�ĵ�λ,������ĵ�λ�д��ڵ㲻��
%                         �켣����,������ʱ����,��ֻ�����ڹ켣���е��ǲ��ֵ�λ
%�����
%

    %% ����Ԥ����
    %��������������
    env_num = length(env_feat);
    env_lat = cell(env_num, 1);
    env_lon = cell(env_num, 1);
    env_type = cell(env_num, 1);
    
    for i = 1:env_num
        env = env_feat{i};
        env_type{i} = env.type;
        point_num = length(env.position);
        
        tmp_lat = zeros(point_num, 1);
        tmp_lon = zeros(point_num, 1);
        for j = 1:point_num
            tmp_lat(j) = env.position(j).lat;
            tmp_lon(j) = env.position(j).lon;
        end
        
        switch env.type
            case 'closed_cycle'
                env_lat{i} = zeros(point_num + 1, 1);
                env_lon{i} = zeros(point_num + 1, 1);
                
                env_lat{i}(1:point_num) = tmp_lat;
                env_lon{i}(1:point_num) = tmp_lon;
                env_lat{i}(end) = tmp_lat(1);
                env_lon{i}(end) = tmp_lon(1);
            case 'not_closed'
                env_lat{i} = tmp_lat;
                env_lon{i} = tmp_lon;
            otherwise
                flag1 = ['��������', num2str(i), '�Ļ��Ʒ�ʽ����'];
                flag2 = ['���������Ļ��Ʒ�ʽ��֧��', env.type];
                error([flag1, flag2]);
        end
    end
    
    %�����ű�����
    beacon_num = length(beacon_position);
    beacon_id = zeros(beacon_num, 1);
    beacon_lat = zeros(beacon_num, 1);
    beacon_lon = zeros(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_id(i) = beacon_position(i).id;
        beacon_lat(i) = beacon_position(i).lat;
        beacon_lon(i) = beacon_position(i).lon;
    end
    
    %����ɱ������
    track_pos = track_position;
    if ~isempty(varargin)
        var_num = length(varargin);
        
        if mod(var_num, 2) ~= 0
            error('�ɱ�δ����������');
        end
        
        var_type = cell(var_num / 2, 1);
        var_param = cell(var_num / 2, 1);
        var_type(:) = varargin(1:2:end);
        var_param(:) = varargin(2:2:end);
        
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'true_value'
                    true_var_num = length(var_param{i});
                    true_var_lat = zeros(true_var_num, 1);
                    true_var_lon = zeros(true_var_num, 1);
                    
                    for j = 1:true_var_num
                        true_var_lat(j) = var_param{i}(j).lat;
                        true_var_lon(j) = var_param{i}(j).lon;
                    end
                case 'filter_point'
                    all_idx = 1:length(track_position);
                    filter_idx = var_param{i};
                    
                    if isempty(filter_idx)
                        filter_lat = [];
                        filter_lon = [];
                        continue;
                    end
                    
                    if ~isempty(find(ismember(filter_idx, all_idx) == 0, length(filter_idx)))
                        warning('����Ĺ��˵���,���ڵ㲻�ڹ켣����');
                    end
                    
                    filter_idx = filter_idx(ismember(filter_idx, all_idx) == 1);
                    track_idx = all_idx(ismember(all_idx, filter_idx) == 0);
                    
                    track_pos = track_position(track_idx);
                    filter_pos = track_position(filter_idx);
                    
                    filter_num = length(filter_pos);
                    filter_lat = zeros(filter_num, 1);
                    filter_lon = zeros(filter_num, 1);
                    for j = 1:filter_num
                        filter_lat(j) = filter_pos(j).lat;
                        filter_lon(j) = filter_pos(j).lon;
                    end
                otherwise
                    error(['��֧��', var_type{i}, '���͵Ĺ���']);
            end
        end
    end
    
    %����켣����
    track_num = length(track_pos);
    track_lat = zeros(track_num, 1);
    track_lon = zeros(track_num, 1);
    
    for i = 1:track_num
        track_lat(i) = track_pos(i).lat;
        track_lon(i) = track_pos(i).lon;
    end
    
    %% ����
    handle = figure();
    set(handle, 'name', '�ű�ռ��ڵ�����켣');
    
    switch draw_type
        case 'splashes'
            plot_linetype = '*';
        case 'trajectory'
            plot_linetype = '*-';
        otherwise
            error(['�켣���Ʒ�ʽ��֧��', draw_type]);
    end
    
    %���ƻ�������
    for i = 1:env_num
        x = env_lon{i};
        y = env_lat{i};
        
        plot(x, y, 'k-');
        hold on;
    end
    
    %�����ű�λ��
    x = beacon_lon;
    y = beacon_lat;
    
    handle_beacon = plot(x, y, 'bs', ...
                         'LineWidth', 2,...
                         'MarkerSize', 5,...
                         'MarkerEdgeColor', 'b');
    text(x, y, num2str(beacon_id), 'color', 'r');
    hold on;
    
    %���ƹ켣
    plot_color = 'r';
    plot_linespec = [plot_color, plot_linetype];
    x = track_lon;
    y = track_lat;
    
    handle_track = plot(x, y, plot_linespec);
    legend(handle_track, '�켣');
    hold on;
    
    %���ƿɱ�ι���ͼ
    if ~isempty(varargin)
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'true_value'
                    %������ֵͼ
                    plot_color = 'g';
                    plot_linespec = [plot_color, plot_linetype];
                    x = true_var_lon;
                    y = true_var_lat;

                    handle_true_pos = plot(x, y, plot_linespec);
                    legend(handle_true_pos, '��ʵλ��');
                    hold on;
                case 'filter_point'
                    x = filter_lon;
                    y = filter_lat;

                    handle_filter_pos = plot(x, y, 'cx');
                    legend(handle_filter_pos, '�����˵�λ��');
                    hold on;
                otherwise
                    error(['��֧��', var_type{i}, '���͵Ĺ���']);
            end
        end
    end
    
    %����ͼʾ˵��
    if exist('handle_true_pos', 'var')
        if exist('handle_filter_pos', 'var')
            legend([handle_beacon, handle_track, handle_true_pos, handle_filter_pos], ...
                   '�ű�λ��', '�켣', '��ֵλ��', '�����˵�λ��');
        else
            legend([handle_beacon, handle_track, handle_true_pos], ...
                   '�ű�λ��', '�켣', '��ֵλ��');
        end
    else
        if exist('handle_filter_pos', 'var')
            legend([handle_beacon, handle_track], '�ű�λ��', '�켣', '�����˵�λ��');
        else
            legend([handle_beacon, handle_track], '�ű�λ��', '�켣');
        end
    end
    
    title('�ű�ռ��ڵ�����켣');
    xlabel('γ�ȣ�lat');
    ylabel('���ȣ�lon');
    axis auto;
end