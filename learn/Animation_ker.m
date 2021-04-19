%%
%{
https: // blog.csdn.net / u010480899 / article / details / 78234884
https: // blog.csdn.net / zengxiantao1994 / article / details / 77482852
%}
close all;
clear all;
clc;
clf;
%白色背景
% axis([-2, 2, -2, 2]);
xlabel('X轴');
ylabel('Y轴');
%四周的边框
box on;
%绘图区域
t = 0:0.02:10;
Nt = size(t, 2);
x = 2 * cos(t(1:Nt));
y = sin(t(1:Nt));
%循环绘图
for i = 1:Nt
    cla;
    hold on;
    plot(x, y)
    plot(x(i), y(i), 'o');
    frame = getframe(gcf);
    imind = frame2im(frame);
    [imind, cm] = rgb2ind(imind, 256);

    if i == 1
        imwrite(imind, cm, 'test.gif', 'gif', 'Loopcount', inf, 'DelayTime', 1e-4);
    else
        imwrite(imind, cm, 'test.gif', 'gif', 'WriteMode', 'append', 'DelayTime', 1e-4);
    end

end

%%
clc; clear;

% 初始化一个电影矩阵
M = moviein(16);
% 创建电影
for k = 1:16
    plot(fft(eye(k + 16)));
    axis equal;
    % 调用getframe函数生成每个帧
    M(k) = getframe;
end

% 调用movie函数将电影动画矩阵M(k)播放5次
movie(M, 5);

% 将前面创建的电影动画中添加一个垂直的滚动条
h = uicontrol('style', 'slider', 'position', [10 50 20 100], 'Min', 1, 'Max', 16, 'Value', 1);

for k = 1:16
    plot(fft(eye(k + 16)));
    axis equal;
    set(h, 'Value', k);
    % gcf为返回当前图形窗口句柄
    M(k) = getframe(gcf);
end

clf;
axes('Position', [0 0 1 1]);
movie(M, 5);

%%
% 动态绘制椭圆

% clf用来清除图形的命令。一般在画图之前用。
clf;
clc;
axis([-2, 2, -2, 2]);
% axis square 当前坐标系图形设置为方形，刻度范围不一定一样，但是一定是方形的。
% axis equal 将横轴纵轴的定标系数设成相同值，即单位长度相同，刻度是等长的，但不一定是方形的。
axis equal;
grid on;

h = animatedline('Marker', 'o', 'color', 'b', 'LineStyle', 'none');
t = 6 * pi * (0:0.02:1);

for n = 1:length(t)
    addpoints(h, 2 * cos(t(1:n)), sin(t(1:n)));

    % 一般是为了动态观察变化过程 pause（a）暂停a秒后执行下一条指令
    pause(0.5);

    % 可以用drawnow update加快动画速度
    drawnow update;
end

%%
A = [-8/3 0 0; 0 -10 10; 0 28 -1];
y = [35 -10 -7]';
h = 0.01;

p = animatedline('color', 'g', 'Marker', '*');
axis([0 50 -25 25 -25 25])
hold on; grid on;

for i = 1:4000
    A(1, 3) = y(2);
    A(3, 1) = -y(2);
    ydot = A * y;
    y = y + h * ydot;
    % 更改坐标值
    addpoints(p, y(1), y(2), y(3));
    drawnow;
end


%% 
ar = annotation('arrow');
c = ar.Color;
ar.Color = 'red';


