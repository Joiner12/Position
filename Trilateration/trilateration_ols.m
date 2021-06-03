function [est_pos_ols, procss] = trilateration_ols(x_tr, y_tr, d_tr, varargin)
    % ����:
    %      ��ͨ��С����ordinary least squares
    % ����:
    %       [est_pos_ols, procss] = trilateration_ols(x_tr, y_tr, d_tr, varargin)
    % ����:
    %       x_tr,x������;
    %       y_tr,y������;
    %       d_tr,����;
    %       varargin,��������;
    % ���:
    %       est_pos_lm,��λ���(x,y);
    %       procss,��λ����;

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
