function grid_pos_prediction = ble_knn_classify(test_fingerprinting, n_neigherbors, varargin)
    % ����ָ��ƥ�亯��
    % ˵��:
    %   1.����ָ���������ݼ���Ӧ����������洢�ڱ���,
    %   ����KNN�����ʱ��,���ص��ڴ���.
    %   2.����ָ��ƥ��ؼ�����Ԥ��ѵ���ã��ؼ���������:
    %   ��һ���������ھ�����.
    % ����:
    %   test_fingerprinting:��ƥ������ָ������
    %   n_neigherbors:kֵ
    % ���:
    %   grid_pos_prediction:KNN�������������
    %%
    % 1.����Ԥ�ȴ���õ��������ݺͱ�ǩ
    % ���ݸ�ʽ˵��:
    % ble_data_base_least.mat�����ݸ�ʽ:
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

    % ble_labels_train = data_mat(:, 5:end); % ��ǩ����
    if true
        %% Kd-tree�������ࡪ��ʾ����
        % 3.Kd-Tree����
        Mdl = KDTreeSearcher(ble_figureprinting_train);

        % 4.knnsearchԤ�����
        [n, d] = knnsearch(Mdl, test_fingerprinting, 'k', n_neigherbors);

        % 5.KNNԤ����������k���ھӵ�ƽ��ֵ��ΪԤ��
        % tabulate(ble_labels_train(n))
        prediction_pos = cell(n_neigherbors, 1);

        for j = 1:n_neigherbors
            label_temp = ble_labels_train(n(j));
            array_temp = str2array(label_temp);
            prediction_pos{j} = array_temp;
        end

        prediction_pos = cell2mat(prediction_pos);

        % [x,y]
        if ~isequal(size(prediction_pos, 1), 1)
            grid_pos_prediction = mean(prediction_pos);
        else
            grid_pos_prediction = prediction_pos;
        end

        % 6.���������ӻ�
        if false

            tcf('kd-tree-search');
            figure('name', 'kd-tree-search', 'color', 'w');
            hold on
            % base
            scatter(data_mat(:, 5), data_mat(:, 6), 'filled');
            % k����
            line(prediction_pos(:, 1), prediction_pos(:, 2), 'color', 'g', 'marker', 'o', ...
            'linestyle', 'none', 'markersize', 10);
            % Ԥ����
            line(grid_pos_prediction(:, 1), grid_pos_prediction(:, 2), 'color', 'r', 'marker', 's', ...
            'linestyle', 'none', 'markersize', 10);
            % ��ʵλ��
            if false
                true_pos = prediction_pos(1, :);
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
        %% ʹ��ClassificationKNN����������ʽ
        % 3.KNN������
        Mdl = fitcknn(ble_figureprinting_train, ble_labels_train, 'NumNeighbors', n_neigherbors);

        % 4.KNNԤ�����
        grid_pos_prediction = predict(Mdl, test_fingerprinting);
        % 5.KNNԤ��������
        % {"x:1,y:0"}��[1,0]
        grid_pos_prediction = str2array(grid_pos_prediction{1})
    end

end

%% ʹ��������ʽ���ַ�������ȡ����
% ����{"x:1,y:0"}��[1,0]
function array_str = str2array(str_in, varargin)
    temp = regexp(string(str_in), '-\d|\d', 'match');
    % [x,y]
    array_str = [str2double(temp(1)), str2double(temp(2))];
end
