function position = bluetooth_position(data)
%功能：蓝牙定位
%定义：position = bluetooth_position(data)
%参数： 
%    data：一个文件的各帧数据
%输出：
%    position：各帧定位结果

%% 系统初始化
    frame_num = length(data);  %总帧数
    position = cell(1, frame_num); %初始化每帧定位结果为空
    continue_valid_frame_num = 0;  %连续有效的帧数
    continue_invalid_frame_num = 0;%连续无效的帧数
    ap_buf = [];  %初始化不同ap数据的缓存
    prev_ap = []; %初始化上一帧的ap数据
    scope_prev_pos = [];       %范围滤波上一帧结果
    jump_smooth_prev_pos = []; %跳点范围滤波上一帧结果
    invalid_situation_pos = [];%无效情况下最终输出的定位结果
    config = sys_config();     %设置各个构件参数
    pos_queue = queue_init(config.jump_smooth_filter_param.smooth_len); %初始化坐标缓存队列

%% 逐帧处理
    for i = 1:frame_num
    %% 定位前预处理
        cur_ap = data{i};
        
        %剔除经纬度数据无效的ap数据
        cur_ap = prev_data_reduction_invalid_coordinate_del(cur_ap);
        
        %整合相同的ap数据
        cur_ap = prev_data_redcution_integrate_same_ap(cur_ap,...
                                                       config.integrate_same_ap_param);
        
        %拟合各个ap的rssi
        cur_ap = prev_data_reduction_rssi_fit(cur_ap,...
                                              config.rssi_fit_type,...
                                              config.rssi_fit_param);
        
        if i == 135
            a = 1;
        end
        
        if i == 158
            a = 1;
        end
        
        if i == 142
            a = 1;
        end
                                          
        %rssi滤波（后续只会用到卡尔曼滤波后结果rssi_kf，高斯及平滑结果仅用于数据分析）
%         [cur_ap, ap_buf] = prev_rssi_filter(cur_ap,...
%                                             ap_buf,...
%                                             config.rssi_filter_param);
                                        
        for j = 1:length(cur_ap) 
            cur_ap(j).rssi_kf = cur_ap(j).rssi;
        end
                                        
        %dbscan聚类法的ap选择器
%         cur_ap = prev_dbscan_ap_selector(cur_ap,...
%                                          prev_ap,...
%                                          config.dbscan_selector_param);
                                
        prev_ap = cur_ap;
                                          
        %计算离各个ap的距离
        cur_ap = prev_dist_calc(cur_ap,...
                                config.dist_calc_type,...
                                config.dist_calc_param);
                            
        %距离三角补偿
        cur_ap = prev_dist_triangle_compensate(cur_ap, config.dist_triangle_compensate_meter);
        
    %% 定位
        %高斯牛顿迭代最小二乘算法（加权质心结果为初始点）
%         pos_res = location_gauss_newton_least_squares_wma(cur_ap,...
%                                                           config.newtongaussls_param);
        
        pos_res = location_least_squares(cur_ap);
        
        if isempty(pos_res)
            pos_res = pos_res_prev;
        else
            pos_res_prev = pos_res;
        end
                                                      
%         if isempty(pos_res)
%             %当前帧未定位出结果
%             continue_invalid_frame_num = continue_invalid_frame_num + 1;
%             
%             if continue_invalid_frame_num >= config.history_valid_frame_num
%                 %无效帧数达到允许上限,认为历史数据已经无效,清空历史数据,恢复到
%                 %初始定位的状态,直接输出上一次最终结果
%                 %
%                 %注意：ap数据缓存ap_buf可以不清空，因为prev_rssi_filter函数设置的
%                 %      缓存ap有效上限ap_buffer_valid_frame_num小于无效帧数上限
%                 %      history_valid_frame_num,同时当前算法仅在不存在有效数据时
%                 %      出现未定位出结果的情况,因此还未达到清空历史数据条件的
%                 %      时候,ap数据缓存已经全部重置,其实此时不需要重复清空ap数据缓存
%                 continue_valid_frame_num = 0;
%                 config.jump_smooth_filter_param.jump_num = 0;
%                 ap_buf = [];
%                 prev_ap = [];
%                 scope_prev_pos = [];
%                 jump_smooth_prev_pos = [];
%                 pos_queue = queue_clear(pos_queue);
%                 position{i} = invalid_situation_pos;
%                 
%                 continue;
%             else
%                 %历史数据还有效,利用上次计算的初始定位结果进行后续定位处理
%                 pos_res = pos_res_prev;
%             end
%         else
%             %当前帧成功定位出结果,保存当前结果作为初始定位的历史数据
%             pos_res_prev = pos_res;
%         end
        
    %% 定位后处理
%         %范围滤波
%         pos_res = final_scope_filter(pos_res,...
%                                      scope_prev_pos,...
%                                      config.scope_filter_param);
%                                  
%         scope_prev_pos = pos_res;
%         
%         %跳点平滑滤波
%         continue_valid_frame_num = continue_valid_frame_num + 1;
%         config.jump_smooth_filter_param.frame_num = continue_valid_frame_num;
%         [pos_res, pos_queue, jump_num] = final_jump_smooth_filter(pos_res,...
%                                                                   jump_smooth_prev_pos,...
%                                                                   pos_queue,...
%                                                                   config.jump_smooth_filter_param);
%                                                               
%          config.jump_smooth_filter_param.jump_num = jump_num;                                       
%          jump_smooth_prev_pos = pos_res;
%          invalid_situation_pos = pos_res;
         
         position{i} = pos_res;
    end
end