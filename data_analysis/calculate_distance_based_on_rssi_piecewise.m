function distance = calculate_distance_based_on_rssi_piecewise(...
    model_param_less_rssi,model_param_more_rssi,rssi,piecewise_rssi,varargin)
% ����:
%   ������ϵĶ���·�����ģ��(Logarithmic path loss model )������RSSI��Ӧ��·����
% ����:distance = calculate_distance_based_on_rssi_piecewise(...
%   model_param_less_rssi,model_param_more_rssi,rssi,piecewise_rssi,varargin)
% ����:
%   model_param_less_rssi:���ģ��(RSSI<piecewise_rssi)
%   [
%       double A(�ο�RSSIֵ(dB));
%       doubel n(˥������)
%   ]
%   model_param_more_rssi:���ģ��(RSSI>=piecewise_rssi)
%   [
%       double A(�ο�RSSIֵ(dB));
%       doubel n(˥������)
%   ]
%   piecewise_rssi:�ֶ�RSSIֵ(dB)
%   rssi:RSSI(array)
%   varargin:��������
% �����
%   distance:����(array)


%% ģ������
A_1 = model_param_less_rssi(1);
n_1 = model_param_less_rssi(2);

A_2 = model_param_more_rssi(1);
n_2 = model_param_more_rssi(2);

%%
if length(rssi) == 1
    if rssi < piecewise_rssi
        dist_calc = calc_dist(A_1,n_1,rssi);
    else
        dist_calc = calc_dist(A_2,n_2,rssi);
    end
    dist_temp = dist_calc;
else
    dist_temp = zeros(0);
    for j=1:1:length(rssi)
        cur_rssi = rssi(j);
        if cur_rssi < piecewise_rssi
            dist_calc = calc_dist(A_1,n_1,cur_rssi);
        else
            dist_calc = calc_dist(A_2,n_2,cur_rssi);
        end
        dist_temp(j) = dist_calc;
    end
end

distance = dist_temp;
% disp('rssi �� distance finished');
end

%% static function
function dist = calc_dist(A,n,rssi)
n_temp = (A-rssi)./n/10;
dist = power(10,n_temp);
end