% k-means for rssi
%%
clc;
data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\', ...
            'attenuation_model\data\8节点测试\', ...
            '8节点测试\OnePos-13m-00cm.txt'];
data_file = 'C:\Users\W-H\Desktop\10米.txt';
cur_rssi = get_rssi_info(data_file);
tcf('dh');
figure('name', 'dh', 'color', 'white');
x_rssi = linspace(1, length(cur_rssi), length(cur_rssi));
% plot(x_rssi(1:100),cur_rssi(1:100), 'marker','*');
plot(cur_rssi(1:end), 'marker', '*');

%%
clc;
data_rssi_y = cur_rssi(1:50);
data_rssi_x = 1:1:length(data_rssi_y);
opts = statset('Display', 'final');
[idx, C] = kmeans(data_rssi_y, 3, 'Distance', 'cityblock', ...
    'Replicates', 5, 'Options', opts);
tcf('clustering-1');
figure('color', 'white', 'name', 'clustering-1');
hold on
plot(data_rssi_x, data_rssi_y);
plot(data_rssi_x(idx == 1), data_rssi_y(idx == 1), 'r*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 2), data_rssi_y(idx == 2), 'b*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 3), data_rssi_y(idx == 3), 'c*', 'MarkerSize', 12)
line([1, length(data_rssi_y)], [C(1, 1), C(1, 1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '--')
line([1, length(data_rssi_y)], [C(2, 1), C(2, 1)], 'LineWidth', 1, 'color', 'g', 'LineStyle', '--')
line([1, length(data_rssi_y)], [C(3, 1), C(3, 1)], 'LineWidth', 1, 'color', 'c', 'LineStyle', '--')
legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 2', 'Location', 'NW')
title('Cluster Assignments and Origin')
hold off

%%
clc;
data_rssi_y = cur_rssi(1:50);
[rssi_channle, C1] = cluster_ble_channle(data_rssi_y);
data_rssi_x = 1:1:length(rssi_channle);
idx = rssi_channle(:, 2);
tcf('clustering');
figure('color', 'white', 'name', 'clustering');
hold on
plot(data_rssi_x, data_rssi_y);
plot(data_rssi_x(idx == 1), data_rssi_y(idx == 1), 'r*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 2), data_rssi_y(idx == 2), 'b*', 'MarkerSize', 12)
plot(data_rssi_x(idx == 3), data_rssi_y(idx == 3), 'c*', 'MarkerSize', 12)
line([1, length(data_rssi_y)], [C1(1), C1(1)], 'LineWidth', 1, 'color', 'r', 'LineStyle', '--')
line([1, length(data_rssi_y)], [C1(2), C1(2)], 'LineWidth', 1, 'color', 'g', 'LineStyle', '--')
line([1, length(data_rssi_y)], [C1(3), C1(3)], 'LineWidth', 1, 'color', 'c', 'LineStyle', '--')
legend('rssi', 'Cluster 1', 'Cluster 2', 'Cluster 2', 'Location', 'NW')
title('Cluster Assignments and Origin')
hold off

%% 
a = [1,2;3,4;5,6];
b = [2,3;3,1];
c={a,b}
mean(c{1,1})
