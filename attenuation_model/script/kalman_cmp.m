function rssi_kf = kalman_cmp(rssi)
    N = length(rssi); %取200个数
    w = randn(1, N);
    % R、Q分别为过程噪声和测量噪声的协方差
    % (此方程的状态只有一维，方差与协方差相同)
    Q = var(w);
    R = var(rssi);

    %% 计算真实状态
    x_true = mean(rssi) * ones(size(rssi));
    A = 1; % a为状态转移阵，此程序简单起见取1

    %% 由真实状态得到测量数据， 测量数据才是能被用来计算的数据， 其他都是不可见的
    H = 1;
    z = rssi; %量测方差，c为量测矩阵，同a简化取为一个数

    %% 预测-更新过程

    % x_predict: 预测过程得到的x
    % x_update:更新过程得到的x
    % P_predict:预测过程得到的P
    % P_update:更新过程得到的P

    %初始化误差 和 初始位置
    x_update(1) = x_true(1); %s(1)表示为初始最优化估计
    P_update(1) = 0; %初始最优化估计协方差
    for t = 2:N

        x_predict(t) = A * x_update(t - 1); %没有控制变量

        P_predict(t) = A * P_update(t - 1) * A' + Q;

        k(t) = H * P_predict(t) / (H * P_predict(t) * H' + R);
        % b为卡尔曼增益，其意义表示为状态误差的协方差与量测误差的协方差之比(个人见解)

        x_update(t) = x_predict(t) + K(t) * (z(t) - H * x_predict(t));

        P_update(t) = P_predict(t) - H * K(t) * P_predict(t);
    end

    rssi_kf = x_update;


end
