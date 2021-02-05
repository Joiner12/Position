function rssi = calculate_rssi_based_on_distance(model_parameter,distance,varargin)
% ��������:
%   ������ϵĶ���·�����ģ��(Logarithmic path loss model )������·����Ӧ��RSSI��
% ��������:
%   model_parameter(struct):���ģ��
%   {
%       double A(����1mʱ���豸���յ������źŵ�RSSIֵ);
%       doubel n(˥������)
%   }
%   distance:����(array)
%   varargin:��������
% ���������
%   rssi:RSSI(array)

%% ģ������
A = model_parameter.A;
n_10 = 10*model_parameter.n;

%% ����pd(d) = A - 10n*lg(d/d0)
rssi_temp = zeros(0);
dist_temp = distance;
dist_temp(dist_temp<0)=0.1;
rssi_temp = A - n_10*log10(dist_temp);
rssi = rssi_temp;
disp('distance �� rssi finished');
end