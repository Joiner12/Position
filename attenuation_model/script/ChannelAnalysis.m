%% evaluation of k-means channel
clc;
rssi_37 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\', ...
                        'channel-1\ope_9-100ms-2-ch37.txt'], 'ope_9');
rssi_37 = rssi_37(1:350);
rssi_38 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\', ...
                        'channel-1\ope_9-100ms-2-ch38.txt'], 'ope_9');
rssi_39 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\', ...
                        'channel-1\ope_9-100ms-2-ch39.txt'], 'ope_9');
rssi_fusion = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\', ...
                            'channel-1\ope_9-100ms-2-ch-fusion.txt'], 'ope_9');
%% k-means clustering
clc;
data_rssi_y = rssi_fusion(1:300);
data_rssi_x = 1:1:length(data_rssi_y);
opts = statset('Display', 'final');
[idx, C] = kmeans(data_rssi_y, 5, 'Distance', 'sqeuclidean', ...
    'Replicates', 5, 'Options', opts);

%% figure-1 different channel compare
tcf('ch-figure-1'); figure('name', 'ch-figure-1', 'color', 'w');
subplot(221)
plot(rssi_37);
hold on
plot(rssi_38);
plot(rssi_39);
plot(rssi_fusion);
title('all');
legend('37', '38', '39', 'fusion');
subplot(222)
plot(rssi_37);
title('37');
subplot(223)
plot(rssi_38);
title('38');
subplot(224)
plot(rssi_39);
title('39');

%% figure-2 k-means clustering
tcf('clustering-1');
figure('color', 'white', 'name', 'clustering-1');
hold on
plot(data_rssi_x, data_rssi_y);
plot(data_rssi_x(idx == 1), data_rssi_y(idx == 1), 'k*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 2), data_rssi_y(idx == 2), 'r*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 3), data_rssi_y(idx == 3), 'b*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 4), data_rssi_y(idx == 4), 'c*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 5), data_rssi_y(idx == 5), 'g*', 'MarkerSize', 12)
line([1, length(data_rssi_y)], [C(1, 1), C(1, 1)], 'LineWidth', 1, 'color', 'k', 'LineStyle', '-')
line([1, length(data_rssi_y)], [C(2, 1), C(2, 1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '-')
line([1, length(data_rssi_y)], [C(3, 1), C(3, 1)], 'LineWidth', 1, 'color', 'b', 'LineStyle', '-')
line([1, length(data_rssi_y)], [C(4, 1), C(4, 1)], 'LineWidth', 1, 'color', 'c', 'LineStyle', '-')
line([1, length(data_rssi_y)], [C(5, 1), C(5, 1)], 'LineWidth', 1, 'color', 'g', 'LineStyle', '-')
legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 3', ...
    'Cluster 4', 'Cluster 5', 'Location', 'NW')
title('Cluster Assignments and Origin')
hold off
