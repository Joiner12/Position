%% -------------------------------------------------------------------------- %%
%% 验证knn算法
clc;
n_neigherbors = 9;
test_fingerprinting = [-64, -54, -61, -61.2];
test_fingerprinting = [-63, -53, -60, -66];
grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors);
%%
grid_pos_prediction_1 = [2, 3.55555555555556];
grid_pos_prediction_2 = [0, 4];
true_pos = [0, 4];
pdist2(grid_pos_prediction_1, true_pos, 'euclidean')
pdist2(grid_pos_prediction_2, true_pos, 'euclidean')
%% -------------------------------------------------------------------------- %%
%% 指纹数据补全
clear;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\ble_data_base_least.mat', ...
'data');
% 2.数据预处理
% 调用cell2mat转换完之后的数据格式:
% ['Beacon0','Beacon1','Beacon6','Beacon7','POS_X','POS_Y']
% [-66,-42,-62,-65,0,0]
data_mat = cell2mat(data);
ble_figureprinting_train = data_mat(:, 1:4); % 特征数据
ble_labels_train = data_mat(:, 5:6);
tcf('filldata');
figure('name', 'filldata', 'color', 'w');
c = linspace(1, length(ble_labels_train), length(ble_labels_train));
scatter(ble_labels_train(:, 1), ble_labels_train(:, 2), 40, c, 'filled')
axis('equal');
% % 将数组坐标[x,y]转换为字符串坐标"x:x-y:x"
% for k = 1:1:length(ble_figureprinting_train)
%     ble_labels_train(k) = strcat("x:", num2str(data_mat(k, 5)), ...
%         ",", "y:", num2str(data_mat(k, 6)));
% end
%% -------------------------------------------------------------------------- %%
