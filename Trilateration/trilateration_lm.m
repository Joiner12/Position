function [est_pos_lm, procss] = trilateration_lm(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %       列文伯格-马夸特法(Levenberg–Marquardt)
    % 定义:
    %       [est_pos_lm, procss] = trilateration_lm(x_tr, y_tr, d_tr, varargin)
    % 参数:
    %       x_tr,x轴坐标;
    %       y_tr,y轴坐标;
    %       d_tr,距离;
    %       varargin,保留参数;
    % 输出:
    %       est_pos_lm,定位结果(x,y);
    %       procss,定位过程;

    X = reshape(x_tr, [length(x_tr), 1]);
    Y = reshape(y_tr, [length(y_tr), 1]);
    D = reshape(d_tr, [length(d_tr), 1]);
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
    % 循环过程
    procss = cell(0);
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
        procss{loop_cnt} = x0;
        x0 = x1;
    end

    est_pos_lm = x1;
end
