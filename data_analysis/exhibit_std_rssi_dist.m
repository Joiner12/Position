function exhibit_std_rssi_dist(rssi,dist)
% ����: ������׼RSSI-Distͳ����Ϣ
% ����: exhibit_std_rssi_dist(rssi,dist)
% ����:
%       rssi:�̶�������RSSI��ֵ(����)
%       dist:����
% ���:
%       None

x = linspace(1,length(rssi),length(rssi));
y = rssi;

f = figure();
subplot(2,2,1)
scatter(x,y)
set(get(gca, 'Title'), 'String', 'ͳ�Ʒֲ����');
set(get(gca, 'XLabel'), 'String', '��');
set(get(gca, 'YLabel'), 'String', 'dB');



subplot(2,2,1)

subplot(2,2,1)

subplot(2,2,1)

end