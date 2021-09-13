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
data_rssi_y_3 = rssi_fusion(5:34);
data_rssi_y_5 = data_rssi_y_3;
data_rssi_x_3 = 1:1:length(data_rssi_y_3);
data_rssi_x_5 = 1:1:length(data_rssi_y_5);
%% k-means THREE clustering
clc;
opts = statset('Display', 'final');
[idx_3, C_3] = kmeans(data_rssi_y_3, 3, 'Distance', 'cityblock', ...
    'Replicates', 5, 'Options', opts);
%% k-means FIVE clustering
opts = statset('Display', 'final');
[idx_5, C_5] = kmeans(data_rssi_y_3, 5, 'Distance', 'cityblock', ...
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
tcf('ch-figure-1');
%% figure-2 k-means THREE clustering
tcf('clustering-1');
figure('color', 'white', 'name', 'clustering-1');
hold on
plot(data_rssi_x_3, data_rssi_y_3);
plot(data_rssi_x_3(idx_3 == 1), data_rssi_y_3(idx_3 == 1), 'k*', 'MarkerSize', 12)
plot(data_rssi_x_3(idx_3 == 2), data_rssi_y_3(idx_3 == 2), 'r*', 'MarkerSize', 12)
plot(data_rssi_x_3(idx_3 == 3), data_rssi_y_3(idx_3 == 3), 'b*', 'MarkerSize', 12)
line([1, length(data_rssi_y_3)], [C_3(1, 1), C_3(1, 1)], 'LineWidth', 1, 'color', 'k', 'LineStyle', '-')
line([1, length(data_rssi_y_3)], [C_3(2, 1), C_3(2, 1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '-')
line([1, length(data_rssi_y_3)], [C_3(3, 1), C_3(3, 1)], 'LineWidth', 1, 'color', 'b', 'LineStyle', '-')

legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 3', 'Location', 'NW')
title('Cluster Assignments and Origin')
hold off
tcf('clustering-1');
%% figure-3 k-means FIVE clustering
tcf('clustering-2');
figure('color', 'white', 'name', 'clustering-2');
hold on
plot(data_rssi_x_5, data_rssi_y_5);
plot(data_rssi_x_5(idx_5 == 1), data_rssi_y_5(idx_5 == 1), 'k*', 'MarkerSize', 12)
plot(data_rssi_x_5(idx_5 == 2), data_rssi_y_5(idx_5 == 2), 'r*', 'MarkerSize', 12)
plot(data_rssi_x_5(idx_5 == 3), data_rssi_y_5(idx_5 == 3), 'b*', 'MarkerSize', 12)
plot(data_rssi_x_5(idx_5 == 4), data_rssi_y_5(idx_5 == 4), 'c*', 'MarkerSize', 12)
plot(data_rssi_x_5(idx_5 == 5), data_rssi_y_5(idx_5 == 5), 'g*', 'MarkerSize', 12)
line([1, length(data_rssi_y_5)], [C_5(1, 1), C_5(1, 1)], 'LineWidth', 1, 'color', 'k', 'LineStyle', '-')
line([1, length(data_rssi_y_5)], [C_5(2, 1), C_5(2, 1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '-')
line([1, length(data_rssi_y_5)], [C_5(3, 1), C_5(3, 1)], 'LineWidth', 1, 'color', 'b', 'LineStyle', '-')
line([1, length(data_rssi_y_5)], [C_5(4, 1), C_5(4, 1)], 'LineWidth', 1, 'color', 'c', 'LineStyle', '-')
line([1, length(data_rssi_y_5)], [C_5(5, 1), C_5(5, 1)], 'LineWidth', 1, 'color', 'g', 'LineStyle', '-')
legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 3', ...
    'Cluster 4', 'Cluster 5', 'Location', 'NW')
title('Cluster Assignments and Origin')
hold off
tcf('clustering-2');
%% mean val compare
disp('mean values compare');
mean_C3 = sort(C_3);
mean_C5 = sort(C_5);
mean_origin = sort([mean(rssi_37), mean(rssi_38), mean(rssi_39)]);
tcf('mean-1');
figure('color', 'white', 'name', 'mean-1');
hold on
plot([2, 3, 4], mean_C3, 'Marker', '*', 'LineWidth', 1.5);
plot([1, 2, 3, 4, 5], mean_C5, 'Marker', 'o', 'LineWidth', 1.5);
plot([2, 3, 4], mean_origin, 'Marker', '+', 'LineWidth', 1.5);
text([2, 3, 4], mean_origin, {'Ch39', 'Ch37', 'Ch38'});
legend('clustering-3', 'clustering-5', 'single Ch')
grid on
