function rssi = calculate_rssi_based_on_distance(model_parameter,distance,varargin)
% 函数功能:
%   根据拟合的对数路径损耗模型(Logarithmic path loss model )，计算路径对应的RSSI。
% 函数参数:
%   model_parameter(struct):损耗模型
%   {
%       double A(距离1m时，设备接收到无线信号的RSSI值);
%       doubel n(衰减因子)
%   }
%   distance:距离(array)
%   varargin:保留参数
% 函数输出：
%   rssi:RSSI(array)

%% 模型配置
A = model_parameter.A;
n_10 = 10*model_parameter.n;

%% 计算pd(d) = A - 10n*lg(d/d0)
rssi_temp = zeros(0);
dist_temp = distance;
dist_temp(dist_temp<0)=0.1;
rssi_temp = A - n_10*log10(dist_temp);
rssi = rssi_temp;
disp('distance → rssi finished');
end