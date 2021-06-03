function y_f = kalman_filter_one_dimensional(x_org, varargin)
    % 功能：
    %       一维kalman滤波器，对x进行滤波，输出滤波结果y。
    %       在函数内部进行参数滤波器参数配置。
    %       状态空间表达式：
    %       x[n+1]=Ax[n]+Bu[n]+Bw[n]
    %       y[n]=Cx[n]+v[n]
    % 定义：
    %       y = kalman_filter_one_dimensional(x, varargin)
    % 输入:
    %       x_org,原始数据
    % 输出：
    %       y_f,滤波数据

    % 状态空间参数
    F = 1;
    B = 0;
    H = 1;
    Q = .01; % process noise covariance
    R = 100; % sensor noise covariance
    I = eye(size(F));
    % recursive procedure
    X_pre = zeros(0);
    P_pre = zeros(0);
    y_f = zeros(0);
    Z = x_org;
    P = zeros(0);
    X_real = mean(x_org) .* ones(size(x_org));
    % X = rand(size(Z) * sqrt(Q));
    for k = 1:1:length(Z)

        if isequal(k, 1)
            X_pre(1) = Z(k);
            P_pre(1) = 0;
            y_f(1) = Z(k);
            P(1) = 0;
        else
            X_pre(k) = F * y_f(k - 1);
            P_pre(k) = F * P(k - 1) * F' + Q;
            Kg = P_pre(k) / (H * P_pre(k) * H' + R);
            y_f(k) = X_pre(k) + Kg * (Z(k) - H * X_pre(k));
            P(k) = (I - Kg * H) * P_pre(k);
        end

    end

    %误差过程
    if false
        Err_Messure = zeros(0);
        Err_Kalman = zeros(0);

        for k = 1:N
            Err_Messure(k) = Z(k) - X(k);
            Err_Kalman(k) = y_f(k) - X(k);
        end

    end

    % figure
    t = linspace(1, length(X_real), length(X_real));
    tcf('kalman')
    figure('name', 'kalman');

    plot_1 = plot(t, X_real, t, Z, t, y_f);
    set(plot_1(1), 'Color', 'b');
    set(plot_1(2), 'Color', 'g', 'Marker', '+', 'LineStyle', 'none');
    set(plot_1(3), 'Color', [17, 109, 86] ./ 255);
    legend('均值', '测量值', 'kalman估计值');
    xlabel('采样元');
    ylabel('RSSI/dbm');
    title('Kalman Filter Simulation R:100,Q:.01');

    if false
        filename = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img', ...
            sprintf('kalman-filtering-%s.png', num2str(ap_k)));
        imwrite(frame2im(getframe(gcf)), filename);
    end

    %% simulation system
    %{
    Ts = -1; % 采样时间，-1表示系统默认。
    sys = ss(A, [B B], C, D, Ts, 'InputName', {'u' 'w'}, 'OutputName', 'y');
    Q = 2.3; % process noise covariance Q
    R = 1; % sensor noise covariance R
    [kalmf, L, ~, Mx, Z] = kalman(sys, Q, R);
    kalmf = kalmf(1, :);
    % simulator
    sys.InputName = {'u', 'w'};
    sys.OutputName = {'yt'};
    vIn = sumblk('y=yt+v');

    kalmf.InputName = {'u', 'y'};
    kalmf.OutputName = 'ye';

    SimModel = connect(sys, vIn, kalmf, {'u', 'w', 'v'}, {'yt', 'ye'});
    t = (0:100)';
    u = sin(t / 5);
    rng(10, 'twister');
    w = sqrt(Q) * randn(length(t), 1);
    v = sqrt(R) * randn(length(t), 1);
    out = lsim(SimModel, [u, w, v]);
    yt = out(:, 1); % true response
    ye = out(:, 2); % filtered response
    y = yt + v; % measured response
    clf
    subplot(211), plot(t, yt, 'b', t, ye, 'r--'),
    xlabel('Number of Samples'), ylabel('Output')
    title('Kalman Filter Response')P = B * Q * B'; % Initial error covariance
    x = zeros(3, 1); % Initial condition on the state

    ye = zeros(length(t), 1);
    ycov = zeros(length(t), 1);
    errcov = zeros(length(t), 1);

    for i = 1:length(t)
        % Measurement update
        Mxn = P * C' / (C * P * C' + R);
        x = x + Mxn * (y(i) - C * x); % x[n|n]
        P = (eye(3) - Mxn * C) * P; % P[n|n]

        ye(i) = C * x;
        errcov(i) = C * P * C';

        % Time update
        x = A * x + B * u(i); % x[n+1|n]
        P = A * P * A' + B * Q * B'; % P[n+1|n]
    end

    legend('True', 'Filtered')
    subplot(212), plot(t, yt - y, 'g', t, yt - ye, 'r--'),
    xlabel('Number of Samples'), ylabel('Error')
    legend('True - measured', 'True - filtered')
    %}

end
