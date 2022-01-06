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
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\ble_data_base_least.mat', ...
    'data');
    % 2.����Ԥ����
    % ����cell2matת����֮������ݸ�ʽ:
    % ['Beacon0','Beacon1','Beacon6','Beacon7','POS_X','POS_Y']
    % [-66,-42,-62,-65,0,0]
    data_mat = cell2mat(data);
    ble_figureprinting_train = data_mat(:, 1:4); % ��������
    % todo:�Ż�
    ble_labels_train = repmat('00', 100, 1);

    for k = 1:1:length(data_mat(:, 5:end))
        ble_labels_train(k) = '0';
    end

    % ble_labels_train = data_mat(:, 5:end); % ��ǩ����
    % 3.KNN������
    Mdl = fitcknn(ble_figureprinting_train, ble_labels_train, 'NumNeighbors', n_neigherbors);

    % 4.KNNԤ�����
    grid_pos_prediction = predict(Mdl, test_fingerprinting);
end
