function [pos_est, lam] = trilateration_calc(cur_ap, varargin)
    % ���ܣ�
    %       ���߶�λ����
    % ���壺
    %       [pos_est, lam] = trilateration_calc(cur_ap)
    % ����:
    %       cur_ap:�������Ϣ([struct,struct,struct])
    %       name                 mac                  lat       lon       recv_rssi      rssi_reference    rssi     rssi_kf     dist
    %       ______________    ___________________    ______    ______    ____________    ______________    _____    _______    ______

    %       'onepos_HLK_2'    'e1:04:00:3c:d6:40'    30.548    104.06    [       -61]       -50.068          -61       -61     16.012
    %       'onepos_HLK_6'    'c2:04:00:3c:d6:40'    30.548    104.06    [       -71]       -50.068          -71       -71     16.089
    %       'onepos_HLK_4'    '1c:06:00:3c:d6:40'    30.548    104.06    [1��2 double]       -50.068        -60.5     -60.5     12.929
    %       'onepos_HLK_1'    'a0:04:00:3c:d6:40'    30.548    104.06    [       -74]       -50.068          -74       -74      59.25
    %       varargin(key:value),��������
    % ���:
    %       pos_est:����λ��struct('lat',value,'lon','value','X',value,'y',value)
    %       lam:ʱ��

    ap_num = length(cur_ap); % ��������
    centroid = zeros(1, 2);
    lat = zeros(ap_num, 1);
    lon = zeros(ap_num, 1);
    X = zeros(ap_num, 1);
    Y = zeros(ap_num, 1);
    D = zeros(ap_num, 1);
    pos_est = struct();
    lam = 0;

    for i = 1:ap_num
        lat(i) = cur_ap(i).lat;
        lon(i) = cur_ap(i).lon;
        [X(i), Y(i), lam] = latlon_to_xy(lat(i), lon(i));
        D(i) = cur_ap(i).dist;
    end

    %% access point
    if ap_num <= 2 %�������Ϣ�������������Ϊ��λ�á�
        pos_est_xy = [NaN, NaN];
    else
        X = reshape(X, [length(X), 1]);
        Y = reshape(Y, [length(Y), 1]);
        % �����㷨
        algos = {'Gauss_Newton', 'Weighted_Gauss_Newton', ...
                'Original_Least_Squares', 'Levenberg_Marquardt', ...
                'Batch_Gradient_Descent', 'Fitnlm'};
        calc_algo = algos{2};

        switch calc_algo
            case 'Gauss_Newton'
                [pos_est_xy, ~] = trilateration_gn(X, Y, D);

            case 'Weighted_Gauss_Newton'
                % ���ֲ�ͬ�ļ�Ȩ��˹ţ��ʵ�ַ�ʽ
                [pos_est_xy, ~] = trilateration_wgn_m(X, Y, D);
                % [pos_est_xy, ~] = trilateration_wgn(X, Y, D); % ����Ϊ��������ж�λ

            case 'Original_Least_Squares'
                [pos_est_xy, ~] = trilateration_ols(X, Y, D);

            case 'Levenberg_Marquardt'
                [pos_est_xy, ~] = trilateration_lm(X, Y, D);

            case 'Batch_Gradient_Descent'
                [pos_est_xy, ~] = trilateration_gd(X, Y, D);

            case 'Fitnlm'
                [pos_est_xy] = trilateration_fitnlm(X, Y, D);

            otherwise
                error("no such algorithm selection")

        end

    end

    %% xyתlatitude longitude
    [pos_est.lat, pos_est.lon] = xy_to_latlon(pos_est_xy(1), pos_est_xy(2), lam);
    pos_est.x = pos_est_xy(1);
    pos_est.y = pos_est_xy(2);
end
