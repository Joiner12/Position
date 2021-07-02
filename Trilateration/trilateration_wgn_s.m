function [est_pos_wgn, procss] = trilateration_wgn_s(x_tr, y_tr, d_tr, varargin)
    % ����:
    %       ��Ȩ��˹-ţ��(Weighted Gauss-Newton)
    % ����:
    %       [est_pos_gn, procss] = trilateration_wgn_s(x_tr, y_tr, d_tr, varargin)
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
    % ��������
    Ed = @(x, y, X0, Y0, D0) sqrt((x - X0)^2 + (y - Y0)^2) - D0;
    % ƫ��������
    Jd = @(x, y, xl, yl) [(x - xl) / (sqrt((x - xl)^2 + (y - yl)^2)), ...
                        (y - yl) / (sqrt((x - xl)^2 + (y - yl)^2))];

    % ������Ϊ��ʼ������
    x0 = [mean(X), mean(Y)];
    loop_cnt = 0; % ������������
    procss = cell(0);
    % Ȩ��ϵ��
    if true
        w = (D').^2;
    else
        w = (D').^2 ./ norm(D);
    end

    w = diag(w);

    while true
        % ������
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
