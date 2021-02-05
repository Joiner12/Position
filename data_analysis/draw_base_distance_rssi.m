function [mean_frame_rssi,pd_mu] = draw_base_distance_rssi(base_rssi,fig_info,varargin)
% ��������:
%   ���ƾ���n(m)����ͬ֡rssiֵɢ��ͼ
% ��������:
%   base_rssi(cell(array)):1m��rssi����֡
%   varargin:��������
%   fig_info:ͼ����Ϣ(char)
% ���������
%   mean_frame_rssi
%% 
% A = -61.24;
%% �������
if ~iscell(base_rssi)
    error('�����������');
end

%% ��ʼ��ͼ��
fig_name = char(fig_info);
try
    close(fig_name)
catch
%     disp('no such figure open');
end

%% ����RSSI�ֲ����ݴ���
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
% ��ֵ�ľ�ֵ
rssi_mean_mean = mean(rssi_mean);
mean_frame_rssi = rssi_mean_mean; % ��������ֵ
%% ͳ�Ʒֲ�
pd_rssi = reshape(y_rssi,[length(y_rssi) 1]);
pd = fitdist(pd_rssi,'Normal');
pd_mu = pd.mu;
if nargin > 2
    return;
end

%% ����RSSI�ֲ���ͼ
figure('name',fig_name);
subplot(221)
sz = 50;
c = linspace(1,10,length(x_rssi));
scatter(x_rssi,y_rssi,sz,c,'filled');
set(get(gca, 'Title'), 'String', strcat(fig_info,'����1mRSSIֵ����ֲ�'));
set(gca, 'xlim',[0 max(x_rssi)+1],'ylim',[min(y_rssi)-2 max(y_rssi)+2]);
set(get(gca, 'XLabel'), 'String', 'RSSI����');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
box on;
grid minor
%% ��֡RSSI�ֲ���ͼ
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
set(get(gca, 'Title'), 'String', strcat(fig_info,'����1mRSSIֵ��֡�ֲ�'));
set(gca, 'xlim',[0 max(x_rssi)+1],'ylim',[min(y_rssi)-2 max(y_rssi)+2]);
set(get(gca, 'XLabel'), 'String', '֡��');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
box on;
grid minor
hold off

%% ͳ��ֱ��ͼ
subplot(223)
h = histfit(y_rssi);
set(get(gca, 'Title'), 'String', strcat(fig_info,'����1mRSSIͳ��ֱ��ͼ'));
set(get(gca, 'XLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'YLabel'), 'String', 'ͳ�ƽ��/num');
grid minor
%% ��֡���ݾ�ֵ�仯���
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
set(get(gca, 'Title'), 'String', strcat(fig_info,'����1m RSSIÿ֡��ֵ�仯���'));
set(get(gca, 'XLabel'), 'String', 'frame/num');
set(get(gca, 'YLabel'), 'String', 'rssi/num');
set(gca, 'xlim',[0 length(plt_rssi_x)+1],'ylim',[min(rssi_mean)-2 max(rssi_mean)+2]);
grid minor
legend('��ֵ�ֲ�','��ֵ�ľ�ֵ��')
%% 
fprintf('draw %s base rssi info finished.\n',fig_info);
end
