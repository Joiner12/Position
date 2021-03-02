function exhibit_std_rssi_dist(rssi,dist)
% 功能: 分析标准RSSI-Dist统计信息
% 定义: exhibit_std_rssi_dist(rssi,dist)
% 输入:
%       rssi:固定距离下RSSI的值(矩阵)
%       dist:距离
% 输出:
%       None

x = linspace(1,length(rssi),length(rssi));
y = rssi;

f = figure();
subplot(2,2,1)
scatter(x,y)
set(get(gca, 'Title'), 'String', '统计分布情况');
set(get(gca, 'XLabel'), 'String', '点');
set(get(gca, 'YLabel'), 'String', 'dB');



subplot(2,2,1)

subplot(2,2,1)

subplot(2,2,1)

end