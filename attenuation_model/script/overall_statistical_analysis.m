function overall_statistical_analysis(dist,mean_vals,variance_vals,kurtosis_vals,skewness_vals,varargin)
% 功能:
%       绘制标准RSSI测试统计结果(均值、偏度、方差、峰度)与距离关系图;
% 定义:
%       overall_statistical_analysis(dist,mean_vals,variance_vals,kurtosis_vals,skewness_vals,varargin)
% 输入：
%       dist:距离
%       mean_vals:与距离对应均值
%       variance_vals:...方差
%       kurtosis_vals:...峰度
%       skewness_vals:...偏度
%       varargin:保留参数
% 输出:
%       None


%% 整体统计分析;
figure('name','norm-analysis','Color',[1 1 1]);

subplot(2,2,1)
plot_py(dist,mean_vals)
set(get(gca, 'Title'), 'String', '均值随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB');

subplot(2,2,2)
plot_py(dist,variance_vals)
set(get(gca, 'Title'), 'String', '方差随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB^2');

subplot(2,2,3)
plot_py(dist,kurtosis_vals);
set(get(gca, 'Title'), 'String', '峰度随距离变化趋势');
hold on
plot_py([1 18],[3 3]);
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '峰度');
legend({'测试样本峰度','正态分布峰度'})

subplot(2,2,4)
plot_py(dist,skewness_vals)
hold on
plot_py([1,18],[0,0])
set(get(gca, 'Title'), 'String', '偏度随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '偏度');
legend({'测试样本偏度','正态分布偏度(0偏度)'})

end