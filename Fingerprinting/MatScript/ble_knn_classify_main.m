%% ����ָ�ƶ�λ������
%% -------------------------------------------------------------------------- %%
%% ��֤knn�㷨
clc;
n_neigherbors = 9;
% [-60	-56	-59	-65],[7,6]
test_fingerprinting = [-60	-56	-59	-65];
grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors, 'truepos', [7, 6]);
pdist2(grid_pos_prediction, [7, 6], 'euclidean')
%% -------------------------------------------------------------------------- %%
%% ��֤k��Ԥ��ƫ��Ĺ�ϵ
prediction_dist = zeros(0);

for k = 1:20
    n_neigherbors = k;
    % [-60	-56	-59	-65],[7,6]
    test_fingerprinting = [-60	-56	-59	-65];
    grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors, 'truepos', [7, 6]);
    prediction_dist(k) = pdist2(grid_pos_prediction, [7, 6], 'euclidean');
end

figure()
plot(prediction_dist)
set(get(gca, 'XLabel'), 'String', 'k');
set(get(gca, 'YLabel'), 'String', 'euclidean dist');
%% -------------------------------------------------------------------------- %%
%% knnsearch����׼ȷ����֤
% ����ָ������
if false
    load(['D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\', ...
        'ble_data_base_least.mat'], 'data');
    data_in = data;
else
    load(['D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\', ...
        'ble_data_base_least_completion.mat'], 'data_new');
    data_in = data_new;
end

% ble_data_base_least_completion
% 2.����Ԥ����
% ����cell2matת����֮������ݸ�ʽ:
% ['Beacon0','Beacon1','Beacon6','Beacon7','POS_X','POS_Y']
% [-66,-42,-62,-65,0,0]
data_mat = cell2mat(data_in);
ble_figureprinting_train = data_mat(:, 1:4); % ��������
ble_labels_train = strings(0);

% ����������[x,y]ת��Ϊ�ַ�������"x:x-y:x"
for k = 1:1:length(ble_figureprinting_train)
    ble_labels_train(k) = strcat("x:", num2str(data_mat(k, 5)), ...
        ",", "y:", num2str(data_mat(k, 6)));
end

ble_labels_train = reshape(ble_labels_train, ...
    [length(ble_labels_train), 1]);

% lose rate
losr_rate = zeros(0);

for k = 1:20
    n_neigherbors = k;
    rng(100);
    Mdl = fitcknn(ble_figureprinting_train, ble_labels_train, 'NumNeighbors', n_neigherbors);
    loss = resubLoss(Mdl);
    losr_rate(k) = loss;
    rng(10); % For reproducibility
    CVMdl = crossval(Mdl, 'KFold', 5);
    kloss = kfoldLoss(CVMdl);
end

%% -------------------------------------------------------------------------- %%
%% ����������ͼ
clc;

f_gaussian = @(x, a, b, c)(a * exp((-0.5 .* (x - b).^2) / c^2));
x_gaussian = -45:0.5:55;
y_gaussian = f_gaussian(x_gaussian, 1, 5, 10);

plot(x_gaussian, y_gaussian, 'Linewidth', 2)

function weight_value = gaussian_weight(dist, a, b, c)
    weight_value = a * exp((-0.5 .* (dist - b).^2) / c^2)
end
