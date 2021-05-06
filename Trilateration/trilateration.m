classdef trilateration

    properties (SetAccess = private)
        x_tr = zeros(0);
        y_tr = zeros(0);
        d_tr = zeros(0);
        algo_tr = '';
        est_algo = {'GN', 'N', 'GD', 'LM', 'OLS'};
    end

    properties (SetAccess = public)
        est_pos = struct('x', NaN, 'y', NaN);
        est_pos_nlf = struct('x', NaN, 'y', NaN);
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

        end

    end

    %% 高斯牛顿法(Gauss-Newton)
    methods (Access = public)

        function obj = trilater_gn(obj)
            obj.est_pos.x = 1;
            obj.est_pos.y = 1;
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

            est_b = inv(A' * A) * A' * b;
            obj.est_pos.x = est_b(1);
            obj.est_pos.y = est_b(2);
        end

    end

    %% 梯度下降法(gradient descent)
    methods (Access = public)

        function est_pos = trilater_gd(obj)
            % 偏导函数
            % 权系数
            w = [1, 1, 1];
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            J_x = @(xi, yi, wi) sqrt((x - xi(1))^2 + (y - yi(1))^2) - ri(1);
            J_y = @(x, y) sqrt((x - xi(2))^2 + (y - yi(2))^2) - ri(2);
            r3 = @(x, y) sqrt((x - xi(3))^2 + (y - yi(3))^2) - ri(3);

        end

    end

    %% 加权非线性拟合(matlab inline)
    methods (Access = public)

        function [obj] = nlfit_inline(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            pos_est_xy = trilateration_calc([X, Y], D);
            obj.est_pos_nlf.x = pos_est_xy(1);
            obj.est_pos_nlf.y = pos_est_xy(2);
        end

    end

end
