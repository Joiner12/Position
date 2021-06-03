function rssi_kf = kalman_filter_rssi(rssi, Q, R, varargin)
    % 功能:
    %       对rssi进行kalman滤波
    % 定义:
    %       rssi_kf = kalman_filter_rssi(rssi, Q, R, varargin)
    % 输入:
    %       rssi,rssi数组;
    %       Q,过程噪声协方差(矩阵);
    %       R,观测噪声协方差(矩阵);
    %       varargin,扩张参数;
    % 输出:
    %       滤波后的rssi数组;

    % 系统状态矩阵参数
    A = 1; % 状态转移(矩阵)
    B = 0; % 输入(矩阵)
    H = 1; % 观测(矩阵)
    Pk_p = zeros(size(rssi)); % 后验误差协方差
    Uk = zeros(size(rssi)); % 系统输入
    Xk = zeros(size(rssi)); % 最优状态估计值
    K = zeros(size(rssi)); % kalman增益
    Zk = rssi; % 系统观测值

    for j = 1:length(rssi)
        % 首次迭代参数初始化
        if isequal(j, 1)
            Xk(j) = Zk(j);
        else
            xk_ = A * Xk(j - 1) + B * Uk(j); % 系统状态预测值
            pk_ = A * Pk_p(j - 1) * A' + Q; % 预测协方差(矩阵)
            % K(j) = pk_ * H' * inv(H * pk_ * H' + R); % kalman增益
            K(j) = pk_ * H' / (H * pk_ * H' + R); % kalman增益
            Xk(j) = xk_ + K(j) * (Zk(j) - H * xk_); % 最优估计值
            Pk_p(j) = (eye(1) - K(j) * H) * pk_; % 更新后验误差协方差(矩阵)
        end

    end

    rssi_kf = Xk;
    % 绘图
    if any(strcmpi(varargin, 'figure'))
        serial_x = [1:1:length(rssi)];
        tcf('kalman-1');
        figure('name', 'kalman-1', 'color', 'white');
        subplot(2, 1, 1)
        plot(serial_x, Zk, 'LineWidth', 1.5)
        hold on
        plot(serial_x, Xk, 'LineWidth', 1.5)
        legend('原始数据', '滤波数据')
        subplot(2, 1, 2)
        title('kalman gain')
        plot(serial_x, K, 'LineWidth', 1.5)
    end

end
