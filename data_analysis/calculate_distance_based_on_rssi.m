function distance = calculate_distance_based_on_rssi(A,b,rssi,varargin)
% 功能:
%       根据拟合的对数路径损耗模型(Logarithmic path loss model )，计算RSSI对应的路径。
% 定义: 
%       function distance = calculate_distance_based_on_rssi(A,b,rssi,varargin)
% 参数:
%       A,距离1m时，设备接收到无线信号的RSSI值;
%       b,衰减因子;
%       rssi,RSSI(array)
%       varargin:保留参数
% 输出：
%       distance:距离(array)

%% 模型配置
n_10 = 10*b;

%% 计算
dist_temp = zeros(0);
n_temp = (A-rssi)./n_10;
% n_temp = abs(n_temp);
dist_temp = power(10,n_temp);

%%
distance = dist_temp;
% disp('rssi → distance finished');
end