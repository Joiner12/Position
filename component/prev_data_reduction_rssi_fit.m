function ap = prev_data_reduction_rssi_fit(ap, type, param)
%功能：对各个ap的rssi信息进行滤波(前置滤波器)
%定义：ap = prev_data_reduction_rssi_fit(ap, type, param)
%参数： 
%    ap：待滤波所有ap数据
%    type：滤波方式，支持形式如下
%          'mean'：取当前帧所有rssi的均值——均值滤波
%          'max'：取当前帧所有rssi的最大值——最值滤波
%          'scope_mean'：依据范围限定，过滤当前帧的所有rssi,取过滤后rssi的均值———范围滤波
%    param：各个模式的参数,具体如下
%          'mean'：[]
%          'scope_mean'：param.scope_mean.rssi_range：允许的rssi范围最大值
%                        param.scope_mean.ratio_thr：不可过滤的比例阈值(0~1)
%输出：
%    ap：滤波后的ap数据

    switch type
        case 'mean'
            for i = 1:length(ap)
                ap(i).rssi = mean(ap(i).recv_rssi);
            end
        case 'scope_mean'
            for i = 1:length(ap)
                recv_rssi = ap(i).recv_rssi;
                
                rssi_max = max(recv_rssi);
                [rssi_min, idx] = min(recv_rssi);
                while (rssi_max - rssi_min) > param.scope_mean.rssi_range
                    %rssi的范围超过限定值,需要进行过滤
                    if length(idx) >= (length(recv_rssi) * param.scope_mean.ratio_thr)
                        %最小值rssi的个数与总个数的比例达到限定阈值,停止过滤,退出循环
                        break;
                    else
                        %删除rssi中的最小值
                        recv_rssi(idx) = [];
                    end
                    
                    rssi_max = max(recv_rssi);
                    [rssi_min, idx] = min(recv_rssi);
                end
                
                ap(i).rssi = mean(recv_rssi);
            end
        case 'max'
            for i = 1:length(ap)
                ap(i).rssi = max(ap(i).recv_rssi);
            end
        otherwise
            error('选择的滤波方式错误,没有%s的滤波方式', type);
    end
end