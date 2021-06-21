% k-means for rssi
%%
clc;
data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\', ...
            'attenuation_model\data\8节点测试\', ...
            '8节点测试\OnePos-12m-00cm.txt'];
cur_rssi = get_rssi_info(data_file);
tcf('dh');
figure('name', 'dh', 'color', 'white');
x_rssi = linspace(1, length(cur_rssi), length(cur_rssi));
% plot(x_rssi(1:100),cur_rssi(1:100), 'marker','*');
plot(cur_rssi(1:end), 'marker', '*');

%%
clc;
data_rssi_y = cur_rssi(1:100);
data_rssi_x = 1:1:length(data_rssi_y);
X = [data_rssi_y, data_rssi_y];
tcf('clustering');
figure('color', 'white', 'name', 'clustering');
subplot(221)
plot(X(:, 1), X(:, 2), '.');
title('rssi');
opts = statset('Display', 'final');
[idx, C] = kmeans(X, 3, 'Distance', 'cityblock', ...
    'Replicates', 5, 'Options', opts);
subplot(222)
plot(X(idx == 1, 1), X(idx == 1, 2), 'r.', 'MarkerSize', 12)
hold on
plot(X(idx == 2, 1), X(idx == 2, 2), 'b.', 'MarkerSize', 12)
plot(X(idx == 3, 1), X(idx == 3, 2), 'c.', 'MarkerSize', 12)
plot(C(:, 1), C(:, 2), 'kx', 'MarkerSize', 15, 'LineWidth', 3)
legend('Cluster 1', 'Cluster 2', 'Centroids', ...
    'Location', 'NW')
title('Cluster Assignments and Centroids')
hold off

subplot(223);
hold on
plot(data_rssi_y, 'marker', '*');
plot(data_rssi_x(idx == 1), X(idx == 1, 2), 'r.', 'MarkerSize', 12)
plot(data_rssi_x(idx == 2), X(idx == 2, 2), 'b.', 'MarkerSize', 12)
plot(data_rssi_x(idx == 3), X(idx == 3, 2), 'c.', 'MarkerSize', 12)
line([1, length(data_rssi_y)], [C(1, 1), C(1, 1)], 'LineWidth', 2, 'color', 'r')
line([1, length(data_rssi_y)], [C(2, 1), C(2, 1)], 'LineWidth', 2, 'color', 'g')
line([1, length(data_rssi_y)], [C(3, 1), C(3, 1)], 'LineWidth', 2, 'color', 'c')
legend('origin', 'Cluster 1', 'Cluster 2', 'Cluster 3')
title 'Cluster Assignments and Centroids'
hold off
