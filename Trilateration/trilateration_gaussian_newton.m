function pos_est = trilateration_gaussian_newton(cur_ap,varargin)
% ���ܣ�ʹ�ø�˹-ţ�ٷ��������߶�λ
% ���壺pos_est = trilateration_gaussian_newton(cur_ap,varargin)
% ����:
%       cur_ap:�������Ϣ([struct,struct,struct])
%       name                 mac                  lat       lon       recv_rssi      rssi_reference    rssi     rssi_kf     dist
%       ______________    ___________________    ______    ______    ____________    ______________    _____    _______    ______

%       'onepos_HLK_2'    'e1:04:00:3c:d6:40'    30.548    104.06    [       -61]       -50.068          -61       -61     16.012
%       'onepos_HLK_6'    'c2:04:00:3c:d6:40'    30.548    104.06    [       -71]       -50.068          -71       -71     16.089
%       'onepos_HLK_4'    '1c:06:00:3c:d6:40'    30.548    104.06    [1��2 double]       -50.068        -60.5     -60.5     12.929
%       'onepos_HLK_1'    'a0:04:00:3c:d6:40'    30.548    104.06    [       -74]       -50.068          -74       -74      59.25
% ���:
%       none
% varargin(key:value)


%%
ap_num = length(cur_ap); % ��������
centroid = zeros(1,2);
lat = zeros(ap_num, 1);
lon = zeros(ap_num, 1);
x = zeros(ap_num, 1);
y = zeros(ap_num, 1);
dist = zeros(ap_num, 1);
for i = 1:ap_num
    lat(i) = cur_ap(i).lat;
    lon(i) = cur_ap(i).lon;
    [x(i), y(i), lam] = latlon_to_xy(lat(i), lon(i));
    dist(i) = ap(i).dist;
end
%% access point
if ap_num <= 1  %�������Ϣ����һ�������Ϊ��λ�á�
    pos_est = zeros(1,2);
    
elseif isequal(ap_num,2) % ���������,������Ϊ�����
    centroid = [mean(x),mean(y)];
    pos_est = centroid;
else % >= ���������
    x = reshape(x,[length(x),1]);
    y = reshape(y,[length(y),1]);
    ap_xy = [x,y];
    pos_est = trilateration_calc( ap_xy,dist);
end
%% xyתlatitude longitude
[pos_res.lat, pos_res.lon] = xy_to_latlon(pos_est(1), pos_est(2), lam);
end