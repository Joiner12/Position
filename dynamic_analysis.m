%%
clc;
data_file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\opeµ•–≈µ¿-ch39≤‚ ‘\static-2.txt';
ap_filter = 'ope_5';
rssi_ch = get_rssi_info(data_file, ap_filter);
tcf('mar');
figure('name', 'mar');
% draw_positioning_state(gca, 'static', [])
