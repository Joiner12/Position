function [rssi_channle, C] = cluster_ble_channle(rssi, varargin)
    % ����:
    %       ʹ��k-means�㷨������RSSI�����ŵ����ࡣ
    % ����:
    %       [rssi_channle, C] = cluster_ble_channle(rssi, varargin)
    % ����:
    %       rssi,rssiֵ;
    %       varargin,�ɱ����(key:value);
    %       'K',������(Ĭ��Ϊ3);
    %       'dist',�������,Ĭ��Ϊ(1,Manhattan distance).2,Euclidean distance;3,Chebyshev distance.
    %       'Replicate',��������(Ĭ��5��)
    % ���:
    %       rssi_channle,[rssi,channle];
    %       C,�������ĵ�

    len_rssi = length(rssi);
    calc_rssi = reshape(rssi, [len_rssi, 1]);
    % calc_rssi = [calc_rssi, calc_rssi];
    % �� todo:����Ӧ��������Ŀ
    if any(strcmpi(varargin, 'k'))
        k = varargin{find(strcmpi(varargin, 'k') + 1)};
    else
        k = 3;
    end

    % �������
    if any(strcmpi(varargin, 'dist'))
        distance_measure = varargin{strcmpi(varargin, 'dist') + 1};
    else
        distance_measure = 1;
    end

    % ��������
    if any(strcmpi(varargin, 'Replicate'))
        replicate = varargin{find(strcmpi(varargin, 'Replicate') + 1)};
    else
        replicate = 5;
    end

    % ��ξ���
    cluster_evl = cell(replicate, 1);

    for k_1 = 1:replicate
        [idx, C, sse] = cluster_k_means(calc_rssi, k, distance_measure);
        cluster_evl{k_1, 1} = idx;
        cluster_evl{k_1, 2} = C;
        cluster_evl{k_1, 3} = sse;
    end

    % ����СSSE��Ϊ�ο�����
    sse_mat = cell2mat(cluster_evl(:, 3));
    min_sse_index = find(sse_mat == min(sse_mat), 1);
    rssi_channle = [calc_rssi, reshape(cluster_evl{min_sse_index, 1}, [len_rssi, 1])];
end

%% minkovsic distance
% A, b������ά�ȱ���һ��
function A_dist = dist_measure(A, b, opt)

    if strcmpi(opt, 'cityblock')
        A_dist = abs(A - b);
    elseif strcmpi(opt, 'euclidean')
        A_dist = norm(A - b);
    else
        A_dist = max(abs(A - b(k, :)));
    end

end

%% k-means Cluster assignment
function [idx, C, sse] = cluster_k_means(X, k, distance_measure)

    if length(X) < k
        error("������С�ڴ�����");
    end

    len_X = length(X);
    % k-means��ʼ����������
    rng('shuffle'); % srand((unsigned int)time(NULL)),��ʱ�����Ϊ���������
    centorid_cur = X(randi(len_X, k, 1), :); % ��ʼ����������(��������)
    centorid_pre = centorid_cur;
    Clusters = cell(k, 1); % �ؼ���
    idx = zeros(0); % �۲���X��Ӧ�Ĵ�����
    sse = 2^63; % sse = sum square error

    for i_2 = 1:len_X
        cur_point = X(i_2, :);

        if isequal(distance_measure, 1) %  Manhattan distance
            opt = 'cityblock';
        elseif isequal(distance_measure, 2) % Euclidean distance
            opt = 'euclidean';
        else % Chebyshev distance
            opt = 'chebychev';
        end

        A_dist = dist_measure(cur_point, centorid_cur, opt);
        c_i = find(A_dist == min(A_dist), 1);
        idx(i_2) = c_i;
        Clusters{c_i} = [Clusters{c_i}, cur_point];
        % Clusters{length(Clusters{c_i, :}) + 1} = cur_point;
    end

    for i_3 = 1:k
        centorid_cur(i_3, :) = mean(Clusters{i_3, :});
    end

    C = centorid_pre;

    if norm(centorid_pre - centorid_cur) <= 1e-4
        % sum square erro
        sse_temp = zeros(0);

        for i_4 = 1:k
            sse_temp(i_4) = vecnorm(Clusters{i_4, :} - centorid_cur, 2, 2);
        end

        sse = sum(sse_temp.^2);
        return;
    end

    centorid_pre = centorid_cur;
end
