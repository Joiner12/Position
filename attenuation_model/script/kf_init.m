function kf_params = kf_init(Px, Py, Vx, Vy, varargin)
    % 功能：
    %       kalman滤波器初始化
    % 定义:
    %       kf_params = kf_init(Px, Py, Vx, Vy)
    % 输入:
    %       Px,初始X轴坐标(m)
    %       Py,...Y..
    %       Vx,初始X轴方向速度(m/s)
    %       Vy,..Y..
    % 输出：
    %       kf_params,kalman参数及迭代过程量
    % 模型定义：
    % X_k = A*X_{k-1} + B*u_{k} + Q
    % Z_k = H*X_k + R

    %%
    kf_params.B = 0; % 输入矩阵
    kf_params.u = 0; % 系统输入
    kf_params.K = NaN; % 卡尔曼增益无需初始化
    kf_params.z = NaN; % 无需初始化，每次使用kf_update之前需要输入观察值z
    kf_params.P = zeros(4, 4); % 初始P设为0

    % 初始状态：使用观察值进行初始化，Vx，Vy初始为0;
    kf_params.x = [Px; Py; Vx; Vy];

    % 状态转移矩阵A
    kf_params.A = eye(4) + diag(ones(1, 2), 2);

    %{
    预测噪声协方差矩阵Q：假设预测过程上叠加一个高斯噪声，协方差矩阵为Q
    大小取决于对预测过程的信任程度。
    比如，假设认为运动目标在y轴上的速度可能不匀速，那么可以把这个对角矩阵的最后一个值调大。
    有时希望出来的轨迹更平滑，可以把这个调更小
    %}
    kf_params.Q = diag(ones(4, 1) * 0.01);

    % 观测矩阵H
    kf_params.H = eye(2, 4);

    % 观测噪声协方差矩阵R：假设观测过程上存在一个高斯噪声，协方差矩阵为R
    kf_params.R = diag(ones(2, 1) * 4); 
end
