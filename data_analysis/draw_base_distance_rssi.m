function [mean_frame_rssi,pd_mu] = draw_base_distance_rssi(base_rssi,fig_info,varargin)
% 函数功能:
%   绘制距离n(m)处不同帧rssi值散点图
% 函数参数:
%   base_rssi(cell(array)):1m处rssi数据帧
%   varargin:保留参数
%   fig_info:图窗信息(char)
% 函数输出：
%   mean_frame_rssi
%% 
% A = -61.24;
%% 参数检查
if ~iscell(base_rssi)
    error('输入参数错误');
end

%% 初始化图窗
fig_name = char(fig_info);
try
    close(fig_name)
catch
%     disp('no such figure open');
end

%% 整体RSSI分布数据处理
%     plotmatrix(X,Y)
rssi_array = zeros(0);
rssi_mean = zeros(0);
for i =linspace(1,length(base_rssi),length(base_rssi))
    y_rssi = base_rssi{i};
    rssi_mean(i) = mean(y_rssi);
    y_rssi = reshape(y_rssi,[1 size(y_rssi,1)*size(y_rssi,2)]);
    rssi_array = [rssi_array,y_rssi];
end
x_rssi = linspace(1,length(rssi_array),length(rssi_array));
y_rssi = rssi_array;
% 均值的均值
rssi_mean_mean = mean(rssi_mean);
mean_frame_rssi = rssi_mean_mean; % 函数返回值
%% 统计分布
pd_rssi = reshape(y_rssi,[length(y_rssi) 1]);
pd = fitdist(pd_rssi,'Normal');
pd_mu = pd.mu;
if nargin > 2
    return;
end

%% 整体RSSI分布绘图
figure('name',fig_name);
subplot(221)
sz = 50;
c = linspace(1,10,length(x_rssi));
scatter(x_rssi,y_rssi,sz,c,'filled');
set(get(gca, 'Title'), 'String', strcat(fig_info,'距离1mRSSI值整体分布'));
set(gca, 'xlim',[0 max(x_rssi)+1],'ylim',[min(y_rssi)-2 max(y_rssi)+2]);
set(get(gca, 'XLabel'), 'String', 'RSSI点数');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
box on;
grid minor
%% 单帧RSSI分布绘图
subplot(222)
headIndex = 1;
min_rssi = min(y_rssi) -3;
max_rssi = max(y_rssi) +3;
for k =linspace(1,length(base_rssi),length(base_rssi))
    plt_vals = base_rssi{k};
    scatter(linspace(headIndex,headIndex+length(plt_vals)-1,length(plt_vals)),...
        plt_vals,'filled');
    hold on
    line('XData',[headIndex+length(plt_vals),headIndex+length(plt_vals)],...
        'YData',[min_rssi,max_rssi],'Linestyle','-.','Color',rand(1,3))
    headIndex = headIndex+length(plt_vals)+2;
    hold on
end
set(get(gca, 'Title'), 'String', strcat(fig_info,'距离1mRSSI值单帧分布'));
set(gca, 'xlim',[0 max(x_rssi)+1],'ylim',[min(y_rssi)-2 max(y_rssi)+2]);
set(get(gca, 'XLabel'), 'String', '帧数');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
box on;
grid minor
hold off

%% 统计直方图
subplot(223)
h = histfit(y_rssi);
set(get(gca, 'Title'), 'String', strcat(fig_info,'距离1mRSSI统计直方图'));
set(get(gca, 'XLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'YLabel'), 'String', '统计结果/num');
grid minor
%% 单帧数据均值变化情况
subplot(224)
plt_rssi_x = linspace(1,length(rssi_mean),length(rssi_mean));

sz = 20;
c = linspace(1,10,length(plt_rssi_x));
scatter(plt_rssi_x,rssi_mean,sz,c,'filled');
hold on
line('XData',[0,length(plt_rssi_x)+1],...
        'YData',[rssi_mean_mean,rssi_mean_mean],'Linestyle',':',... 
        'Color',[25, 169, 240]./255,... 
        'LineWidth',2)
set(get(gca, 'Title'), 'String', strcat(fig_info,'距离1m RSSI每帧均值变化情况'));
set(get(gca, 'XLabel'), 'String', 'frame/num');
set(get(gca, 'YLabel'), 'String', 'rssi/num');
set(gca, 'xlim',[0 length(plt_rssi_x)+1],'ylim',[min(rssi_mean)-2 max(rssi_mean)+2]);
grid minor
legend('均值分布','均值的均值线')
%% 
fprintf('draw %s base rssi info finished.\n',fig_info);
end
