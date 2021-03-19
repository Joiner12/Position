function analysis_fit_model_piecewise(A1,b1,A2,b2,piecewise_rssi,rssi,true_dist,varargin)
% ����:����**�ֶ����**ģ����Ͻ�� A-10*b*lg(d) = rssi
% ����: analysis_fit_model_piecewise(A1,b1,A2,b2,piecewise_rssi,rssi,true_dist,varargin)
% ����:
%       A1:ģ��-1�ο�RSSIֵ(dB)
%       b1:ģ��-1˥��ϵ��
%       A2:....
%       b2:....
%       piecewise_rssi:�ֶε�RSSIֵ(dB)
%       true_dist:��ʵ����
%       varargin:��������
% ���: none
%{
    ��Ͻ��-rssi >= -50
         General model:
         fitresult_1(x) = power(10,(a-x)/10/b)
         Coefficients (with 95% confidence bounds):
           a =      -39.29  (-44.19, -34.4)
           b =         1.6  (0.7244, 2.476)
    ��Ͻ��-rssi < -50
         General model:
         fitresult_2(x) = power(10,(a-x)/10/b)
         Coefficients (with 95% confidence bounds):
           a =         -12  (-34.99, 10.99)
           b =       4.282  (2.127, 6.438)
%}



%%
% A = model_parameter.A;
% n_10 = 10*model_parameter.n;

%% ���鷽ʽ
%{
  rssi_less = rssi(rssi < piecewise_rssi);
rssi_more = rssi(rssi >= piecewise_rssi);
dist_calc_less = calculate_distance_based_on_rssi(struct('A',A1,'n',b1),rssi_less); % ͨ��rssi������ľ���
dist_calc_more = calculate_distance_based_on_rssi(struct('A',A2,'n',b2),rssi_more); % ͨ��rssi������ľ���

%
dist_calc_less = reshape(dist_calc_less,[1,length(dist_calc_less)]);
dist_calc_more = reshape(dist_calc_more,[1,length(dist_calc_more)]);
dist_calc = [dist_calc_less,dist_calc_more];
%}

%% ������ʽ
len_rssi = length(rssi);
dist_calc = zeros(0);

for i =1:1:len_rssi
    cur_rssi = rssi(i);
    if cur_rssi >= piecewise_rssi
        dist_calc(i) = calculate_distance_based_on_rssi(struct('A',A1,'n',b1),cur_rssi); % ͨ��rssi������ľ���
    else
        dist_calc(i) = calculate_distance_based_on_rssi(struct('A',A2,'n',b2),cur_rssi); % ͨ��rssi������ľ���
    end
end

ser_rssi = linspace(1,len_rssi,len_rssi);

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
set(get(gca, 'Title'), 'String', 'ģ�ͽ�������ʵ����ƫ��');

subplot(224)
model_str = sprintf('$$d(rssi) = %.4f - \\frac{rssi}{10*%.4f}$$',A1,b1);
h=text(0,0.5,model_str);
model_str = sprintf('$$d(rssi) = %.4f - \\frac{rssi}{10*%.4f}$$',A2,b2);
h1=text(0,1,model_str);
set(h,'Interpreter','latex');
set(h1,'Interpreter','latex');
xlim([0 1]);
ylim([0 2]);
set(get(gca, 'Title'), 'String', 'ģ�Ͳ���');
end