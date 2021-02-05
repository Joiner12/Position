function [value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(value_pre,...
                                                                 vel_pre,...
                                                                 scm_pre,...
                                                                 gauge_cur)
%功能：卡尔曼滤波
%定义：[value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(value_pre,...
%                                                              vel_pre,...
%                                                              scm_pre,...
%                                                              gauge_cur)
%参数： 
%    value_pre：上一次卡尔曼滤波的最优状态值对应的值
%    vel_pre：上一次卡尔曼滤波的最优状态值对应的速度
%    scm_pre：上一次卡尔曼滤波的最优状态估计误差自相关矩阵（注意此参数为矩阵不能为细胞）
%    gauge_cur：当前状态测量值
%输出：
%    value_cur：当前卡尔曼滤波的最优状态值对应的值
%    vel_cur：当前卡尔曼滤波的最优状态值对应的速度
%    scm_cur：当前卡尔曼滤波的最优状态估计误差自相关矩阵

    t = 0.1;          %采样周期，单位秒
    f = [1, t; 0, 1]; %(模型)状态转移矩阵
    w = [t^2 / 2; t];   %过程噪声输入矩阵
    c = [1, 0];        %观测矩阵
    q = (1)^2;      %过程噪声自相关矩阵
    r = (0.5)^2;      %观测噪声自相关矩阵

    z = gauge_cur;
    state_pre = [value_pre; vel_pre];

    state_cur = f * state_pre;               %用模型预测当前状态值
    p_cur = f * scm_pre * f' + w * q * w';   %计算预测自相关矩阵
    a = c * p_cur * c' + r;                  %计算新息过程自相关矩阵
    k = p_cur * c'* inv(a);                  %计算卡尔曼增益矩阵
    a = z - c * state_cur;                   %计算新息过程
    state = state_cur + k * a;               %状态估计，用i....1去估计i时刻的值
    scm_cur = (eye(2) - k * c) * p_cur;      %更新状态估计误差自相关矩阵
    value_cur = state(1);
    vel_cur = state(2);
end 