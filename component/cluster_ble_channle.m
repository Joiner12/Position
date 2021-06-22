function rssi_channle = cluster_ble_channle(rssi, varargin)
    % 函数:
    %       使用k-means算法对蓝牙RSSI进行信道聚类。
    % 定义:
    %       rssi_channle = clsuter_ble_channle(rssi, varargin)
    % 输入:
    %       rssi,rssi值;
    %       varargin,可变参数(key:value);
    %       'K',簇数量(默认为3);
    %       'dist',距离度量,默认为(1,Manhattan distance).2,Euclidean distance;3,Chebyshev distance.
    %       'Replicate',迭代次数(默认5次)
    % 输出:
    %       rssi_channle,[rssi,channle];

    len_rssi = length(rssi);
    calc_rssi = reshape(rssi, [len_rssi, 1]);
    % calc_rssi = [calc_rssi, calc_rssi];
    rssi_channle = [calc_rssi, zeros([len_rssi, 1])];
    % 簇
    if any(strcmpi(varargin, 'k'))
        k = varargin{find(strcmpi(varargin, 'k') + 1)};
    else
        k = 3;
    end

    % 距离度量
    if any(strcmpi(varargin, 'dist'))
        distance_measure = varargin{strcmpi(varargin, 'dist') + 1};
    else
        distance_measure = 1;
    end

    % 迭代次数
    if any(strcmpi(varargin, 'Replicate'))
        replicate = varargin{find(strcmpi(varargin, 'Replicate') + 1)};
    else
        replicate = 5;
    end

    % k-means
    rng default; %
    centorid_cur = calc_rssi(randi(len_rssi, k, 1), :);
    centorid_pre = centorid_cur;
    C = cell(k, 1);

    for i_1 = 1:replicate

        for i_2 = 1:len_rssi
            cur_point = calc_rssi(i_2, :);

            if isequal(distance_measure, 1) %  Manhattan distance
                opt = 'cityblock';
            elseif isequal(distance_measure, 2) % Euclidean distance
                opt = 'euclidean';
            else % Chebyshev distance
                opt = 'chebychev';
            end

            A_dist = dist_measure(cur_point, centorid_cur, k, opt);
            c_i = find(A_dist == min(A_dist), 1);
            rssi_channle(i_2, end) = c_i;
            C{c_i} = [C{c_i},cur_point];
            % C{length(C{c_i, :}) + 1} = cur_point;
        end

        for i_3 = 1:k
            centorid_cur(i_3, :) = mean(C{i_3, :});
        end

        if centorid_pre == centorid_cur
            break;
        end

        centorid_pre = centorid_cur;
    end

end

%% minkovsic distance
%{
A, b的数据维度必须一致
%}
function A_dist = dist_measure(A, b, b_len, opt)

    if strcmpi(opt, 'cityblock')
        A_dist = abs(A - b);
    elseif strcmpi(opt, 'euclidean')
        A_dist = norm(A - b);
    else
        % A_dist = abs(A - b(k, :));
    end

end
