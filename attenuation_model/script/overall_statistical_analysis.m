function overall_statistical_analysis(dist,mean_vals,variance_vals,kurtosis_vals,skewness_vals,varargin)
% ����:
%       ���Ʊ�׼RSSI����ͳ�ƽ��(��ֵ��ƫ�ȡ�������)������ϵͼ;
% ����:
%       overall_statistical_analysis(dist,mean_vals,variance_vals,kurtosis_vals,skewness_vals,varargin)
% ���룺
%       dist:����
%       mean_vals:������Ӧ��ֵ
%       variance_vals:...����
%       kurtosis_vals:...���
%       skewness_vals:...ƫ��
%       varargin:��������
% ���:
%       None


%% ����ͳ�Ʒ���;
figure('name','norm-analysis','Color',[1 1 1]);

subplot(2,2,1)
plot_py(dist,mean_vals)
set(get(gca, 'Title'), 'String', '��ֵ�����仯����');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB');

subplot(2,2,2)
plot_py(dist,variance_vals)
set(get(gca, 'Title'), 'String', '���������仯����');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB^2');

subplot(2,2,3)
plot_py(dist,kurtosis_vals);
set(get(gca, 'Title'), 'String', '��������仯����');
hold on
plot_py([1 18],[3 3]);
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', '���');
legend({'�����������','��̬�ֲ����'})

subplot(2,2,4)
plot_py(dist,skewness_vals)
hold on
plot_py([1,18],[0,0])
set(get(gca, 'Title'), 'String', 'ƫ�������仯����');
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'ƫ��');
legend({'��������ƫ��','��̬�ֲ�ƫ��(0ƫ��)'})

end