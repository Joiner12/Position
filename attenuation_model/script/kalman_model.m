%% std dist rssi data kalman
clc;
std_rssi_dist_HLKALL = {std_rssi_one_HLK_1; std_rssi_one_HLK_2; ...
                        std_rssi_one_HLK_3; std_rssi_one_HLK_4; ...
                        std_rssi_one_HLK_5; std_rssi_one_HLK_6; ...
                        std_rssi_one_HLK_7; std_rssi_one_HLK_8};

%%
rssi = get_rssi_info('D:\Code\BlueTooth\pos_bluetooth_matlab\data\¶¯Ì¬2021-04-20-m-apfilter.txt', '7');
% rssi = std_rssi_one_HLK_1{1}.RSSI;
rssi_kf = kalman_filter_f(rssi); % kalman filter
rssi_maf = filter(ones(1, 20) ./ 20, 1, rssi);
tcf('aishangni');
figure('name', 'aishangni');
plot_py(linspace(1, length(rssi), length(rssi)), rssi)
hold on
plot_py(linspace(1, length(rssi_kf), length(rssi_kf)), rssi_kf)
hold on
plot_py(linspace(1, length(rssi_maf), length(rssi_maf)), rssi_maf)
legend({'rssi', 'kalman', 'maf'})
disp(mean(rssi))
disp(mean(rssi_kf))
