function prediciton_pos = ble_knn_classify(test_fingerprinting, n_neigherbors, ...
        weight_select, varargin)
    % 蓝牙指纹匹配函数
    % 说明:
    %   1.蓝牙指纹特征数据及对应的网格坐标存储在本地,
    %   进行KNN分类的时候,加载到内存中.
    %   2.蓝牙指纹匹配关键参数预先训练好，关键参数包括:
    %   归一化方法、邻居数量.
    % 参数:
    %   test_fingerprinting:待匹配蓝牙指纹数据
    %   n_neigherbors:k值
    %   weight_select:权重系数选项,包括:'uniform'(均值),'gaussian'(高斯),'reverse_distance'(距离倒数)
    % 输出:
    %   prediciton_pos:KNN分类的网格坐标
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
    if true
        %% Kd-tree搜索分类—显示分类
        % 3.Kd-Tree构造
        Mdl = KDTreeSearcher(ble_figureprinting_train);

        % 4.knnsearch预测分类
        [n, d] = knnsearch(Mdl, test_fingerprinting, 'k', n_neigherbors);

        % 5.KNN预测结果处理——k个邻居的平均值作为预测
        % tabulate(ble_labels_train(n))
        neighbor_pos = cell(n_neigherbors, 1);

        for j = 1:n_neigherbors
            label_temp = ble_labels_train(n(j));
            array_temp = str2array(label_temp);
            neighbor_pos{j} = array_temp;
        end

        neighbor_pos = cell2mat(neighbor_pos);

        % 加权
        weights_cof = get_weights(d, weight_select, n_neigherbors);
        weights_cof = reshape(weights_cof, [1, n_neigherbors]);
        % [x,y]
        neighbor_pos_temp = reshape(neighbor_pos, [n_neigherbors, 2]);
        prediciton_pos = weights_cof * neighbor_pos / sum(weights_cof);

        % 6.分类结果可视化
        if false

            tcf('kd-tree-search');
            figure('name', 'kd-tree-search', 'color', 'w');
            hold on
            % base
            scatter(data_mat(:, 5), data_mat(:, 6), 'filled');
            % k近邻
            line(neighbor_pos(:, 1), neighbor_pos(:, 2), 'color', 'g', 'marker', 'o', ...
            'linestyle', 'none', 'markersize', 10);
            % 预测结果
            line(prediciton_pos(:, 1), prediciton_pos(:, 2), 'color', 'r', 'marker', 's', ...
            'linestyle', 'none', 'markersize', 10);
            % 真实位置
            if false
                true_pos = neighbor_pos(1, :);
            else

                if any(strcmpi(varargin, 'truepos'))
                    true_pos = varargin{find(strcmpi(varargin, 'truepos')) + 1};
                end

            end

            line(true_pos(1), true_pos(2), 'color', 'r', 'marker', '^', ...
                'linestyle', 'none', 'markersize', 10);
            legend('base', 'k-neighbors', 'prediction', 'real pos');
            axis equal;

        end

    else
        %% 使用ClassificationKNN分类器—隐式
        % 3.KNN分类器
        Mdl = fitcknn(ble_figureprinting_train, ble_labels_train, 'NumNeighbors', n_neigherbors);

        % 4.KNN预测分类
        prediciton_pos = predict(Mdl, test_fingerprinting);
        % 5.KNN预测结果处理
        % {"x:1,y:0"}→[1,0]
        prediciton_pos = str2array(prediciton_pos{1})
    end

end

%% 使用正则表达式从字符串中提取数组
% 比如{"x:1,y:0"}→[1,0]
function array_str = str2array(str_in, varargin)
    temp = regexp(string(str_in), '-\d|\d', 'match');
    % [x,y]
    array_str = [str2double(temp(1)), str2double(temp(2))];
end

%% 权重函数
function weights_cof = get_weights(dist, weight_select, n_neigherbors, varargin)
    % weights_cof = np.ones([1, n_neigherbors])
    weights_cof = ones(1, n_neigherbors);
    % 相同权重
    if strcmpi(weight_select, 'uniform')
        weights_cof = 1 ./ weights_cof;
    end

    % 高斯权重
    if strcmpi(weight_select, 'gaussian')
        % 高斯函数,a:曲线的高度,b:曲线中心线在x轴的偏移,c:半峰宽度(函数峰值一半处相距的宽度)
        gaussian_f = @(x, a, b, c)(a * exp((-0.5 .* (x - b).^2) / c^2));
        weights_cof = gaussian_f(dist, 1, 0, 4);
    end

    % 距离反比
    if strcmpi(weight_select, 'reverse_distance')
        % 避免/0
        off_side = 0.5;
        weights_cof = 1 ./ (dist + off_side);
    end

end
