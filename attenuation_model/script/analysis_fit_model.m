function analysis_fit_model(A,b,rssi,true_dist,varargin)
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

% ��ͼ
figure('Name','NN','Color','w');
subplot(311)
scatter_py(ser_rssi,rssi)
% (A-rssi)./n_10;
model_str = sprintf('d(rssi) = .4f%-rssi/10/.4f%',A,b);
set(get(gca, 'Title'), 'String', model_str);
grid on

subplot(312)
plot_py([1,max(ser_rssi)],[true_dist,true_dist]);
hold on
plot_py(ser_rssi,dist_calc)

subplot(313)
plot_py(ser_rssi,dist_calc-true_dist)
end