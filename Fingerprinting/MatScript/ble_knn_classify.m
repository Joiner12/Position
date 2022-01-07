function grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors, varargin)
    % 蓝牙指纹匹配函数
    % 说明:
    %   1.蓝牙指纹特征数据及对应的网格坐标存储在本地,
    %   进行KNN分类的时候,加载到内存中.
    %   2.蓝牙指纹匹配关键参数预先训练好，关键参数包括:
    %   归一化方法、邻居数量.
    % 参数:
    %   test_fingerprinting:待匹配蓝牙指纹数据
    %   n_neigherbors:k值
    % 输出:
    %   grid_pos_prediction:KNN分类的网格坐标
    %%
    % 1.加载预先处理好的特征数据和标签
    % 数据格式说明:
    % ble_data_base_least.mat中数据格式:
    % ['Beacon0','Beacon1','Beacon6','Beacon7','POS']
    % [-66,-42,-62,-65,[0,0]]
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
    % 2.数据预处理
    % 调用cell2mat转换完之后的数据格式:
    % ['Beacon0','Beacon1','Beacon6','Beacon7','POS_X','POS_Y']
    % [-66,-42,-62,-65,0,0]
    data_mat = cell2mat(data_in);
    ble_figureprinting_train = data_mat(:, 1:4); % 特征数据
    ble_labels_train = strings(0);

    % 将数组坐标[x,y]转换为字符串坐标"x:x-y:x"
    for k = 1:1:length(ble_figureprinting_train)
        ble_labels_train(k) = strcat("x:", num2str(data_mat(k, 5)), ...
            ",", "y:", num2str(data_mat(k, 6)));
    end

    ble_labels_train = reshape(ble_labels_train, ...
        [length(ble_labels_train), 1]);

    % ble_labels_train = data_mat(:, 5:end); % 标签数据
    % 3.KNN分类器
    Mdl = fitcknn(ble_figureprinting_train, ble_labels_train, 'NumNeighbors', n_neigherbors);

    % 4.KNN预测分类
    grid_pos_prediction = predict(Mdl, test_fingerprinting);
    % 5.KNN预测结果处理
    % {"x:1,y:0"}→[1,0]
    grid_pos_prediction = grid_pos_prediction{1};
    temp = regexp(string(grid_pos_prediction), '-\d|\d', 'match');
    % [x,y]
    grid_pos_prediction = [str2double(temp(1)), str2double(temp(2))];
end
