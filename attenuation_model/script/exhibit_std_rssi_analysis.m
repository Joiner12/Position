function [m_val,v_val,k_val,s_val] = exhibit_std_rssi_analysis(rssi,varargin)
% ����: ������׼RSSI-Distͳ����Ϣ
% ����: exhibit_std_rssi_dist(rssi,dist)
% ����:
%       rssi:ͬ�Ⱦ�����RSSI�Ķ�β���ֵ(����)
%       varargin:��������
% ���:
%       None

x = linspace(1,length(rssi),length(rssi));
y = rssi;
%{ 
    ͳ������:������ֵ���������ƫ�ȡ����
    ƫ��(skewness)��
    ��̬�ֲ���ƫ��=0������ƫ�ֲ���Ҳ����ƫ�ֲ�����ƫ��>0������ƫ�ֲ���Ҳ�и�ƫ�ֲ�����ƫ��<0��
    ���(kurtosis)��
    ��̬�ֲ������ֵ=3������β�����ֵ>3������β�����ֵ<3��
%}
m_val = mean(y);
v_val = var(y);
k_val = kurtosis(y); % ���
s_val = skewness(y); % ƫ��


f = figure('Color',[1 1 1]);

subplot(2,2,1)
histogram(y)
set(get(gca, 'Title'), 'String', '���ݷֲ�-1');
set(get(gca, 'XLabel'), 'String', 'rssi/dB');
set(get(gca, 'YLabel'), 'String', 'counter');
modify_axes_label(gca)

subplot(2,2,2)
scatter(x,y,'Marker','*');
axis([-10,length(y)+10,min(y)-5,max(y)+5])
hold on 
plot_py([1,max(x)+10],[m_val,m_val]);
set(get(gca, 'XLabel'), 'String', 'rssi/dB');
set(get(gca, 'YLabel'), 'String', 'counter');
set(get(gca, 'Title'), 'String', '���ݷֲ�-2');
legend({'ԭʼ����','��ֵ'});
modify_axes_label(gca)


subplot(2,2,3)
histfit(y,int32(max(y)-min(y)+2))
set(get(gca, 'Title'), 'String', '�ֲ����');
set(get(gca, 'XLabel'), 'String', 'rssi/dB');
set(get(gca, 'YLabel'), 'String', 'counter');
modify_axes_label(gca)

% ͳ������:
subplot(2,2,4)
title_temp_1 = sprintf('������ֵ:%.2f', m_val);
title_temp_2 = sprintf('��������:%.2f', v_val);
title_temp_3 = sprintf('���:%.2f', k_val);
title_temp_4 = sprintf('ƫ��:%.2f', s_val);
annotation(f,'textbox',...
    [0.606165263679127 0.14572007720965 0.238392850570381 0.285714277908916],...
    'Color',[0.850980392156863 0.329411764705882 0.101960784313725],...
    'String', {'ͳ������',title_temp_1,title_temp_2,title_temp_3,title_temp_4},...
    'FontWeight','bold',...
    'FontSize',15,...
    'FontName','����',...
    'FitBoxToText','off',...
    'EdgeColor',[0.650980392156863 0.650980392156863 0.650980392156863]);
box(gca,'on');

if any(strcmp(varargin,'savefig'))
    saveas(f,'cur.fig')
end

end