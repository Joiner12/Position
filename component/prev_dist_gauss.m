function dist = prev_dist_gauss(rssi, param)
%功能：rssi距离高斯模型
%定义：dist = prev_dist_gauss(rssi, param)
%参数： 
%    rssi：待转换距离的rssi
%    param：函数参数,具体如下
%           param.a：高斯模型参数a
%           param.b：高斯模型参数b
%           param.c：高斯模型参数c
%输出：
%    dist：高斯模型距离结果，双精度存储，单位：m

    a = param.a;
    b = param.b;
    c = param.c;

    dist = a * exp(-((rssi - b) / c)^2);
end