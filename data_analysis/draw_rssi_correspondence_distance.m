function draw_rssi_correspondence_distance(distance,rssi,fig_info,varargin)
% function draw_distance_correspondence_rssi(distance,rssi,varargin)
% ��������:
%   ����RSSIֵ�����仯����ͼ
% ��������:
%   distance:����(array)
%   rssi:rssi(array)
%   fig_info:ͼ����Ϣ(char)
%   varargin:��������
% ���������
%   None
disp("����RSSIֵ�����仯����ͼ.")
try
    close(fig_info);
catch
    % disp('figure-rssi-distance')
end
%% ����������
if (~isnumeric(distance) || ~isnumeric(rssi))
    error("�������ʹ���");
end
% �����С
if (min(size(distance))~=1 || min(size(rssi))~=1 ...
        || length(distance)~=length(rssi))
    error("�������ʹ���");
end
figure('name',fig_info);
sz = 30;
c = linspace(1,length(distance),length(distance));
scatter(distance,rssi,sz,c,'LineWidth',2);
% ʱ��Я�豸���յ��������ź�RSSIǿ�ȵ�
set(get(gca, 'Title'), 'String', 'RSSI������Ӧ��ϵ');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
grid minor
end