function distance = calculate_distance_based_on_rssi(A,b,rssi,varargin)
% ����:
%       ������ϵĶ���·�����ģ��(Logarithmic path loss model )������RSSI��Ӧ��·����
% ����: 
%       function distance = calculate_distance_based_on_rssi(A,b,rssi,varargin)
% ����:
%       A,����1mʱ���豸���յ������źŵ�RSSIֵ;
%       b,˥������;
%       rssi,RSSI(array)
%       varargin:��������
% �����
%       distance:����(array)

%% ģ������
n_10 = 10*b;

%% ����
dist_temp = zeros(0);
n_temp = (A-rssi)./n_10;
% n_temp = abs(n_temp);
dist_temp = power(10,n_temp);

%%
distance = dist_temp;
% disp('rssi �� distance finished');
end