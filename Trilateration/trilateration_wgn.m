function [est_pos_wgn, procss] = trilateration_wgn(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %       加权高斯-牛顿(Weighted Gauss-Newton)
    % 定义:
    %       [est_pos_gn, procss] = trilateration_gn(x_tr, y_tr, d_tr, varargin)
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
    % 误差函数
    r1 = @(x, y) sqrt((x - X(1))^2 + (y - Y(1))^2) - D(1);
    r2 = @(x, y) sqrt((x - X(2))^2 + (y - Y(2))^2) - D(2);
    r3 = @(x, y) sqrt((x - X(3))^2 + (y - Y(3))^2) - D(3);
    % Jacobian
    Dr = @(x) [(x(1) - X(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2)), ...
                (x(2) - Y(1)) / (sqrt((x(1) - X(1))^2 + (x(2) - Y(1))^2));
            (x(1) - X(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2)), ...
                (x(2) - Y(2)) / (sqrt((x(1) - X(2))^2 + (x(2) - Y(2))^2));
            (x(1) - X(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2)), ...
                (x(2) - Y(3)) / (sqrt((x(1) - X(3))^2 + (x(2) - Y(3))^2))];
    % 误差矩阵
    r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
    % 质心作为初始搜索点
    x0 = [mean(X), mean(Y)];
    loop_cnt = 0; % 限制搜索次数
    procss = cell(0);
    % 权重系数
    if true
        w = (D').^2;
    else
        w = (D').^2 ./ norm(D);
    end

    w = diag(w);

    while true
        A = Dr(x0);
        % deltaX = -1 * inv(A' * w * A) * A' * w * r(x0);
        % deltaX = (A' * w * A) \ (- A' * w * r(x0));
        %{
        error:矩阵接近奇异值，或者缩放错误。结果可能不准确 ...
            使用M - P广义逆的方法解决;
        %}
        deltaX = pinv(- A' * w * A) * (A' * w * r(x0));
        x1 = x0 + deltaX';
        loop_cnt = loop_cnt + 1;

        if norm(deltaX) < 1e-4 || loop_cnt > 200
            break;
        end

        procss{loop_cnt} = x0;
        x0 = x1;
    end

    est_pos_wgn = x1;
end
