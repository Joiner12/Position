function draw_fitting_error(distance,rssi,fitting_out,fig_info,varargin)
% ��������:
%   ��������������ͼ
% ��������:
%   distance:����(array)
%   fitting_out:��Ͻ��(array)
%   rssi:RSSI(array)
%   fig_info:ͼ����Ϣ(char)
%   varargin:��������
% ���������
%   None
disp("���ƻ�������������ͼ.")
%% ����������
if (~isnumeric(distance) || ~isnumeric(fitting_out) || ~isnumeric(rssi))
    error("�������ʹ���");
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
% ����plot����
f_cur_rssi.LineWidth = 1.2;
f_cur_rssi.Marker = 'o';
f_cur_rssi.MarkerSize = 8;

f_cur_fitting.LineWidth = 1.2;
f_cur_fitting.Marker = 'o';
f_cur_fitting.MarkerSize = 8;
yyaxis left
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'ԭʼ���/m');
% �Ҳ������
hold on
bar(distance,fitting_error,'FaceColor','none');
yyaxis right
set(get(gca, 'YLabel'), 'String', '��Ͼ������/m');
% ʱ��Я�豸���յ��������ź�RSSIǿ�ȵ�
set(get(gca, 'Title'), 'String', '����������ͼ');
lg_1 = legend(gca,{'ԭʼ����','��Ͻ��','������'});
lg_1.Box = 'off';
grid minor
%% ������
subplot(212)
bf = bar(distance,fitting_error,'LineWidth',0.1);
bf.EdgeColor = 'none';
bf.FaceColor = [0, 191, 255]./255;
set(get(gca, 'Title'), 'String', '������');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', '��Ͼ������/m');
grid minor
end