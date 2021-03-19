function draw_dist_area_in_beacon_space(env_feat, ...
                                        beacon_position, ...
                                        frame_ap_info, ...
                                        varargin)
%功能：依据计算的距离在信标空间绘制距离范围图
%定义：draw_dist_area_in_beacon_space(env_feat, ...
%                                     beacon_position, ...
%                                     frame_ap_info)
%参数： 
%    env_feat：环境特征,细胞数组,每个细胞表示一个环境区域，其数据为结构体,具体如 
%              下所示：
%              env_feat{i}.type：环境特征绘制方式,具体如下所示：
%                                'closed_cycle'：绘制闭环图线
%                                'not_closed'：绘制非闭环图线
%              env_feat{i}.position：关键点的位置信息,结构体数组,绘图时会将该
%                                    区域关键点位连接起来,连接顺序按
%                                    env_feat{i}.position顺序,即
%                                    env_feat{i}.position(1)为第一个点,
%                                    env_feat{i}.position(2)为第二个点,
%                                    以此类推,具体元素如下：
%                                    env_feat{i}.position(j).lat：纬度
%                                    env_feat{i}.position(j).lon：经度
%    beacon_position：信标位置信息,结构体数组,具体元素如下：
%                     beacon_position(i).name：信标名称
%                     beacon_position(i).id：信标编号
%                     beacon_position(i).lat：纬度
%                     beacon_position(i).lon：经度
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).name：第i个信标的名称
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%可变参数：
%    成组传入,组数和各组顺序不做限制,但各组内数据格式必须严格遵从[type, param]
%    格式,现支持的各组功能如下：
%    第一组：
%          格式：'true_value', true_position
%          参数说明：
%          'true_value'：位置真值
%          true_position：真值位置,结构体,具体如下：
%                         true_position.lat：纬度
%                         true_position.lon：经度
%    第二组：
%          格式：'calc_value', calc_position
%          参数说明：
%          'calc_value'：计算结果
%          calc_position：计算结果,结构体,具体如下：
%                         true_position.lat：纬度
%                         true_position.lon：经度
%输出：
%
%备注：frame_ap_info(i)、beacon_position(i)及env_feat元素可多于数明中所提到的
%     元素,但说明中所提到的元素必须存在

    %% 数据预处理
    %处理环境特征数据
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
                flag1 = ['环境区域', num2str(i), '的绘制方式错误：'];
                flag2 = ['环境特征的绘制方式不支持', env.type];
                error([flag1, flag2]);
        end
    end
    
    %处理信标数据
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
    
    %处理距离区域数据
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %计算点位到信标的真实距离
%     point = varargin{2};
%     beacon = point_to_beacon_dist(point, beacon_position);
%     
%     %确定当前ap的信标号
%     beacon_num = length(beacon);
%     beacon_name = cell(beacon_num, 1);
%     beacon_id = zeros(beacon_num, 1);
%     for i = 1:beacon_num
%         beacon_name{i} = beacon(i).name;
%         beacon_id(i) = beacon(i).id;
%     end
%     
%     if length(unique(beacon_name)) ~= beacon_num
%         error('传入的信标集中存在相同名称的信标,本函数不支持相同名称信标的处理');
%     end
%     
%     if length(unique(beacon_id)) ~= beacon_num
%         error('传入的信标集中存在相同的信标号,本函数不支持相同信标号的处理');
%     end
%     
%     ap_num = length(frame_ap_info);
%     beacon_index = zeros(ap_num, 1);
%     for i = 1:ap_num
%         index = find(ismember(beacon_name, frame_ap_info(i).name), beacon_num);
%         if isempty(index)
%             error(['检测到ap(', frame_ap_info(i).name, ')在信标空间内不存在,本函数不支持信标空间内不存在的ap的数据分析']);
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
            error(['ap(', ap_info(i).name, ')在信标空间内不存在,本函数暂不支持信标空间外的ap数据']);
        end
        
        if length(beacon_index) > 1
            error(['信标空间存在相同的信标(', ap_info(i).name, '),本函数暂不支持多个相同信标']);
        end
        
        ap_info(i).id = beacon_id(beacon_index);
        ap_info(i).lat = beacon_lat(beacon_index);
        ap_info(i).lon = beacon_lon(beacon_index);
    end
    
    if length(unique(ap_name)) ~= i
        error('传入的ap集中存在相同的ap,本函数不支持相同ap的处理');
    end
    
    %此处分为两个循环是为了方便调试
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
    
    %处理可变参
    if ~isempty(varargin)
        var_num = length(varargin);
        
        if mod(var_num, 2) ~= 0
            error('可变参传入个数错误');
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
                    error(['不支持', var_type{i}, '类型的功能']);
            end
        end
    end
    
    %% 绘制
    handle = figure();
    set(handle, 'name', '信标空间内的距离范围图');
    
    %绘制环境特征
    for i = 1:env_num
        x = env_lon{i};
        y = env_lat{i};
        
        plot(x, y, 'k-');
        hold on;
    end
    
    %绘制信标位置
    x = beacon_lon;
    y = beacon_lat;
    
    handle_beacon = plot(x, y, 'bs', ...
                         'LineWidth', 2,...
                         'MarkerSize', 5,...
                         'MarkerEdgeColor', 'b');
    text(x, y, num2str(beacon_id), 'color', 'r');
    hold on;
    
    %绘制圆形距离区域
    for i = 1:ap_num
        x = circle_area_lon{i};
        y = circle_area_lat{i};
        
        plot(x, y, 'r-');
        hold on;
    end
    
    %绘制可变参功能图
    if ~isempty(varargin)
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'true_value'
                    %绘制真值位置
                    x = true_position.lon;
                    y = true_position.lat;

                    handle_true_pos = plot(x, y, 'g*');
                    hold on;
                case 'calc_value'
                    %绘制计算结果位置
                    x = calc_position.lon;
                    y = calc_position.lat;

                    handle_calc_pos = plot(x, y, 'r*');
                    hold on;
                otherwise
                    error(['不支持', var_type{i}, '类型的功能']);
            end
        end
    end
    
    %设置图示说明
    if exist('handle_true_pos', 'var')
        if exist('handle_calc_pos', 'var')
            legend([handle_beacon, handle_true_pos, handle_calc_pos], ...
                   '信标位置', '真值位置', '计算结果');
        else
            legend([handle_beacon, handle_true_pos], ...
                   '信标位置', '真值位置');
        end
    else
        if exist('handle_calc_pos', 'var')
            legend([handle_beacon, handle_calc_pos], '信标位置', '计算结果');
        else
            legend(handle_beacon, '信标位置');
        end
    end
    
    title('信标空间内的距离范围图');
    xlabel('纬度：lat');
    ylabel('经度：lon');
    axis auto;
    axis equal;
end