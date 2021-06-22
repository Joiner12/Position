function rssi_channle = cluster_ble_channle(rssi, varargin)
    % ����:
    %       ʹ��k-means�㷨������RSSI�����ŵ����ࡣ
    % ����:
    %       rssi_channle = clsuter_ble_channle(rssi, varargin)
    % ����:
    %       rssi,rssiֵ;
    %       varargin,�ɱ����(key:value);
    %       'K',������(Ĭ��Ϊ3);
    %       'dist',�������,Ĭ��Ϊ(1,Manhattan distance).2,Euclidean distance;3,Chebyshev distance.
    %       'Replicate',��������(Ĭ��5��)
    % ���:
    %       rssi_channle,[rssi,channle];

    len_rssi = length(rssi);
    calc_rssi = reshape(rssi, [len_rssi, 1]);
    % calc_rssi = [calc_rssi, calc_rssi];
    rssi_channle = [calc_rssi, zeros([len_rssi, 1])];
    % ��
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
A, b������ά�ȱ���һ��
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
