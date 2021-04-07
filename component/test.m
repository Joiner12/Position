%%
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\cur_frame.mat');
%%
clc;
ap_selector = init_ap_selector(10);
[trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector);

%% 根据apselector信息选择定位点
%{
ap selector 选择依据：
1.ap活跃度；窗口周期内有效RSSI值的个数。
2.ap rssi 统计性能，比重：活跃度 > 均值 > 方差
%}

clc;
clear;
a = tic();
load cur_ap.mat
load rssi_s.mat
load ap_selector.mat

rssi_s = ap_selector.RECVRSSI;

act_rssi = zeros(0);

for i = 1:1:size(rssi_s, 1)
    act_rssi(i, 1) = length(find(rssi_s(i, :)));
end

% 拼接最大的三个ap的信息
[~, max_points_index] = maxk(act_rssi, 3);
trilateration_ap = struct();

for j = 1:1:length(max_points_index)
    trilateration_ap(j).name = ap_selector.NAME(max_points_index(j));
    trilateration_ap(j).mac = ap_selector.MAC(max_points_index(j));
    trilateration_ap(j).lat = ap_selector.LAT(max_points_index(j));
    trilateration_ap(j).lon = ap_selector.LON(max_points_index(j));
    trilateration_ap(j).recv_rssi = ap_selector.RSSI(max_points_index(j));
    trilateration_ap(j).rssi_reference = ap_selector.RSSI_REF(max_points_index(j));
    % 选择活跃度最大的三个ap的RSSI的均值作为定位选择输出
    % trilateration_ap(j).rssi = ap_selector.rssi(max_points_index(j));
    rssi_temp = ap_selector.RECVRSSI(max_points_index(j));
    rssi_temp = rssi_temp(rssi_temp~=0);
    trilateration_ap(j).rssi = mean(rssi_temp);
    trilateration_ap(j).rssi_wma = ap_selector.RSSI(max_points_index(j));
    trilateration_ap(j).rssi_gf = ap_selector.RSSI(max_points_index(j));
    trilateration_ap(j).rssi_kf = ap_selector.RSSI(max_points_index(j));
    trilateration_ap(j).dist = 0; % with a hammer dist
end
toc(a)