function draw_trajectory_and_error_diagram(position, ...
                                           null_val, ...
                                           env_feat, ...
                                           beacon_position, ...
                                           draw_type, ...
                                           varargin)
%功能：绘制轨迹及误差图,各个文件的数据单独绘制,绘制情况分一下情景：
%      1）当前文件的位置真值有效：绘制带真值轨迹的轨迹图及误差图
%      2）当前文件的位置真值无效：绘制不带真值轨迹的轨迹图
%      位置真值满足以下条件时有效,否则无效：
%      1）真值个数与定位结果个数相同
%      2）每帧都存在真值（经纬度值并非无效值）
%定义：draw_trajectory_and_error_diagram(position, ...
%                                        null_val, ...
%                                        env_feat, ...
%                                        beacon_position, ...
%                                        draw_type, ...
%                                        varargin)
%参数：
%    position：待绘制的位置数据,元胞数组,具体结构如下所示：
%              position{i}：第i个文件的待绘制数据
%              position{i}.pos_res：第i个文件的定位结果
%              position{i}.true_pos：第i个文件的位置真值
%              position{i}.pos_res{j}：第i个文件第j帧的定位结果
%              position{i}.pos_res{j}.lat：第i个文件第j帧的定位结果的纬度
%              position{i}.pos_res{j}.lon：第i个文件第j帧的定位结果的经度
%              position{i}.true_pos(j)：第i个文件第j帧的位置真值
%              position{i}.true_pos(j).lat：第i个文件第j帧的位置真值的纬度
%              position{i}.true_pos(j).lon：第i个文件第j帧的位置真值的经度
%    null_val：经纬度无效值,经纬度数据为此值时表示其数据无效,例如position{i}.true_pos(j)
%              中经度或纬度为此值表示position{i}.true_pos(j)的经纬度无效
%    env_feat：环境特征,元胞数组,每个元胞表示一个环境区域，其数据为结构体,具体如 
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
%                     beacon_position(i).lat：纬度(latitude)
%                     beacon_position(i).lon：经度(longitude)
%    draw_type：轨迹绘制方式,具体如下：
%               'splashes'：绘制散点，不绘制轨迹
%               'trajectory'：绘制轨迹，轨迹连接顺序按track_position顺序,即
%                             track_position(1)为第一个点的位置,track_position(2)
%                             为第二个点的位置,以此类推
%可变参数：
%    成组传入,组数和各组顺序不做限制,但各组内数据格式必须严格遵从[type, param]
%    格式,现支持的各组功能如下：
%    第一组：
%          格式：'filter_point', filter_points
%          参数说明：
%          'filter_point'：点位过滤
%          filter_points：过滤的点位,元胞数组,表示各个文件过滤的点位,即
%                         filter_points{i}表示第i个文件要过滤的点位,过滤的点位                           
%                         表示方式为下标号, 即filter_points{i} = [1, 2, 3]
%                         表示过滤掉position{i}.pos_res{1}、position{i}.pos_res{2}、
%                         position{i}.pos_res{3}表示的点位,若传入的点位中存在点不在
%                         位置集中,则运行时警告,并只过滤在位置集中的那部分点位

    file_num = length(position);
    true_pos_valid_flag = 1; %真值有效标记
    
    %处理可变参
    filter_flag = 0;
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
                case 'filter_point'
                    filter_flag = 1;
                    filter_points = var_param{i};
                otherwise
                    error(['不支持', var_type{i}, '类型的功能']);
            end
        end
    end
    
    for i = 1:file_num
        %提取当前文件的定位结果和真值
        pos_res_num = length(position{i}.pos_res);
        true_pos_num = length(position{i}.true_pos);
        pos_res = repmat(struct('lat', null_val, 'lon', null_val), pos_res_num, 1);
        true_pos = position{i}.true_pos;

        for j = 1:pos_res_num
            pos_res(j) = position{i}.pos_res{j};
        end

        %判断当前真值是否有效,满足以下条件时有效,否则无效
        %1）真值个数与定位结果个数相同
        %2）每帧都存在真值（经纬度值并非无效值）
        if pos_res_num ~= true_pos_num
            true_pos_valid_flag = 0;
        end

        for j = 1:true_pos_num
            if (true_pos(j).lat == null_val) || (true_pos(j).lon == null_val)
                true_pos_valid_flag = 0;
                break;
            end
        end

        if true_pos_valid_flag
            %真值有效,绘制轨迹图及误差图
            if filter_flag
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'true_value', ...
                                                      true_pos, ...
                                                      'filter_point', ...
                                                      filter_points{i});

                 position_error_statistics(pos_res, ...
                                           true_pos, ...
                                           'filter_point', ...
                                           filter_points{i});
            else
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'true_value', ...
                                                      true_pos);

                 position_error_statistics(pos_res, true_pos);
            end
        else
            %真值无效,绘制轨迹图
            if filter_flag
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'filter_point', ...
                                                      filter_points{i});
            else
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type);
            end
        end
    end
end