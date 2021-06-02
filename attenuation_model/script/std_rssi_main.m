%%
tcf;
figure('Color', 'w');

for i = 1:1:length(noise_data_1)
    aptemp = noise_data_1{1, i};
    rssitemp = aptemp.RSSI;
    plot_py(linspace(1, length(rssitemp), length(rssitemp)), rssitemp)
    hold on
end

xlabel('采样序列');
ylabel('RSSI/dB')
title('蓝牙信号强度相互干扰测试')
legend({'HLK_1', 'HLK_2', 'HLK_3', 'HLK_4'})
%%
clc;
model_log = create_logarithmic_model_fit(dist, hlk_mean_vals_A7, 'piecewise_rssi', -50);

%%
% a =      -41.43  (-43.22, -39.64)
% b =      -1.445  (-1.638, -1.252)
clc;
analysis_fit_model_normal(-25.59, 3.038, HLK_18m_00cmA7, 18);

%%
% -39.29  1.6
% -12 4.282
clc;
a = [-39.29, -12];
b = [1.6 4.282];
analysis_fit_model_piecewise(a(1), b(1), a(2), b(2), -50, HLK_1m_00cmA7, 1)

%%
clc;
tcf('jet');
figure('Name', 'jet', 'Color', 'w')
n = 8;
r = (0:n)' / n;
theta = pi * (-n:n) / n;
X = r * cos(theta);
Y = r * sin(theta);
C = r * cos(2 * theta);
pcolor(X, Y, C)
axis equal tight
% imagesc(xs,ys,data);colormap(jet);clorbar;

colormap(jet);

%%
or_file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\动态-1-fast-m-split.txt';
rssi_A1 = get_rssi_info(or_file, '1');
rssi_A3 = get_rssi_info(or_file, '3');
rssi_A7 = get_rssi_info(or_file, '7');
rssi_A8 = get_rssi_info(or_file, '8');
%%
get_rssi_statistics(rssi_A1, 'showfigure')
get_rssi_statistics(rssi_A3, 'showfigure')
get_rssi_statistics(rssi_A7, 'showfigure')
get_rssi_statistics(rssi_A8, 'showfigure')

%%
clc;
tcf('face');
% clarify filter
windowSize = 100;
b = (1 / windowSize) * ones(1, windowSize);
a = 1;
rssi_A1_f = filter(b, a, rssi_A1);
figure('name', 'face')
plot(rssi_A1)
hold on
plot(rssi_A1_f)
legend({'a', 'f'})

%%
clc;
A = -49.5;
b = 2.2;
envf = 0;
rssi = linspace(-85, -50, 100);
d = 10.^((A - rssi + envf) / 10 / b);
tcf('dodo');
figure('name', 'dodo')
plot(rssi, d)

%%
clc;
dev = 6;
f1 = @(x)0.02354 * x.^2 + 1.677 * x + 29.87;
f2 = @(x)0.02354 * (x + dev).^2 + 1.677 * (x + dev) + 29.87;
f3 = @(x)0.02354 * x.^2 + 1.677 * x + 29.87 - dev;
tcf('dev');
figure('name', 'dev', 'color', 'white');
rssi_x = [-80, -42];
hold on;
fplot(f1, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
fplot(f2, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
fplot(f3, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
legend('up', 'down-x', 'down-y')
title("多项式拟合-引入环境因子(DEV)")
xlabel('rssi/dbm');
ylabel('distance/m')
box on
grid minor

%%
cur_rssi = HLK_0m_75cmA7;
rssi_kf = kalman_filter_rssi(cur_rssi, 4.5, 0);
tcf('kalman');
figure('name', 'kalman', 'color', 'white')
hold on
plot(cur_rssi)
plot(rssi_kf)
plot(ones(size(rssi_kf)) * mean(rssi_kf))

%% 
rssi_kf_std =kalman_cmp(cur_rssi);

%% 
%本例子从百度文库中得到， 稍加注释
% clear
N=length(cur_rssi);%取200个数

% 生成噪声数据 计算噪声方差
w=randn(1,N); %产生一个1×N的行向量，第一个数为0，w为过程噪声（其和后边的v在卡尔曼理论里均为高斯白噪声）
w(1)=0;
Q=var(w); % R、Q分别为过程噪声和测量噪声的协方差(此方程的状态只有一维，方差与协方差相同) 

v=randn(1,N);%测量噪声
R=var(v);

% 计算真实状态
x_true(1)=0;%状态x_true初始值
A=1;%a为状态转移阵，此程序简单起见取1
for k=2:N
    x_true(k)=A*x_true(k-1)+w(k-1);  %系统状态方程，k时刻的状态等于k-1时刻状态乘以状态转移阵加噪声（此处忽略了系统的控制量）
end


% 由真实状态得到测量数据， 测量数据才是能被用来计算的数据， 其他都是不可见的
z = cur_rssi;

% 开始 预测-更新过程

% x_predict: 预测过程得到的x
% x_update:更新过程得到的x
% P_predict:预测过程得到的P
% P_update:更新过程得到的P

%初始化误差 和 初始位置
x_update(1)=x_true(1);%s(1)表示为初始最优化估计
P_update(1)=0;%初始最优化估计协方差

for t=2:N
    %-----1. 预测-----
    %-----1.1 预测状态-----
    x_predict(t) = A*x_update(t-1); %没有控制变量
    %-----1.2 预测误差协方差-----
    P_predict(t)=A*P_update(t-1)*A'+Q;%p1为一步估计的协方差，此式从t-1时刻最优化估计s的协方差得到t-1时刻到t时刻一步估计的协方差

    %-----2. 更新-----
    %-----2.1 计算卡尔曼增益-----
    K(t)=H*P_predict(t) / (H*P_predict(t)*H'+R);%b为卡尔曼增益，其意义表示为状态误差的协方差与量测误差的协方差之比(个人见解)
    %-----2.2 更新状态-----
    x_update(t)=x_predict(t)  +  K(t) * (z(t)-H*x_predict(t));%Y(t)-a*c*s(t-1)称之为新息，是观测值与一步估计得到的观测值之差，此式由上一时刻状态的最优化估计s(t-1)得到当前时刻的最优化估计s(t)
    %-----2.3 更新误差协方差-----
    P_update(t)=P_predict(t) - H*K(t)*P_predict(t);%此式由一步估计的协方差得到此时刻最优化估计的协方差
end

% plot
%作图，红色为卡尔曼滤波，绿色为量测，蓝色为状态
%kalman滤波的作用就是 由绿色的波形得到红色的波形， 使之尽量接近蓝色的真实状态。
t=1:N;
plot(t,x_update,'r',t,z,'g')
legend('kalman','origin')
