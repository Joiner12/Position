%% -------------------------------------------------------------------------- %%
%% ��֤knn�㷨
clc;
n_neigherbors = 9;
test_fingerprinting = [-64, -54, -61, -61.2];
test_fingerprinting = [-63, -53, -60, -66];
grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors);
grid_pos_prediction

%% -------------------------------------------------------------------------- %%
%% ָ�����ݲ�ȫ
clear;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\ble_data_base_least.mat', ...
'data');
% 2.����Ԥ����
% ����cell2matת����֮������ݸ�ʽ:
% ['Beacon0','Beacon1','Beacon6','Beacon7','POS_X','POS_Y']
% [-66,-42,-62,-65,0,0]
data_mat = cell2mat(data);
ble_figureprinting_train = data_mat(:, 1:4); % ��������
ble_labels_train = data_mat(:, 5:6);
tcf('filldata');
figure('name', 'filldata', 'color', 'w');
c = linspace(1, length(ble_labels_train), length(ble_labels_train));
scatter(ble_labels_train(:, 1), ble_labels_train(:, 2), 40, c, 'filled')
axis('equal');
% % ����������[x,y]ת��Ϊ�ַ�������"x:x-y:x"
% for k = 1:1:length(ble_figureprinting_train)
%     ble_labels_train(k) = strcat("x:", num2str(data_mat(k, 5)), ...
%         ",", "y:", num2str(data_mat(k, 6)));
% end
%% -------------------------------------------------------------------------- %%
%% ָ�����ݲ�ȫ�ֶ���ȫ
clc;
% completion
x_completion = repmat(13, [1, 9]);
y_completion = [0, 2, 4, 6, 8, 10, 12, 14, 15];
fp_completion = zeros(13, 4);
data_new = data;
% [11,0],[13,0] -54	-64	-67	-58 & [9,0] -56	-58	-65	-63
fg_11_0 = ([-54	-64	-67	-58] + [-56	-58	-65	-63]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_0(1);
data_new{index_temp, 2} = fg_11_0(2);
data_new{index_temp, 3} = fg_11_0(3);
data_new{index_temp, 4} = fg_11_0(4);
data_new{index_temp, 5} = [11, 0];
% [13,2],[13,0] -54	-64	-67	-58 & [13,4] -53	-57	-69	-58
fg_13_2 = ([-54	-64	-67	-58] + [-53	-57	-69	-58]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_13_2(1);
data_new{index_temp, 2} = fg_13_2(2);
data_new{index_temp, 3} = fg_13_2(3);
data_new{index_temp, 4} = fg_13_2(4);
data_new{index_temp, 5} = [13, 2];
% [11,2],[13,2] fg_13_2 & [9,2] -52	-55	-67	-64
fg_11_2 = (fg_13_2 + [-52	-55	-67	-64]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_2(1);
data_new{index_temp, 2} = fg_11_2(2);
data_new{index_temp, 3} = fg_11_2(3);
data_new{index_temp, 4} = fg_11_2(4);
data_new{index_temp, 5} = [11, 2];
% [11,4],[13,4] -53	-57	-69	-58 & [9,4] -52	-59	-62	-58
fg_11_4 = ([-53	-57	-69	-58] + [-52	-59	-62	-58]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_4(1);
data_new{index_temp, 2} = fg_11_4(2);
data_new{index_temp, 3} = fg_11_4(3);
data_new{index_temp, 4} = fg_11_4(4);
data_new{index_temp, 5} = [11, 4];
% [11,6],[13,6] -55	-60	-60	-55 & [9,6] -55	-62	-64	-60
fg_11_6 = ([-55	-60	-60	-55] + [-55	-62	-64	-60]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_6(1);
data_new{index_temp, 2} = fg_11_6(2);
data_new{index_temp, 3} = fg_11_6(3);
data_new{index_temp, 4} = fg_11_6(4);
data_new{index_temp, 5} = [11, 6];
% [11,8],[13,8] -61	-62	-62	-50 & [9,8] -62	-58	-62	-52
fg_11_8 = ([-61	-62	-62	-50] + [-62	-58	-62	-52]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_8(1);
data_new{index_temp, 2} = fg_11_8(2);
data_new{index_temp, 3} = fg_11_8(3);
data_new{index_temp, 4} = fg_11_8(4);
data_new{index_temp, 5} = [11, 8];
% [11,10],[13,10] -61	-52	-59	-48 & [9,10] -61	-64	-62	-53
fg_11_10 = ([-61	-52	-59	-48] + [-61	-64	-62	-53]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_10(1);
data_new{index_temp, 2} = fg_11_10(2);
data_new{index_temp, 3} = fg_11_10(3);
data_new{index_temp, 4} = fg_11_10(4);
data_new{index_temp, 5} = [11, 10];
% [11,12],[13,12] -65	-63	-64	-49 & [9,12] -60	-61	-58	-59
fg_11_12 = ([-65	-63	-64	-49] + [-60	-61	-58	-59]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_12(1);
data_new{index_temp, 2} = fg_11_12(2);
data_new{index_temp, 3} = fg_11_12(3);
data_new{index_temp, 4} = fg_11_12(4);
data_new{index_temp, 5} = [11, 12];
% [11,14],[13,14] -68	-68	-59	-48 & [9,14] -63	-69	-64	-58
fg_11_14 = ([-68	-68	-59	-48] + [-63	-69	-64	-58]) ./ 2;
index_temp = length(data_new) + 1;
data_new{index_temp, 1} = fg_11_14(1);
data_new{index_temp, 2} = fg_11_14(2);
data_new{index_temp, 3} = fg_11_14(3);
data_new{index_temp, 4} = fg_11_14(4);
data_new{index_temp, 5} = [11, 14];
ble_labels_train_new = cell2mat(data_new);
ble_labels_train_new = ble_labels_train_new(:, 5:6);

tcf('filldata_1');
figure('name', 'filldata_1', 'color', 'w');
c = linspace(1, length(ble_labels_train_new), length(ble_labels_train_new));
scatter(ble_labels_train_new(:, 1), ble_labels_train_new(:, 2), 40, c, 'filled');
axis('equal');
