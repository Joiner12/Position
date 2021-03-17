function analysis_fit_model_normal(A,b,rssi,true_dist,varargin)
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
[m_val,v_val,~,~] = get_rssi_statistics(rssi);
% 绘图
tcf('NN');
figure('Name','NN','Color','w');
subplot(221)
scatter_py(ser_rssi,rssi);
set(get(gca, 'Title'), 'String', 'RSSI分布情况');
set(get(gca, 'XLabel'), 'String', '采样序列');
set(get(gca, 'YLabel'), 'String', 'RSSI/dB');
temp =  max(abs(min(rssi)-m_val),abs(max(rssi)-m_val));
letemp = sprintf(['RSSI样本均值:%.2f\n',... 
    'RSSI样本方差:%0.2f\n',... 
    'RSSI样本最大差值:%.2f\n',... 
    'RSSI样本均值最大差:%.2f\n'],m_val,v_val,max(rssi)-min(rssi),temp);
legend(letemp);
grid on

subplot(222)
set(get(gca, 'Title'), 'String', '模型解算距离对比真实距离');
plot_py([1,max(ser_rssi)],[true_dist,true_dist]);
hold on
plot_py(ser_rssi,dist_calc);
legend({'真实距离','模型解算距离'});
set(get(gca, 'XLabel'), 'String', '采样序列');
set(get(gca, 'YLabel'), 'String', '距离/m');

subplot(223)
set(get(gca, 'Title'), 'String', '偏差');
% plot_py(ser_rssi,dist_calc-true_dist);
area(ser_rssi,dist_calc-true_dist);
set(get(gca, 'XLabel'), 'String', '采样序列');
set(get(gca, 'YLabel'), 'String', '距离/m');
grid on

subplot(224)
model_str = sprintf('$$d(rssi) = %.4f - \\frac{rssi}{10*%.4f}$$',A,b);
h=text(0,0.5,model_str);
set(h,'Interpreter','latex');
end