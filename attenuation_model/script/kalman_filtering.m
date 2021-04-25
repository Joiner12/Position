%%
% system
try
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\kalman_filtering.mat');
catch
    %
end

disp('linear system')
F = 1;
B = 1;
H = 1;
Q = .1;
R = 10;
I = eye(size(F));
% recursive procedure
for ap_k = 1:1:4
    rssi_kf = ap_all(ap_k).rssi;
    X_pre = zeros(0);
    P_pre = zeros(0);
    Xkf = zeros(0);
    Z = rssi_kf;
    P = zeros(0);
    X_real = mean(rssi_kf) .* ones(size(rssi_kf));
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

    %误差过程
    if false
        Err_Messure = zeros(0);
        Err_Kalman = zeros(0);

        for k = 1:N
            Err_Messure(k) = Z(k) - X(k);
            Err_Kalman(k) = Xkf(k) - X(k);
        end

    end

    % figure
    t = linspace(1, length(X_real), length(X_real));
    tcf('kalman')
    figure('name', 'kalman');
    plot(t, X_real, '-r', t, Z, 'g+', t, Xkf, '-k');
    legend('真实值', '测量值', 'kalman估计值');
    xlabel('采样元');
    ylabel('rssi_kf');
    title('Kalman Filter Simulation R:100,Q:1');

    pause(0.2);

    filename = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img', ...
        sprintf('kalman-filtering-%s.png', num2str(ap_k)));
    imwrite(frame2im(getframe(gcf)), filename);

end

%% 
pd = fitdist(ap_all(1).rssi,'Normal')
mean(ap_all(1).rssi)
