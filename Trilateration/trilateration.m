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
    %       GN:gauss-newton,N:Newton,GD:gradient-descent
    %       LM:Levenberg-Marquardt,OLS:ordinary least squares
    %       WLS:Weight Least Squares
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

    %% 普通最小二乘ordinary least squares
    methods (Access = public)

        function est_pos_ols = trilater_ols(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            A = 2 * [X(1) - X(3), Y(1); ...
                    X(2) - X(3), Y(2) - Y(3)];
            b = [X(1).^2 - X(3).^2 + Y(1).^2 - Y(3).^2 + D(3).^2 - D(1).^2; ...
                    X(2).^2 - X(3).^2 + Y(2).^2 - Y(3).^2 + D(3).^2 - D(2).^2];

            est_b = inv(A' * A) * A' * b;
            est_pos_ols = est_b;
        end

    end

    %% 加权非线性拟合(matlab inline)
    methods (Access = public)

        function est_pos_nlf = nlfit_inline(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            pos_est_xy = trilateration_calc([X, Y], D);
            est_pos_nlf = pos_est_xy;
        end

    end

    %% 加权最小二乘拟合(weighted least squares)

    methods (Access = public)

        function est_pos_wls = trilater_wls(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;

            est_pos_wls = [0, 0];
        end

    end

    %% 高斯牛顿法(Gauss-Newton)
    methods (Access = public)

        function est_pos_gn = trilater_gn(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            % r等式
            r1 = @(x, y) sqrt((x - X(1))^2 + (y - Y(1))^2) - D(1);
            r2 = @(x, y) sqrt((x - X(2))^2 + (y - Y(2))^2) - D(2);
            r3 = @(x, y) sqrt((x - X(3))^2 + (y - Y(3))^2) - D(3);
            % Hessian 矩阵
            Dr = @(x) [(x(1) - X(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2)), ...
                        (x(2) - Y(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2));
                    (x(1) - X(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2)), ...
                        (x(2) - Y(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2));
                    (x(1) - X(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2)), ...
                        (x(2) - Y(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2))];
            % Jocabian 矩阵
            r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
            % 质心作为初始搜索点
            x0 = [mean(X), mean(Y)];
            loop_cnt = 0; % 限制搜索次数

            while true
                A = Dr(x0);
                v0 = (A' * A) \ (- A' * r(x0));
                x1 = x0 + v0';
                loop_cnt = loop_cnt + 1;

                if norm(x1 - x0) < 1e-6 || loop_cnt > 200
                    break;
                end

                x0 = x1;
            end

            est_pos_gn = x1;
        end

    end

    %% 列文伯格-马夸特法(Levenberg–Marquardt)

    methods (Access = public)

        function est_pos_lm = trilater_lm(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            % r等式
            r1 = @(x, y) sqrt((x - X(1))^2 + (y - Y(1))^2) - D(1);
            r2 = @(x, y) sqrt((x - X(2))^2 + (y - Y(2))^2) - D(2);
            r3 = @(x, y) sqrt((x - X(3))^2 + (y - Y(3))^2) - D(3);
            % Hessian 矩阵
            Dr = @(x) [(x(1) - X(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2)), (x(2) - Y(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2));
                    (x(1) - X(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2)), (x(2) - Y(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2));
                    (x(1) - X(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2)), (x(2) - Y(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2))];
            % Jocabian 矩阵
            r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
            % 质心作为初始搜索点
            x0 = [mean(X), mean(Y)];
            loop_cnt = 0; % 限制搜索次数
            lmd = 0.1; %步长

            while true
                loop_cnt = loop_cnt + 1;
                A = Dr(x0);
                M_A = A' * A + lmd .* diag(diag(A' * A));
                M_b = -A' * r(x0);
                v0 = M_A \ M_b;
                x1 = x0 + v0';
                % if norm(x1 - x0) < 1e-5 || loop_cnt > 200
                if norm(x1 - x0) < 1e-4
                    break;
                end

                x0 = x1;
            end

            est_pos_lm = x1;
        end

    end

    %% 批量梯度下降法(batch gradient descent)
    methods (Access = public)

        function est_pos_gd = trilater_gd(obj)
            X = obj.x_tr;
            Y = obj.y_tr;
            D = obj.d_tr;
            % 权系数
            w = [1, 1, 1];
            % 步长
            alpha = 0.01;
            % 偏导函数
            rx1 = @(x, y)w(1) * (x - X(1) - D(1) * (x - X(1)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
            rx2 = @(x, y)w(2) * (x - X(2) - D(2) * (x - X(2)) / sqrt((X(2) - x)^2 + (Y(2) - y)^2));
            rx3 = @(x, y)w(3) * (x - X(3) - D(3) * (x - X(3)) / sqrt((X(3) - x)^2 + (Y(3) - y)^2));
            ry1 = @(x, y)w(1) * (y - Y(1) - D(1) * (y - Y(1)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
            ry2 = @(x, y)w(2) * (y - Y(2) - D(2) * (y - Y(2)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
            ry3 = @(x, y)w(3) * (y - Y(3) - D(3) * (y - Y(3)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));

            loop_cnt = 0;
            % centroid
            Xk = [mean(X), mean(Y)];

            while true

                % gradient
                g = [rx1(Xk(1), Xk(2)) + rx2(Xk(1), Xk(2)) + rx3(Xk(1), Xk(2)), ...
                        ry1(Xk(1), Xk(2)) + ry2(Xk(1), Xk(2)) + ry3(Xk(1), Xk(2))];

                Xk = Xk - alpha * g;
                loop_cnt = loop_cnt + 1;

                if (norm(g) <= 1e-4) || (loop_cnt > 200)

                    break;
                end

            end

            est_pos_gd = Xk;
        end

    end

end
