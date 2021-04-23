function data_f = kalman_filter_f(datain, varargin)
    % ���ܣ�
    %       ����������ݽ���kalman�˲���
    % ���壺
    %       data_f =kalman_filter_f(datain,varargin)
    % ���룺
    %       datain,���˲�����;
    %       varargin,��������;
    % �����
    %       data_f,�˲�������;

    % system parameter
    F = 1;
    B = 1;
    H = 1;
    Q = .1;
    R = 10;
    I = eye(size(F));

    % recursive procedure
    X_pre = zeros(0);
    P_pre = zeros(0);
    Xkf = zeros(0);
    Z = datain;
    P = zeros(0);
    X_real = mean(datain) .* ones(size(datain));
    % X = rand(size(Z) * sqrt(Q));
    for k = 1:1:length(Z)

        if isequal(k, 1)
            X_pre(1) = Z(k);
            P_pre(1) = 0;
            Xkf(1) = Z(k);
            P(1) = 0;
        else
            X_pre(k) = F * Xkf(k - 1);
            P_pre(k) = F * P(k - 1) * F' + Q;
            Kg = P_pre(k) / (H * P_pre(k) * H' + R);
            Xkf(k) = X_pre(k) + Kg * (Z(k) - H * X_pre(k));
            P(k) = (I - Kg * H) * P_pre(k);
        end

    end

    % filtering out
    data_f = Xkf;

    % figure
    if any(strcmpi(varargin, 'figure'))
        t = linspace(1, length(X_real), length(X_real));
        tcf('kalman')
        figure('name', 'kalman');
        plot(t, X_real, '-r', t, Z, 'g+', t, Xkf, '-k');
        legend('��ʵֵ', '����ֵ', 'kalman����ֵ');
        xlabel('����Ԫ');
        ylabel('datain');
        title('Kalman Filter Simulation R:100,Q:1');
    end

end
