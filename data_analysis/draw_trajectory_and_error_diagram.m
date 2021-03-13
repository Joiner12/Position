function draw_trajectory_and_error_diagram(position, ...
                                           null_val, ...
                                           env_feat, ...
                                           beacon_position, ...
                                           draw_type)
%功能：绘制轨迹及误差图,各个文件的数据单独绘制,绘制情况分一下情景：
%      1）当前文件的位置真值有效：绘制带真值轨迹的轨迹图及误差图
%      2）当前文件的位置真值无效：绘制不带真值轨迹的轨迹图
%      位置真值满足以下条件时有效,否则无效：
%      1）真值个数与定位结果个数相同
%      2）每帧都存在真值（经纬度值并非无效值）
%参数：
%    position：待绘制的位置数据,细胞数组,具体结构如下所示：
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
%    draw_type：轨迹绘制方式,具体如下：
%               'splashes'：绘制散点，不绘制轨迹
%               'trajectory'：绘制轨迹，轨迹连接顺序按track_position顺序,即
%                             track_position(1)为第一个点的位置,track_position(2)
%                             为第二个点的位置,以此类推

    file_num = length(position);
    true_pos_valid_flag = 1; %真值有效标记
    
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
            coordinate_trajectory_in_beacon_space(env_feat, ...
                                                  beacon_position, ...
                                                  pos_res, ...
                                                  draw_type, ...
                                                  'true_value', ...
                                                  true_pos);

             position_error_statistics(pos_res, true_pos);
        else
            %真值无效,绘制轨迹图
            coordinate_trajectory_in_beacon_space(env_feat, ...
                                                  beacon_position, ...
                                                  pos_res, ...
                                                  draw_type);
        end
    end
end