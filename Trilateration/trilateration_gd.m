function [est_pos_gd, procss] = trilateration_gd(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %       批量梯度下降法(batch gradient descent)
    % 定义:
    %       [est_pos_gd, procss] = trilateration_gd(x_tr, y_tr, d_tr, varargin)
    % 参数:
    %       x_tr,x轴坐标;
    %       y_tr,y轴坐标;
    %       d_tr,距离;
    %       varargin,保留参数;
    % 输出:
    %       est_pos_gd,定位结果(x,y);
    %       procss,定位过程;

    X = reshape(x_tr, [length(x_tr), 1]);
    Y = reshape(y_tr, [length(y_tr), 1]);
    D = reshape(d_tr, [length(d_tr), 1]);
    % 权系数
    w = [1, 1, 1];
    % 步长
    alpha = 0.1;
    % 偏导函数
    rx1 = @(x, y)w(1) * (x - X(1) - D(1) * (x - X(1)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
    rx2 = @(x, y)w(2) * (x - X(2) - D(2) * (x - X(2)) / sqrt((X(2) - x)^2 + (Y(2) - y)^2));
    rx3 = @(x, y)w(3) * (x - X(3) - D(3) * (x - X(3)) / sqrt((X(3) - x)^2 + (Y(3) - y)^2));
    ry1 = @(x, y)w(1) * (y - Y(1) - D(1) * (y - Y(1)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
    ry2 = @(x, y)w(2) * (y - Y(2) - D(2) * (y - Y(2)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));
    ry3 = @(x, y)w(3) * (y - Y(3) - D(3) * (y - Y(3)) / sqrt((X(1) - x)^2 + (Y(1) - y)^2));

    loop_cnt = 0;
    procss = cell(0);
    % centroid
    Xk = [mean(X), mean(Y)];

    while true
        loop_cnt = loop_cnt + 1;
        % gradient
        g = [rx1(Xk(1), Xk(2)) + rx2(Xk(1), Xk(2)) + rx3(Xk(1), Xk(2)), ...
                ry1(Xk(1), Xk(2)) + ry2(Xk(1), Xk(2)) + ry3(Xk(1), Xk(2))];
        procss{loop_cnt} = Xk;
        Xk = Xk - alpha * g;

        if (norm(g) <= 1e-6) || (loop_cnt > 20000)

            break;
        end

    end

    est_pos_gd = Xk;
end
