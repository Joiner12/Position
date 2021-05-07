function [est_pos_ols, procss] = trilateration_ols(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %      普通最小二乘ordinary least squares
    % 定义:
    %       [est_pos_ols, procss] = trilateration_ols(x_tr, y_tr, d_tr, varargin)
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
    A = 2 * [X(1) - X(3), Y(1); ...
            X(2) - X(3), Y(2) - Y(3)];
    b = [X(1).^2 - X(3).^2 + Y(1).^2 - Y(3).^2 + D(3).^2 - D(1).^2; ...
            X(2).^2 - X(3).^2 + Y(2).^2 - Y(3).^2 + D(3).^2 - D(2).^2];

    est_b = inv(A' * A) * A' * b;
    est_pos_ols = est_b;
    procss = 0;
end
