function draw_dist_area_in_beacon_space(env_feat, ...
                                        beacon_position, ...
                                        frame_ap_info, ...
                                        varargin)
%���ܣ����ݼ���ľ������ű�ռ���ƾ��뷶Χͼ
%���壺draw_dist_area_in_beacon_space(env_feat, ...
%                                     beacon_position, ...
%                                     frame_ap_info)
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
%                     beacon_position(i).name���ű�����
%                     beacon_position(i).id���ű���
%                     beacon_position(i).lat��γ��
%                     beacon_position(i).lon������
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).name����i���ű������
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%�ɱ������
%    ���鴫��,�����͸���˳��������,�����������ݸ�ʽ�����ϸ����[type, param]
%    ��ʽ,��֧�ֵĸ��鹦�����£�
%    ��һ�飺
%          ��ʽ��'true_value', true_position
%          ����˵����
%          'true_value'��λ����ֵ
%          true_position����ֵλ��,�ṹ��,�������£�
%                         true_position.lat��γ��
%                         true_position.lon������
%    �ڶ��飺
%          ��ʽ��'calc_value', calc_position
%          ����˵����
%          'calc_value'��������
%          calc_position��������,�ṹ��,�������£�
%                         true_position.lat��γ��
%                         true_position.lon������
%�����
%
%��ע��frame_ap_info(i)��beacon_position(i)��env_featԪ�ؿɶ������������ᵽ��
%     Ԫ��,��˵�������ᵽ��Ԫ�ر������

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
    beacon_name = cell(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_id(i) = beacon_position(i).id;
        beacon_lat(i) = beacon_position(i).lat;
        beacon_lon(i) = beacon_position(i).lon;
        beacon_name{i} = beacon_position(i).name;
    end
    
    %���������������
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %�����λ���ű����ʵ����
%     point = varargin{2};
%     beacon = point_to_beacon_dist(point, beacon_position);
%     
%     %ȷ����ǰap���ű��
%     beacon_num = length(beacon);
%     beacon_name = cell(beacon_num, 1);
%     beacon_id = zeros(beacon_num, 1);
%     for i = 1:beacon_num
%         beacon_name{i} = beacon(i).name;
%         beacon_id(i) = beacon(i).id;
%     end
%     
%     if length(unique(beacon_name)) ~= beacon_num
%         error('������ű꼯�д�����ͬ���Ƶ��ű�,��������֧����ͬ�����ű�Ĵ���');
%     end
%     
%     if length(unique(beacon_id)) ~= beacon_num
%         error('������ű꼯�д�����ͬ���ű��,��������֧����ͬ�ű�ŵĴ���');
%     end
%     
%     ap_num = length(frame_ap_info);
%     beacon_index = zeros(ap_num, 1);
%     for i = 1:ap_num
%         index = find(ismember(beacon_name, frame_ap_info(i).name), beacon_num);
%         if isempty(index)
%             error(['��⵽ap(', frame_ap_info(i).name, ')���ű�ռ��ڲ�����,��������֧���ű�ռ��ڲ����ڵ�ap�����ݷ���']);
%         end
%         
%         frame_ap_info(i).id = beacon_id(index);
%         frame_ap_info(i).dist = beacon(index).dist;
%         beacon_index(i) = index;
%     end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    ap_num = length(frame_ap_info);
    ap_info = repmat(struct('name', {}, 'id', 0, 'dist', 0, 'lat', 0, 'lon', 0), ap_num, 1);
    ap_name = cell(ap_num, 1);
    
    for i = 1:ap_num
        ap_name{i} = frame_ap_info(i).name;
        ap_info(i).name = frame_ap_info(i).name;
        ap_info(i).dist = frame_ap_info(i).dist;
        beacon_index = find(ismember(beacon_name, ap_info(i).name), beacon_num);
        
        if isempty(beacon_index)
            error(['ap(', ap_info(i).name, ')���ű�ռ��ڲ�����,�������ݲ�֧���ű�ռ����ap����']);
        end
        
        if length(beacon_index) > 1
            error(['�ű�ռ������ͬ���ű�(', ap_info(i).name, '),�������ݲ�֧�ֶ����ͬ�ű�']);
        end
        
        ap_info(i).id = beacon_id(beacon_index);
        ap_info(i).lat = beacon_lat(beacon_index);
        ap_info(i).lon = beacon_lon(beacon_index);
    end
    
    if length(unique(ap_name)) ~= i
        error('�����ap���д�����ͬ��ap,��������֧����ͬap�Ĵ���');
    end
    
    %�˴���Ϊ����ѭ����Ϊ�˷������
    circle_area_lat = cell(ap_num, 1);
    circle_area_lon = cell(ap_num, 1);
    theta = 0:(pi / 100):(2 * pi);
    lam = zeros(ap_num, 1);
    circle_point_num = length(theta);
    
    for i = 1:ap_num
        [x_init, y_init, lam(i)] = latlon_to_xy(ap_info(i).lat, ap_info(i).lon);
        x_tmp = x_init + ap_info(i).dist * cos(theta);
        y_tmp = y_init + ap_info(i).dist * sin(theta);
        
        circle_area_lat{i} = zeros(circle_point_num, 1);
        circle_area_lon{i} = zeros(circle_point_num, 1);
        for j = 1:circle_point_num
            [circle_area_lat{i}(j), circle_area_lon{i}(j)] = xy_to_latlon(x_tmp(j), y_tmp(j), lam(i));
        end
        
%         circle_area_x{i} = x_init * cos(theta);
%         circle_area_y{i} = y_init * sin(theta);
    end
    
    %����ɱ��
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
                    true_position = var_param{i};
                case 'calc_value'
                    calc_position = var_param{i};
                otherwise
                    error(['��֧��', var_type{i}, '���͵Ĺ���']);
            end
        end
    end
    
    %% ����
    handle = figure();
    set(handle, 'name', '�ű�ռ��ڵľ��뷶Χͼ');
    
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
    
    %����Բ�ξ�������
    for i = 1:ap_num
        x = circle_area_lon{i};
        y = circle_area_lat{i};
        
        plot(x, y, 'r-');
        hold on;
    end
    
    %���ƿɱ�ι���ͼ
    if ~isempty(varargin)
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'true_value'
                    %������ֵλ��
                    x = true_position.lon;
                    y = true_position.lat;

                    handle_true_pos = plot(x, y, 'g*');
                    hold on;
                case 'calc_value'
                    %���Ƽ�����λ��
                    x = calc_position.lon;
                    y = calc_position.lat;

                    handle_calc_pos = plot(x, y, 'r*');
                    hold on;
                otherwise
                    error(['��֧��', var_type{i}, '���͵Ĺ���']);
            end
        end
    end
    
    %����ͼʾ˵��
    if exist('handle_true_pos', 'var')
        if exist('handle_calc_pos', 'var')
            legend([handle_beacon, handle_true_pos, handle_calc_pos], ...
                   '�ű�λ��', '��ֵλ��', '������');
        else
            legend([handle_beacon, handle_true_pos], ...
                   '�ű�λ��', '��ֵλ��');
        end
    else
        if exist('handle_calc_pos', 'var')
            legend([handle_beacon, handle_calc_pos], '�ű�λ��', '������');
        else
            legend(handle_beacon, '�ű�λ��');
        end
    end
    
    title('�ű�ռ��ڵľ��뷶Χͼ');
    xlabel('γ�ȣ�lat');
    ylabel('���ȣ�lon');
    axis auto;
    axis equal;
end