function [ap, ap_buffer_new] = prev_rssi_filter(ap,...
                                                ap_buffer,...
                                                param)
%功能：rssi滤波
%定义：[ap, ap_buffer_new] = prev_rssi_filter(ap,...
%                                             ap_buffer,...
%                                             param)
%参数： 
%    ap：待滤波的ap数据
%    ap_buffer：ap缓存
%    param：滤波参数,具体如下
%           param.moving_average_len：加权平滑滤波长度
%           param.gauss_filter_len：高斯滤波长度
%           param.gauss_probability：高斯滤波校正阈值
%           param.same_ap_judge_type：相同ap的判断方式
%输出：
%    ap：滤波后ap数据
%    ap_buffer_new：更新后ap缓存

    %% 初始化
    ap_num = length(ap);
    moving_average_len = param.moving_average_len;
    gauss_filter_len = param.gauss_filter_len;
    gauss_probability = param.gauss_probability;
    ap_buffer_valid_frame_num = param.ap_buffer_valid_frame_num;
    same_ap_judge_type = param.same_ap_judge_type;
                     
    %初始化卡尔曼滤波参数
    kalman_scm_init = [(0.05)^2, ((0.05)^2)/0.1;...
              ((0.05)^2)/0.1, (2*(0.05)^2)/(0.1^2)]; %状态估计误差自相关矩阵
    
    %初始化查询标志为0，用于后续判断此帧数据是否查询到缓存中的ap
    for i = 1:length(ap_buffer)
        ap_buffer(i).isfind = 0;
    end
    
    %% 将获取最新的RSSI数据存入基站RSSI缓存
    for i = 1:ap_num
        isfind = 0;
        ap_buffer_len = length(ap_buffer);
        for j = 1:ap_buffer_len
            %匹配到缓存中ap，更新匹配到的ap中数据
            if is_same_ap(same_ap_judge_type,...
                          ap(i).name, ap_buffer(j).name,...
                          ap(i).mac, ap_buffer(j).mac)
                      
                rssi_len = length(ap_buffer(j).rssi) + 1;
                isfind = 1;
                ap_buffer(j).isfind = 1;
                ap_buffer(j).no_sig_rec_num = 0;
                ap_buffer(j).mac = ap(i).mac;
                ap_buffer(j).rssi(rssi_len) = ap(i).rssi;
                
                %加权平滑滤波(滤波结果保存到ap缓存用于数据分析，并非算法需要)
                ap_buffer(j).rssi_wma(rssi_len) = prev_rssi_weight_moving_average(...     
                                    ap_buffer(j).rssi, moving_average_len);
                                
                ap(i).rssi_wma = ap_buffer(j).rssi_wma(rssi_len);
                
                %高斯滤波(滤波结果保存到ap缓存用于数据分析，并非算法需要)
                ap_buffer(j).rssi_gf(rssi_len) = prev_rssi_gauss_filter(...
                   ap_buffer(j).rssi, gauss_filter_len, gauss_probability);
                
                ap(i).rssi_gf = ap_buffer(j).rssi_gf(rssi_len);
                
                %卡尔曼滤波
                gauge_cur = (ap(i).rssi_wma + ap(i).rssi_gf) / 2; %加权滤波和高斯滤波各一半
                
                if rssi_len == 2
                    value_cur = gauge_cur;
                    vel_cur = gauge_cur - ap_buffer(j).kalman_rssi(rssi_len - 1);
                    scm_cur = ap_buffer(j).kalman_rssi_scm{rssi_len - 1};
                else
                    [value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(...
                        ap_buffer(j).kalman_rssi(rssi_len - 1), ...
                        ap_buffer(j).kalman_rssi_vel(rssi_len - 1), ...
                        ap_buffer(j).kalman_rssi_scm{rssi_len - 1}, ...
                        gauge_cur);
                end
                
                ap_buffer(j).kalman_rssi(rssi_len) = value_cur;
                ap_buffer(j).kalman_rssi_vel(rssi_len) = vel_cur;
                ap_buffer(j).kalman_rssi_scm{rssi_len} = scm_cur;
                
                ap(i).rssi_kf = value_cur;
                
                break;
            end
        end
        
        %未匹配到已有的缓存，为新的ap，添加到缓存当中
        if isfind == 0
            ap_buffer_len = ap_buffer_len + 1;
            
            ap_buffer(ap_buffer_len).name = ap(i).name;
            ap_buffer(ap_buffer_len).isfind = 1;
            ap_buffer(ap_buffer_len).no_sig_rec_num = 0;
            ap_buffer(ap_buffer_len).mac = ap(i).mac;
            ap_buffer(ap_buffer_len).rssi(1) = ap(i).rssi;
            
            %加权平滑滤波(滤波结果保存到ap缓存用于数据分析，并非算法需要)
            ap_buffer(ap_buffer_len).rssi_wma(1) = ap(i).rssi;
            
            %高斯滤波(滤波结果保存到ap缓存用于数据分析，并非算法需要)
            ap_buffer(ap_buffer_len).rssi_gf(1) = ap(i).rssi;
            
            %卡尔曼滤波
            ap_buffer(ap_buffer_len).kalman_rssi(1) = ap(i).rssi;
            ap_buffer(ap_buffer_len).kalman_rssi_vel(1) = 0;
            ap_buffer(ap_buffer_len).kalman_rssi_scm{1} = kalman_scm_init;

            ap(i).rssi_wma = ap(i).rssi;
            ap(i).rssi_gf = ap(i).rssi;
            ap(i).rssi_kf = ap(i).rssi;
        end
    end
    
    %更新缓存中各个ap连续未扫描到的次数
    for i = 1:length(ap_buffer)
        if ap_buffer(i).isfind == 0
            ap_buffer(i).no_sig_rec_num = ap_buffer(i).no_sig_rec_num + 1;
        end
    end
    
    %% 对连续ap_buffer_valid_frame_num次以上没有收到信号的ap,从缓存中删除这个ap的缓存数据
    ap_buffer_new_num = 0;
    new_flag = 0;
    for i = 1:length(ap_buffer)
       if ap_buffer(i).no_sig_rec_num <= ap_buffer_valid_frame_num
           ap_buffer_new_num = ap_buffer_new_num + 1;
           new_flag = 1;
           
           ap_buffer_new(ap_buffer_new_num) = ap_buffer(i);
       end
    end
    
    if ~new_flag
        ap_buffer_new = [];
    end
end