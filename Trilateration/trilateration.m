classdef trilateration

    properties (SetAccess = private)
        x_tr = zeros(0);
        y_tr = zeros(0);
        d_tr = zeros(0);
        est_pos = [NaN, NaN];
        est_pos_nlf = est_pos;
        algo_tr = '';
        est_algo = {'GN', 'N', 'GD', 'LM', 'OLS'};
    end

    % 功能：
    %       构造函数
    % 定义：
    %       obj = trilateration(x,y,d,algo)
    % 输入：
    %       obj,类对象(无需显式输入);
    %       x,已知点x坐标(矩阵);
    %       y,已知点y坐标(矩阵);
    %       d,未知点 (x0, y0) 到已知点距离(矩阵);
    %       algo,估计方法(GN,N,GD,LM)
    %       GN=gauss-newton,N=Newton,GD=gradient-descent
    %       LM=Levenberg-Marquardt,OLS = ordinary least squares
    % 输出：
    %       obj,类对象
    methods

        function obj = trilateration(x, y, d, algo)
            % check the paramter is foolish
            obj.x_tr = reshape(x, [length(x), 1]);
            obj.y_tr = reshape(y, [length(x), 1]);
            obj.d_tr = reshape(d, [length(x), 1]);

            if any(strcmpi(obj.est_algo, algo))
                obj.algo_tr = algo;
            end

            disp('constructor')
            % est_algo = {'GN', 'N', 'GD', 'LM'};
            switch obj.algo_tr
                case 'N'

                case 'GN'
                    obj.trilater_gn();
                case 'GD'

                case 'LM'

                case 'OLS'
                    obj.trilater_ols()
                otherwise
                    disp('are u serious?')
            end

        end

    end

    %% 高斯牛顿法(Gauss-Newton)
    methods (Access = public)

        function obj = trilater_gn(obj)
            obj.est_pos = [1, 1];
            disp('gauss newton')
        end

    end

    %% 普通最小二乘ordinary least squares
    methods (Access = public)

        function obj = trilater_ols(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            A = 2 * [X(1) - X(3), Y(1); ...
                    X(2) - X(3), Y(2) - Y(3)];
            b = [X(1).^2 - X(3).^2 + Y(1).^2 - Y(3).^2 + D(3).^2 - D(1).^2; ...
                    X(2).^2 - X(3).^2 + Y(2).^2 - Y(3).^2 + D(3).^2 - D(2).^2];

            est_b = A' * b / (A' * A);
            obj.est_pos = est_b;
        end

    end

    %% 获取定位结果
    methods (Access = public)

        function est_pos = getEstPos(obj)
            est_pos = obj.est_pos;
        end

    end

    %% 加权非线性拟合(matlab inline)
    methods (Access = private)

        function [obj] = nlfit_inline(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            pos_est_xy = trilateration_calc([X, Y], D);
            obj.est_pos_nlf = pos_est_xy;
        end

    end

    %% 获取matlab非线性拟合结果
    methods (Access = public)

        function est_pos_out = getEstPosNlf(obj)
            est_pos_out = obj.est_pos_nlf;
        end

    end

end
