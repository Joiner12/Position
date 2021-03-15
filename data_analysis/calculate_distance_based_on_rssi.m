function distance = calculate_distance_based_on_rssi(model_parameter,rssi,varargin)
% ����:
%   ������ϵĶ���·�����ģ��(Logarithmic path loss model )������RSSI��Ӧ��·����
% ����: distance = calculate_distance_based_on_rssi(model_parameter,rssi,varargin)
% ����:
%   model_parameter(struct):���ģ��
%   {
%       double A(����1mʱ���豸���յ������źŵ�RSSIֵ);
%       doubel n(˥������)
%   }
%   rssi:RSSI(array)
%   varargin:��������
% �����
%   distance:����(array)

%% ģ������
A = model_parameter.A;
n_10 = 10*model_parameter.n;

%% ����
dist_temp = zeros(0);
n_temp = (A-rssi)./n_10;
% n_temp = abs(n_temp);
dist_temp = power(10,n_temp);

%%
distance = dist_temp;
% disp('rssi �� distance finished');
end