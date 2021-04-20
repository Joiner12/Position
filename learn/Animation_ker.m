%%
%{
https: // blog.csdn.net / u010480899 / article / details / 78234884
https: // blog.csdn.net / zengxiantao1994 / article / details / 77482852
%}
close all;
clear all;
clc;
clf;
%��ɫ����
% axis([-2, 2, -2, 2]);
xlabel('X��');
ylabel('Y��');
%���ܵı߿�
box on;
%��ͼ����
t = 0:0.02:10;
Nt = size(t, 2);
x = 2 * cos(t(1:Nt));
y = sin(t(1:Nt));
%ѭ����ͼ
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

% ��ʼ��һ����Ӱ����
M = moviein(16);
% ������Ӱ
for k = 1:16
    plot(fft(eye(k + 16)));
    axis equal;
    % ����getframe��������ÿ��֡
    M(k) = getframe;
end

% ����movie��������Ӱ��������M(k)����5��
movie(M, 5);

% ��ǰ�洴���ĵ�Ӱ���������һ����ֱ�Ĺ�����
h = uicontrol('style', 'slider', 'position', [10 50 20 100], 'Min', 1, 'Max', 16, 'Value', 1);

for k = 1:16
    plot(fft(eye(k + 16)));
    axis equal;
    set(h, 'Value', k);
    % gcfΪ���ص�ǰͼ�δ��ھ��
    M(k) = getframe(gcf);
end

clf;
axes('Position', [0 0 1 1]);
movie(M, 5);

%%
% ��̬������Բ

% clf�������ͼ�ε����һ���ڻ�ͼ֮ǰ�á�
clf;
clc;
axis([-2, 2, -2, 2]);
% axis square ��ǰ����ϵͼ������Ϊ���Σ��̶ȷ�Χ��һ��һ��������һ���Ƿ��εġ�
% axis equal ����������Ķ���ϵ�������ֵͬ������λ������ͬ���̶��ǵȳ��ģ�����һ���Ƿ��εġ�
axis equal;
grid on;

h = animatedline('Marker', 'o', 'color', 'b', 'LineStyle', 'none');
t = 6 * pi * (0:0.02:1);

for n = 1:length(t)
    addpoints(h, 2 * cos(t(1:n)), sin(t(1:n)));

    % һ����Ϊ�˶�̬�۲�仯���� pause��a����ͣa���ִ����һ��ָ��
    pause(0.5);

    % ������drawnow update�ӿ춯���ٶ�
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
    % ��������ֵ
    addpoints(p, y(1), y(2), y(3));
    drawnow;
end


%% 
ar = annotation('arrow');
c = ar.Color;
ar.Color = 'red';


