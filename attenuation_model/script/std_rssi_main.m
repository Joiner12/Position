%% 获取beacon的rssi信息
clc;
BeaconRSSI = struct();
mean_vals = zeros(0);
std_vals = zeros(0);
fluct_vals = zeros(0);
C_s = cell(0);
Clusters = cell(0);
median_mean_vals = zeros(0);

for k = 1:1:11
    cur_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\Beacon6-', ...
                num2str(k), 'm.txt'];
    rssi = get_rssi_info(cur_file, 'Beacon6');
    BeaconRSSI(k).dist = k;
    BeaconRSSI(k).rssi = rssi;
    BeaconRSSI(k).rssi_mean = mean(rssi);
    BeaconRSSI(k).rssi_std = std(rssi);
    BeaconRSSI(k).rssi_fluctuation = max(rssi) - min(rssi);
    mean_vals(k) = BeaconRSSI(k).rssi_mean;
    std_vals(k) = BeaconRSSI(k).rssi_std;
    fluct_vals(k) = BeaconRSSI(k).rssi_fluctuation;
    % 信道聚类
    [org_idx, C] = channel_clustering(BeaconRSSI(k).rssi, 3);
    BeaconRSSI(k).C = C;
    BeaconRSSI(k).clustering = org_idx;
    Clusters{k} = org_idx;
    C_s{k} = C;
    % 中值滤波 窗口大小21
    BeaconRSSI(k).rssi_medianfilter = medfilt1(rssi, 21);
    median_mean_vals(k) = mean(BeaconRSSI(k).rssi_medianfilter);
end

%% figure 混合信道下 dist-rssi
clc;
tcf('beacon-1'); f1 = figure('name', 'beacon-1', 'color', 'w');

for k = 1:1:6
    subplot(3, 2, k);
    plot(BeaconRSSI(k).rssi);
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-2'); f2 = figure('name', 'beacon-2', 'color', 'w');

for k = 7:1:11
    subplot(3, 2, k - 6);
    plot(BeaconRSSI(k).rssi);
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-3'); figure('name', 'beacon-3', 'color', 'w');
subplot(2, 2, 1)
plot(1:1:11, mean_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI均值');
subplot(2, 2, 2)
plot(1:1:11, std_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI标准差');
subplot(2, 2, 3)
plot(1:1:11, fluct_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI波动值');

%% figure-4
tcf('clustering'); figure('name', 'clustering', 'color', 'w');
hold on

for k = 1:11
    cur_C = BeaconRSSI(k).C;
    cur_dist = BeaconRSSI(k).dist;
    cur_clustering = BeaconRSSI(k).clustering;
    idx_temp = cur_clustering(:, 2);
    ch37 = idx_temp(idx_temp == 1);
    ch38 = idx_temp(idx_temp == 2);
    ch39 = idx_temp(idx_temp == 3);
    plot(cur_dist .* ones(size(cur_C)), cur_C, 'LineStyle', 'None', 'Marker', '*');
end

set(get(gca, 'Title'), 'String', '距离——RSSI信道聚类结果');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
%%
clc;
[org_idx, C] = channel_clustering(BeaconRSSI(4).rssi, 3);
%% figure median filter vs origin
clc;
tcf('beacon-median-1'); f1 = figure('name', 'beacon-median-1', 'color', 'w');

for k = 1:1:6
    subplot(3, 2, k);
    plot(BeaconRSSI(k).rssi);
    hold on
    plot(BeaconRSSI(k).rssi_medianfilter);
    legend('origin RSSI', 'median RSSI');
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-median-2'); f2 = figure('name', 'beacon-median-2', 'color', 'w');

for k = 7:1:11
    subplot(3, 2, k - 6);
    plot(BeaconRSSI(k).rssi);
    hold on
    plot(BeaconRSSI(k).rssi_medianfilter);
    legend('origin RSSI', 'median RSSI');
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

subplot(3, 2, 6)
plot(linspace(1, length(median_mean_vals), length(median_mean_vals)), median_mean_vals)
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
