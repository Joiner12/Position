function draw_fitting_error(distance,rssi,fitting_out,fig_info,varargin)
% 函数功能:
%   绘制拟合误差折线图
% 函数参数:
%   distance:距离(array)
%   fitting_out:拟合结果(array)
%   rssi:RSSI(array)
%   fig_info:图像信息(char)
%   varargin:保留参数
% 函数输出：
%   None
disp("绘制绘制拟合误差折线图.")
%% 输入参数检测
if (~isnumeric(distance) || ~isnumeric(fitting_out) || ~isnumeric(rssi))
    error("数据类型错误");
end
try
    close('figure-fitting');
catch
    % disp('figure-rssi-distance')
end

figure('name','figure-fitting');
subplot(211)
fitting_error = rssi - fitting_out;
f_cur_rssi = plot(distance,rssi);
hold on 
f_cur_fitting = plot(distance,fitting_out);
% 设置plot属性
f_cur_rssi.LineWidth = 1.2;
f_cur_rssi.Marker = 'o';
f_cur_rssi.MarkerSize = 8;

f_cur_fitting.LineWidth = 1.2;
f_cur_fitting.Marker = 'o';
f_cur_fitting.MarkerSize = 8;
yyaxis left
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '原始结果/m');
% 右侧误差轴
hold on
bar(distance,fitting_error,'FaceColor','none');
yyaxis right
set(get(gca, 'YLabel'), 'String', '拟合距离误差/m');
% 时便携设备接收到的无线信号RSSI强度的
set(get(gca, 'Title'), 'String', '拟合误差折线图');
lg_1 = legend(gca,{'原始数据','拟合结果','拟合误差'});
lg_1.Box = 'off';
grid minor
%% 拟合误差
subplot(212)
bf = bar(distance,fitting_error,'LineWidth',0.1);
bf.EdgeColor = 'none';
bf.FaceColor = [0, 191, 255]./255;
set(get(gca, 'Title'), 'String', '拟合误差');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '拟合距离误差/m');
grid minor
end