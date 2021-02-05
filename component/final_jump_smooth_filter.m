function [pos_res, pos_queue, jump_num] = final_jump_smooth_filter(cur_pos,...
                                                                   prev_pos,...
                                                                   pos_queue,...
                                                                   param)
%功能：跳点平滑滤波
%定义：[pos_res, pos_queue, jump_num] = final_jump_smooth_filter(cur_pos,...
%                                                                prev_pos,...
%                                                                pos_queue,...
%                                                                param)
%参数： 
%    cur_pos：当前定位结果
%    prev_pos：前一帧定位结果           
%    pos_queue：坐标缓存队列
%    param：函数参数,具体如下
%           param.frame_num：当前有效帧号，表征现在是连续处理的第frame_num帧有效数据   
%           param.fit_dist_thr_max：坐标需拟合的最大距离门限
%           param.fit_dist_thr_min：坐标需拟合的最小距离门限
%           param.jump_num：连续跳点的次数
%           param.jump_num_max：允许的连续跳点的次数上限
%           param.smooth_len：平滑长度
%输出：
%    pos_res：滤波后定位结果，数据为结构体，包含元素如下：
%             pos_res.lat：纬度
%             pos_res.lon：经度
%    pos_queue：滤波后更新的坐标缓存队列
%    jump_num：滤波后更新的连续跳点的次数
             
    frame_num = param.frame_num;
    fit_dist_thr_max = param.fit_dist_thr_max;
    fit_dist_thr_min = param.fit_dist_thr_min;
    jump_num = param.jump_num;
    jump_num_max = param.jump_num_max;
    smooth_len = param.smooth_len;

    if isempty(cur_pos)
        pos_res = [];
        jump_num = jump_num + 1;
        return;
    end
    
    %计算当前点的拟合距离门限
    step_dist = (fit_dist_thr_max - fit_dist_thr_min) / jump_num_max;   
    fit_dist_thr = fit_dist_thr_min + (jump_num * step_dist);
    
    %% 跳点滤波
    if frame_num > smooth_len
        %帧数超过平滑长度，进行跳点滤波
        %计算当前定位结果距离上次定位结果的距离（注意此时必须存在前一帧结果）
        dist = utm_distance(cur_pos.lat, cur_pos.lon,...
                            prev_pos.lat, prev_pos.lon);
        
        if dist <= fit_dist_thr
            %当前点不为跳点
            pos_queue = queue_push(pos_queue, cur_pos);
            jump_num = 0;
        else
            %当前点为跳点
            jump_num = jump_num + 1; 
            
            if dist < (fit_dist_thr_max + 10)
                %当前点处于拟合区间内
                if jump_num < jump_num_max
                    %连续跳点次数未达到上限，认为历史数据可信，按比例拟合当前定位结果
                    a = jump_num / jump_num_max;
                    b = 1 - a;
                    pos.lat = a * cur_pos.lat + b * prev_pos.lat;
                    pos.lon = a * cur_pos.lon + b * prev_pos.lon;

                    pos_queue = queue_push(pos_queue, pos);
                else
                    %连续跳点次数达到上限，认为历史数据不可信，需清空历史数据，并以
                    %当前点为起始重新更新缓存队列数据
                    pos_queue = queue_clear(pos_queue);
                    pos_queue = queue_push(pos_queue, cur_pos);
                end
            else
                %当前点超出拟合范围，不再对当前定位结果进行拟合
                if jump_num < jump_num_max
                    %连续跳点次数未达到上限，认为历史数据可信，缓存上一次结果
                    pos_queue = queue_push(pos_queue, prev_pos);
                else
                    %连续跳点次数达到上限，认为历史数据不可信，需清空历史数据，并以
                    %当前点为起始重新更新缓存队列数据
                    pos_queue = queue_clear(pos_queue);
                    pos_queue = queue_push(pos_queue, cur_pos);
                end
            end
        end
    else 
        %帧数未超过平滑长度，不进行跳点滤波，将当前帧数据加入缓存队列
        pos_queue = queue_push(pos_queue, cur_pos);
    end
    
    %% 平滑滤波（对跳点滤波后更新的坐标缓存队列数据进行滤波后作为最终输出）
    data = queue_get_data(pos_queue);

    if length(data) > smooth_len
        len = smooth_len;
    else
        len = length(data);
    end
    
    smooth_data = data(1:len);
    smooth_lat = zeros(len, 1);
    smooth_lon = zeros(len, 1);
    for i = 1:len
        smooth_lat(i) = smooth_data{i}.lat;
        smooth_lon(i) = smooth_data{i}.lon;
    end
    
    pos_res.lat = mean(smooth_lat);
    pos_res.lon = mean(smooth_lon);
end