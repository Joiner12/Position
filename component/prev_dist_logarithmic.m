function dist = prev_dist_logarithmic(rssi, param)
%功能：rssi经典距离对数模型
%定义：dist = prev_dist_logarithmic(rssi, param)
%参数： 
%    rssi：待转换距离的rssi
%    param：函数参数,具体如下
%           param.rssi_reference：信号传播参考距离d0(d0=1m)后产生的路径损耗,即d0处rssi
%           param.loss_coef：路径损耗系数,一般取2~3之间
%输出：
%    dist：经典对数模型距离结果，双精度存储，单位：m

    const = 10; %对数模型常数
    rssi_reference = param.rssi_reference;
    loss_coef = param.loss_coef;

    dist = const^(abs(rssi - rssi_reference) / (10 * loss_coef));
end 