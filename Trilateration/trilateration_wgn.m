function [est_pos_wgn, procss] = trilateration_wgn(x_tr, y_tr, d_tr, varargin)
    % ����:
    %       ��Ȩ��˹-ţ��(Weighted Gauss-Newton)
    % ����:
    %       [est_pos_gn, procss] = trilateration_gn(x_tr, y_tr, d_tr, varargin)
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
    % ����
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
    % ������
    r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
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
        A = Dr(x0);
        % deltaX = -1 * inv(A' * w * A) * A' * w * r(x0);
        % deltaX = (A' * w * A) \ (- A' * w * r(x0));
        %{
        error:����ӽ�����ֵ���������Ŵ��󡣽�����ܲ�׼ȷ ...
            ʹ��M - P������ķ������;
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
