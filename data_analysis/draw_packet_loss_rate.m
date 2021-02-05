function draw_packet_loss_rate(distance,loss_rate,fig_info,varargin)
% ��������:
%     ���ƶ����������Ĺ�ϵ
% ��������:
%     distance:����(array)
%     loss_rate:������(array)
%     fig_info:ͼ����Ϣ(char)
%     varargin:��������
% �������:
%     None
disp("���ƶ����������Ĺ�ϵ.")
try
    close('figure-loss-packet-distance');
catch
    % disp('figure-rssi-distance')
end

%% ����������
if (~isnumeric(distance) || ~isnumeric(loss_rate))
    error("�������ʹ���");
end
% �����С
if (min(size(distance))~=1 || min(size(loss_rate))~=1 ...
    || length(distance)~=length(loss_rate))
    error("�������ʹ���");
end
figure('name','figure-loss-packet-distance');
f_cur = plot(distance,loss_rate);
f_cur.LineWidth = 0.5;
f_cur.Marker = 'diamond';
f_cur.MarkerSize = 8;
% ʱ��Я�豸���յ��������ź�RSSIǿ�ȵ�
set(get(gca, 'Title'), 'String', '�����������Ĺ�ϵ');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', '������/%');
grid minor
end