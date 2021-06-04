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
dev = 4;
f1 = @(x)0.02856 * x.^2 + 2.224 * x + 43.38;
f2 = @(x)0.02856 * (x + dev).^2 + 2.224 * (x + dev) + 43.38;
f3 = @(x)0.02856 * x.^2 + 2.224 * x + 43.38 - dev;
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
clc;
tcf;
if false
    cur_rssi = HLK_0m_75cmA7;
else
    % beacon2两值波动-1.fig
    open('beacon4两值波动-2.fig')
    % a = gca;
    % cur_rssi = a.Children.YData;
    % cur_rssi = cur_rssi(1:end);
    load('rssi_figure.mat');
    cur_rssi = beacon4_rssi;
end

step_rssi = 0;
step_index = 0;
% 动态特性判断
for k = 1:length(cur_rssi)

    if isequal(mod(k, 500), 0)
        step_index = int32(k / 500);
    end

    cur_rssi(k) = double(step_index) * step_rssi + cur_rssi(k);
end

R = var(cur_rssi)

rssi_g = cur_rssi;

for k = 5:length(cur_rssi)
    rssi_g(k) = like_gaussian_filter(cur_rssi(1:k), 2, 'mean');
end

rssi_kf = kalman_filter_rssi(cur_rssi, 0.01, R);
rssi_gk = kalman_filter_rssi(rssi_g, 0.01, var(rssi_g));
tcf('kalman');
figure('name', 'kalman', 'color', 'white')
hold on
plot(cur_rssi, 'LineWidth', 1.5)
plot(rssi_kf, 'LineWidth', 1.5)
plot(ones(size(rssi_kf)) * mean(cur_rssi), 'LineWidth', 1.5)
plot(rssi_gk, 'LineWidth', 1.5)
legend('origin', 'kalman', 'mean', 'gauss-kalman')
box on
title('kalman filter .vs. gauss kalman filter')
set(get(gca, 'XLabel'), 'String', '采样序列');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');

%%
figure('color', 'white')
subplot(211)
plot(HLK_17m_75cmA7, 'Color', 'r', 'Marker', '*')
title('HLK-17m-75cm-A7')
subplot(212)
plot(HLK_1m_00cmA7, 'Color', 'r', 'Marker', '*')
title('HLK-1m-00cm-A7')

