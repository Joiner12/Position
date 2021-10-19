function distance = calc_distance_based_on_rssi(ap, varargin)
    % ����:
    %       ����AP��Ϣ��ѯ���ģ�ͻ�ȡRSSI��Ӧ�ľ�����Ϣ
    % ����:
    %       distance = calc_distance_based_on_rssi(ap,rssi,varargin)
    % ����:
    %       ap:ap���ݣ����ݸ���ap���ݵ�rssi�����Ӧ�ľ���
    %       varargin:��������

    %% ����������ݽ��
    %{
    struct{
        char name[];
        double param_less_rssi[2]; // piecewise < const double A
        double param_more_rssi[2]; // piecewise >= const double A
        double piecewise_rssi; //
        }
    %}

    %% ƫ����Ͻ��
    env_factor = -16;
    ope_0 = struct('Name', 'ope_0', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_1 = struct('Name', 'ope_1', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_2 = struct('Name', 'ope_2', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_3 = struct('Name', 'ope_3', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_4 = struct('Name', 'ope_4', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_5 = struct('Name', 'ope_5', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_6 = struct('Name', 'ope_6', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_7 = struct('Name', 'ope_7', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_8 = struct('Name', 'ope_8', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    ope_9 = struct('Name', 'ope_9', 'A', -19.91 + env_factor, ...
        'n', 3.363);
    env_factor = -1;
    Beacon1 = struct('Name', 'Beacon1', 'A', -37.08 + env_factor, ...
        'n', 2.8);
    Beacon2 = struct('Name', 'Beacon2', 'A', -37.08 + env_factor, ...
        'n', 2.8);
    Beacon3 = struct('Name', 'Beacon3', 'A', -37.08 + env_factor, ...
        'n', 2.8);
    Beacon4 = struct('Name', 'Beacon4', 'A', -37.08 + env_factor, ...
        'n', 2.8);
    Beacon5 = struct('Name', 'Beacon5', 'A', -37.08 + env_factor, ...
        'n', 2.8);
    ap_params = {ope_0, ope_1, ope_2, ope_3, ope_4, ...
                ope_5, ope_6, ope_7, ope_8, ope_9, Beacon1, ...
                Beacon2, Beacon3, Beacon4, Beacon5};

    % ģ��ѡ��
    model_mode = {'piecewise_logarithmic', 'ordinary_logarithmic', 'quadratic_polynomial'};

    switch model_mode{2}

        case 'ordinary_logarithmic' % һ�����ģ��

            for i = 1:1:length(ap_params)
                A = -19.91; % default value
                n = 3.363;
                ap_temp = ap_params{i};

                if strcmp(ap.name, ap_temp.Name)
                    A = ap_temp.A; % default value
                    n = ap_temp.n;
                    break;
                end

            end

            dist = rssi_to_distance_logarithmic(A, n, ap.rssi);
            dist_clustering = -1;

            if ~isempty(ap.rssi_clustering) && any(ap.rssi_clustering ~= 0)
                dist_clustering = calc_distance_based_on_rssi_clustering(ap.rssi_clustering);
            end

            if ~isequal(dist_clustering, -1) && false
                dist = dist_clustering * 0.5 + dist * 0.5;
            end

            % fprintf('distance calc,logar:%.2f,clustering:%.2f\n', dist, dist_clustering);
        case 'piecewise_logarithmic' % �ֶζ���ģ��
            % ���
            % dist = rssi_to_distance_piecewise_logarithmic(...
            %     cur_param.param_less_rssi, cur_param.param_more_rssi, ...
            %     ap_rssi, cur_param.piecewise_rssi);
        case 'quadratic_polynomial' % ����ʽģ��
            % ��ͬ����ʽ�µĶ��������[a,b,c]
            param_poly = [0.02856, 2.224, 48.38]; % param_mean_mean
            dev_factor = 7; % ��������dBm
            dist = rssi_to_distance_quadratic_polynomial(param_poly(1), ...
                param_poly(2), ...
                param_poly(3), ap_rssi + dev_factor);
    end

    distance = dist;
end
