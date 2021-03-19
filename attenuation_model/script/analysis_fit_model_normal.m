function analysis_fit_model_normal(A,b,rssi,true_dist,varargin)
% ����:����ģ����Ͻ�� A-10*b*lg(d) = rssi
% ����: analysis_fit_model(a,b,rssi,true_dist)
% ����: 
%       A:����1m��RSSIֵ.
%       b:˥��ϵ��
%       true_dist:��ʵ����
%       varargin:��������
% ���: none
%{
     Coefficients (with 95% confidence bounds):
       a =      -41.43  (-43.22, -39.64)
       b =      -1.445  (-1.638, -1.252)
%}

%% 
% A = model_parameter.A;
% n_10 = 10*model_parameter.n;
dist_calc = calculate_distance_based_on_rssi(struct('A',A,'n',b),rssi); % ͨ��rssi������ľ���
ser_rssi = linspace(1,length(rssi),length(rssi));
[m_val,v_val,~,~] = get_rssi_statistics(rssi);
% ��ͼ
tcf('NN');
figure('Name','NN','Color','w');
subplot(221)
scatter_py(ser_rssi,rssi);
set(get(gca, 'Title'), 'String', 'RSSI�ֲ����');
set(get(gca, 'XLabel'), 'String', '��������');
set(get(gca, 'YLabel'), 'String', 'RSSI/dB');
temp =  max(abs(min(rssi)-m_val),abs(max(rssi)-m_val));
letemp = sprintf(['RSSI������ֵ:%.2f\n',... 
    'RSSI��������:%0.2f\n',... 
    'RSSI��������ֵ:%.2f\n',... 
    'RSSI������ֵ����:%.2f\n'],m_val,v_val,max(rssi)-min(rssi),temp);
legend(letemp);
grid on

subplot(222)
set(get(gca, 'Title'), 'String', 'ģ�ͽ������Ա���ʵ����');
plot_py([1,max(ser_rssi)],[true_dist,true_dist]);
hold on
plot_py(ser_rssi,dist_calc);
legend({'��ʵ����','ģ�ͽ������'});
set(get(gca, 'XLabel'), 'String', '��������');
set(get(gca, 'YLabel'), 'String', '����/m');

subplot(223)
set(get(gca, 'Title'), 'String', 'ƫ��');
% plot_py(ser_rssi,dist_calc-true_dist);
area(ser_rssi,dist_calc-true_dist);
set(get(gca, 'XLabel'), 'String', '��������');
set(get(gca, 'YLabel'), 'String', '����/m');
grid on

subplot(224)
model_str = sprintf('$$d(rssi) = %.4f - \\frac{rssi}{10*%.4f}$$',A,b);
h=text(0,0.5,model_str);
set(h,'Interpreter','latex');
end