function [est_pos_wgn, procss] = trilateration_wgn_s(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %       加权高斯-牛顿(Weighted Gauss-Newton)
    % 定义:
    %       [est_pos_gn, procss] = trilateration_wgn_s(x_tr, y_tr, d_tr, varargin)
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
    % 误差矩阵函数
    Ed = @(x, y, X0, Y0, D0) sqrt((x - X0)^2 + (y - Y0)^2) - D0;
    % 偏导矩阵函数
    Jd = @(x, y, xl, yl) [(x - xl) / (sqrt((x - xl)^2 + (y - yl)^2)), ...
                        (y - yl) / (sqrt((x - xl)^2 + (y - yl)^2))];

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
        % 误差矩阵
        E = zeros([length(X), 1]);

        for k2 = 1:1:length(X)
            E(k2, :) = Ed(x0(1), x0(2), X(k2), Y(k2), D(k2));
        end

        % Jacobian
        J = zeros([length(X), 2]);

        for k1 = 1:1:length(X)
            J(k1, :) = Jd(x0(1), x0(2), X(k1), Y(k1));
        end

        % deltaX = inv(- J' * w * J) * (J' * w * E);
        deltaX = (- J' * w * J) \ (J' * w * E);
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
