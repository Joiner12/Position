function analysis_fit_model(A,b,rssi,true_dist,varargin)
% 功能:分析模型拟合结果 A-10*b*lg(d) = rssi
% 定义: analysis_fit_model(a,b,rssi,true_dist)
% 输入: 
%       A:距离1m处RSSI值.
%       b:衰减系数
%       true_dist:真实距离
%       varargin:保留参数
% 输出: none
%{
     Coefficients (with 95% confidence bounds):
       a =      -41.43  (-43.22, -39.64)
       b =      -1.445  (-1.638, -1.252)
%}

%% 
% A = model_parameter.A;
% n_10 = 10*model_parameter.n;
dist_calc = calculate_distance_based_on_rssi(struct('A',A,'n',b),rssi); % 通过rssi计算出的距离
ser_rssi = linspace(1,length(rssi),length(rssi));

% 绘图
figure('Name','NN','Color','w');
subplot(311)
scatter_py(ser_rssi,rssi)
% (A-rssi)./n_10;
model_str = sprintf('d(rssi) = .4f%-rssi/10/.4f%',A,b);
set(get(gca, 'Title'), 'String', model_str);
grid on

subplot(312)
plot_py([1,max(ser_rssi)],[true_dist,true_dist]);
hold on
plot_py(ser_rssi,dist_calc)

subplot(313)
plot_py(ser_rssi,dist_calc-true_dist)
end