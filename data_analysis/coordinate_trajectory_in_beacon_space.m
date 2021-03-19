function coordinate_trajectory_in_beacon_space(env_feat, ...
                                               beacon_position, ...
                                               track_position, ...
                                               draw_type, ...
                                               varargin)
%功能：信标空间内的坐标轨迹
%定义：coordinate_trajectory_in_beacon_space(env_feat, ...
%                                            beacon_position, ...
%                                            track_position, ...
%                                            draw_type, ...
%                                            varargin)
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
%                     beacon_position(i).id：信标编号
%                     beacon_position(i).lat：纬度
%                     beacon_position(i).lon：经度
%    track_position：待画轨迹的位置信息,结构体数组,具体元素如下：
%                    track_position(i).lat：纬度
%                    track_position(i).lon：经度
%    draw_type：轨迹绘制方式,具体如下：
%               'splashes'：绘制散点，不绘制轨迹
%               'trajectory'：绘制轨迹，轨迹连接顺序按track_position顺序,即
%                             track_position(1)为第一个点的位置,track_position(2)
%                             为第二个点的位置,以此类推
%可变参数：
%    成组传入,组数和各组顺序不做限制,但各组内数据格式必须严格遵从[type, param]
%    格式,现支持的各组功能如下：
%    第一组：
%          格式：'true_value', true_position
%          参数说明：
%          'true_value'：轨迹真值
%          true_position：真值位置,结构体数组,绘制方式遵从draw_type,真值与轨迹
%                         位置的对应关系由使用者控制,具体如下：
%                         true_position(i).lat：纬度
%                         true_position(i).lon：经度
%    第二组：
%          格式：'filter_point', filter_points
%          参数说明：
%          'filter_point'：点位过滤
%          filter_points：过滤的点位,表示方式为下标号, 即[1, 2, 3]表示过滤掉
%                         track_position(1)、track_position(2)、
%                         track_position(3)表示的点位,若传入的点位中存在点不在
%                         轨迹集中,则运行时警告,并只过滤在轨迹集中的那部分点位
%输出：
%

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
    
    for i = 1:beacon_num
        beacon_id(i) = beacon_position(i).id;
        beacon_lat(i) = beacon_position(i).lat;
        beacon_lon(i) = beacon_position(i).lon;
    end
    
    %处理可变参数据
    track_pos = track_position;
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
                        warning('输入的过滤点中,存在点不在轨迹集内');
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
                    error(['不支持', var_type{i}, '类型的功能']);
            end
        end
    end
    
    %处理轨迹数据
    track_num = length(track_pos);
    track_lat = zeros(track_num, 1);
    track_lon = zeros(track_num, 1);
    
    for i = 1:track_num
        track_lat(i) = track_pos(i).lat;
        track_lon(i) = track_pos(i).lon;
    end
    
    %% 绘制
    handle = figure();
    set(handle, 'name', '信标空间内的坐标轨迹');
    
    switch draw_type
        case 'splashes'
            plot_linetype = '*';
        case 'trajectory'
            plot_linetype = '*-';
        otherwise
            error(['轨迹绘制方式不支持', draw_type]);
    end
    
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
    
    %绘制轨迹
    plot_color = 'r';
    plot_linespec = [plot_color, plot_linetype];
    x = track_lon;
    y = track_lat;
    
    handle_track = plot(x, y, plot_linespec);
    legend(handle_track, '轨迹');
    hold on;
    
    %绘制可变参功能图
    if ~isempty(varargin)
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'true_value'
                    %绘制真值图
                    plot_color = 'g';
                    plot_linespec = [plot_color, plot_linetype];
                    x = true_var_lon;
                    y = true_var_lat;

                    handle_true_pos = plot(x, y, plot_linespec);
                    legend(handle_true_pos, '真实位置');
                    hold on;
                case 'filter_point'
                    x = filter_lon;
                    y = filter_lat;

                    handle_filter_pos = plot(x, y, 'cx');
                    legend(handle_filter_pos, '被过滤的位置');
                    hold on;
                otherwise
                    error(['不支持', var_type{i}, '类型的功能']);
            end
        end
    end
    
    %设置图示说明
    if exist('handle_true_pos', 'var')
        if exist('handle_filter_pos', 'var')
            legend([handle_beacon, handle_track, handle_true_pos, handle_filter_pos], ...
                   '信标位置', '轨迹', '真值位置', '被过滤的位置');
        else
            legend([handle_beacon, handle_track, handle_true_pos], ...
                   '信标位置', '轨迹', '真值位置');
        end
    else
        if exist('handle_filter_pos', 'var')
            legend([handle_beacon, handle_track], '信标位置', '轨迹', '被过滤的位置');
        else
            legend([handle_beacon, handle_track], '信标位置', '轨迹');
        end
    end
    
    title('信标空间内的坐标轨迹');
    xlabel('纬度：lat');
    ylabel('经度：lon');
    axis auto;
end