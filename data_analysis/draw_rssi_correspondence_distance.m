function draw_rssi_correspondence_distance(distance,rssi,fig_info,varargin)
% function draw_distance_correspondence_rssi(distance,rssi,varargin)
% 函数功能:
%   绘制RSSI值随距离变化趋势图
% 函数参数:
%   distance:距离(array)
%   rssi:rssi(array)
%   fig_info:图像信息(char)
%   varargin:保留参数
% 函数输出：
%   None
disp("绘制RSSI值随距离变化趋势图.")
try
    close(fig_info);
catch
    % disp('figure-rssi-distance')
end
%% 输入参数检测
if (~isnumeric(distance) || ~isnumeric(rssi))
    error("数据类型错误");
end
% 矩阵大小
if (min(size(distance))~=1 || min(size(rssi))~=1 ...
        || length(distance)~=length(rssi))
    error("数据类型错误");
end
figure('name',fig_info);
sz = 30;
c = linspace(1,length(distance),length(distance));
scatter(distance,rssi,sz,c,'LineWidth',2);
% 时便携设备接收到的无线信号RSSI强度的
set(get(gca, 'Title'), 'String', 'RSSI与距离对应关系');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
grid minor
end