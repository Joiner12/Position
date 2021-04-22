%%
%{
https: // blog.csdn.net / qq_17119267 / article / details / 103441461
https: // blog.csdn.net / qq_43499622 / article / details / 103055593
%}

%kalman滤波器
clc %清除
N = 200; %数据个数N
w(1) = 0; %w为预测模型的过程噪声
w = randn(1, N) %randn()创建随机矩阵，服从正态分布
x(1) = 0; %初始值
f = 1; %a为方程1中的状态转移矩阵，这里为一维变量

%x的预测值
for k = 2:N;
    x(k) = f * x(k - 1) + w(k - 1); %方程1，为x的推测值
end

%观察不确定性
V = randn(1, N); %V为观察噪声，randn()创建随机矩阵，服从正态分布
q1 = std(V); %返回一个包含与每列对应的标准差的行向量
R = q1.^2; % R 来表示观测中的不确定性（协方差矩阵）

%实际观察值Y
H = 0.4; %H为方程中H(k)
y = H * x + V; %Y为实际观察值

%预测不确定性
q2 = std(w); %返回一个包含与每列对应的标准差的行向量，预测模型
Q = q2.^2; % Q 预测模型本身的噪声（协方差矩阵）

%x的修正值（经卡尔曼滤波的值）
p(1) = 0; %协方差矩阵 Σ初值，代表一个时刻的不确定性
s(1) = 0; %修正值初值

for t = 2:N;
    p1(t) = f.^2 * p(t - 1) + Q; %方程2，p1(t)协方差矩阵 Σ-，由上一状态推测而来
    k(t) = H * p1(t) / (H.^2 * p1(t) + R); %方程3 ，k(t)为卡尔曼系数
    s(t) = f * s(t - 1) + k(t) * (y(t) - f * H * s(t - 1)); %方程4，根据估计值进行修正
    p(t) = p1(t) - H * k(t) * p1(t); %方程5，p(t)为协方差矩阵 Σ，对最优值的噪声分布进行更新
end

%画曲线图
t = 1:N;
plot(t, s, 'r', t, y, 'g', t, x, 'b');
%红色曲线：x的修正值
%绿色曲线，x的实际观察值
%蓝色曲线，x的预测值

%%

%初始化参数
N = 120; %采样点个数
A = 1;
B = 1;
H = 1;
Q = 0.01;
R = 0.25;
W = sqrt(Q) * randn(1, N);
V = sqrt(R) * randn(1, N);
CON = 25; %温度真实值
%分配空间
X = zeros(1, N);
Z = zeros(1, N);
Xkf = zeros(1, N);
P = zeros(1, N);
X(1) = 25.1;
P(1) = 0.01;
Z(1) = 24.9;
Xkf(1) = Z(1);
I = eye(1);

%kalman过程
for k = 2:N
    X(k) = A * X(k - 1) + B * W(k);
    Z(k) = H * X(k) + V(k);
    X_pre(k) = A * Xkf(k - 1);
    P_pre(k) = A * P(k - 1) * A' + Q;
    Kg = P_pre(k) / (H * P_pre(k) * H' + R);
    Xkf(k) = X_pre(k) + Kg * (Z(k) - H * X_pre(k));
    P(k) = (I - Kg * H) * P_pre(k);
end

%误差过程
Err_Messure = zeros(1, N);
Err_Kalman = zeros(1, N);

for k = 1:N
    Err_Messure(k) = Z(k) - X(k);
    Err_Kalman(k) = Xkf(k) - X(k);
end

t = 1:N;
figure;
plot(t, CON * ones(1, N), '-b', t, X, '-r', t, Z, 'g+', t, Xkf, '-k');
legend('期望值', '真实值', '测量值', 'kalman估计值');
xlabel('采样时间');
ylabel('温度');
title('Kalman Filter Simulation');

figure;
plot(t, Err_Messure, '-b', t, Err_Kalman, '-k');
legend('测量误差', 'kalman误差');
xlabel('采样时间');
