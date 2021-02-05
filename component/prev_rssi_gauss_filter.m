function rssi_gf = prev_rssi_gauss_filter(rssi, gauss_filter_len, probability)
%功能：高斯滤波
%定义：rssi_gf = prev_rssi_gauss_filter(rssi, gauss_filter_len, probability)
%参数： 
%    rssi：待滤波的rssi矢量（必须为实数矢量,各个值按接收到的时间由远到近向后
%                           存放,例如t1时刻存放到rssi(1),接下来的t2时刻存放
%                           到rssi(2)）
%    gauss_filter_len：高斯滤波长度
%    probability：基于高斯模型的RSSI值校正阈值
%输出：
%    rssi_gf：高斯滤波后rssi

    rssi_len = length(rssi);
    
    if rssi_len > gauss_filter_len
        %1、求出RSSI组的均值和方差（RSSI组：一个AP的gauss_filter_len个历史数据）
        rssi_group = rssi(rssi_len - gauss_filter_len + 1:end);
        rssi_mean = mean(rssi_group);
        rssi_std = std(rssi_group);
        
        %2、用均值和方差求出高斯范围（概率范围）
        probability_min = probability / (rssi_std * sqrt(2 * pi));
        probability_max = 1 / (rssi_std * sqrt(2 * pi));
        
        %3、用高斯范围、RSSI组内各点的概率值，选出在高斯范内的RSSI组
        rssi_probability = 1 ./ (rssi_std * sqrt(2 * pi)) .* ...
                    exp(-(rssi_group - rssi_mean).^2 ./ (2 * rssi_std^2));
        rssi_filtrate = rssi_group(rssi_probability > probability_min...
                                   & rssi_probability < probability_max);
                                
        rssi_gf = mean(rssi_filtrate);
    else
        rssi_gf = rssi(end);
    end
end 