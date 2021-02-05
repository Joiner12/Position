function draw_packet_loss_rate(distance,loss_rate,fig_info,varargin)
% 函数功能:
%     绘制丢包率与距离的关系
% 函数参数:
%     distance:距离(array)
%     loss_rate:丢包率(array)
%     fig_info:图像信息(char)
%     varargin:保留参数
% 函数输出:
%     None
disp("绘制丢包率与距离的关系.")
try
    close('figure-loss-packet-distance');
catch
    % disp('figure-rssi-distance')
end

%% 输入参数检测
if (~isnumeric(distance) || ~isnumeric(loss_rate))
    error("数据类型错误");
end
% 矩阵大小
if (min(size(distance))~=1 || min(size(loss_rate))~=1 ...
    || length(distance)~=length(loss_rate))
    error("数据类型错误");
end
figure('name','figure-loss-packet-distance');
f_cur = plot(distance,loss_rate);
f_cur.LineWidth = 0.5;
f_cur.Marker = 'diamond';
f_cur.MarkerSize = 8;
% 时便携设备接收到的无线信号RSSI强度的
set(get(gca, 'Title'), 'String', '丢包率与距离的关系');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '丢包率/%');
grid minor
end