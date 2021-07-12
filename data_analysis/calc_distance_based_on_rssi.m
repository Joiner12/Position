function distance = calc_distance_based_on_rssi(ap, varargin)
    % 功能:
    %       根据AP信息查询拟合模型获取RSSI对应的距离信息
    % 定义:
    %       distance = calc_distance_based_on_rssi(ap,rssi,varargin)
    % 输入:
    %       ap:ap数据，依据各个ap数据的rssi计算对应的距离
    %       varargin:保留参数

    %% 先验拟合数据结果
    %{
    struct{
        char name[];
        double param_less_rssi[2]; // piecewise < const double A
        double param_more_rssi[2]; // piecewise >= const double A
        double piecewise_rssi; //
        }
    %}

    %% 偏置拟合结果
    env_factor = -2.5;
    ope_1 = struct('Name', 'ope_1', 'A', -19.91 + 2, ...
        'n', 3.363);
    ope_2 = struct('Name', 'ope_2', 'A', -19.91 - 3.5, ...
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

    ap_params = {ope_1, ope_2, ope_3, ope_4, ...
                ope_5, ope_6, ope_7, ope_8};

    % 模型选择
    model_mode = {'piecewise_logarithmic', 'ordinary_logarithmic', 'quadratic_polynomial'};

    switch model_mode{2}

        case 'ordinary_logarithmic' % 一般对数模型

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
        case 'piecewise_logarithmic' % 分段对数模型
            % 查表
            % dist = rssi_to_distance_piecewise_logarithmic(...
            %     cur_param.param_less_rssi, cur_param.param_more_rssi, ...
            %     ap_rssi, cur_param.piecewise_rssi);
        case 'quadratic_polynomial' % 多项式模型
            % 不同处理方式下的二次项参数[a,b,c]
            param_poly = [0.02856, 2.224, 48.38]; % param_mean_mean
            dev_factor = 7; % 环境因子dBm
            dist = rssi_to_distance_quadratic_polynomial(param_poly(1), ...
                param_poly(2), ...
                param_poly(3), ap_rssi + dev_factor);
    end

    distance = dist;
end
