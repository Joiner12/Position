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

%%
clc;
tcf();
% parse_data_ch37 = get_std_dist_rssi_data('figure', 'statistical');
% parse_data_ch38 = get_std_dist_rssi_data('figure', 'statistical');
parse_data_ch39 = get_std_dist_rssi_data('figure', 'statistical');

%%
gauss_vals_ch37 = zeros(0);
mean_vals_ch37 = zeros(0);
gauss_vals_ch38 = zeros(0);
mean_vals_ch38 = zeros(0);
gauss_vals_ch39 = zeros(0);
mean_vals_ch39 = zeros(0);

for k1 = 1:1:length(parse_data_ch37)
    gauss_vals_ch37(k1) = parse_data_ch37{k1}.lgmf_val;
    mean_vals_ch37(k1) = parse_data_ch37{k1}.mean_val;
end

for k1 = 1:1:length(parse_data_ch39)
    gauss_vals_ch38(k1) = parse_data_ch38{k1}.lgmf_val;
    mean_vals_ch38(k1) = parse_data_ch38{k1}.mean_val;
end

for k1 = 1:1:length(parse_data_ch39)
    gauss_vals_ch39(k1) = parse_data_ch39{k1}.lgmf_val;
    mean_vals_ch39(k1) = parse_data_ch39{k1}.mean_val;
end

%%
tcf('trend');
figure('name', 'trend', 'color', 'white')
box on
hold on
% plot(gauss_vals_ch37, 'Linewidth', 1.5)
plot(mean_vals_ch37, 'marker', '*', 'Linewidth', 1.0)
% plot(gauss_vals_ch38, 'marker', '*', 'Linewidth', 1.5)
plot(mean_vals_ch38, 'marker', '*', 'Linewidth', 1.0)
% plot(gauss_vals_ch39, 'marker', '<', 'Linewidth', 1.5)
plot(mean_vals_ch39, 'marker', '*', 'Linewidth', 1.0)
legend('mean-filter-ch37', 'mean-filter-ch38', 'mean-filter-ch39')

% legend('gauss-filter-ch37', 'mean-filter-ch37', 'gauss-filter-ch38', 'mean-filter-ch38', 'gauss-filter-ch39', 'mean-filter-ch39')
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dbm');
set(get(gca, 'Title'), 'String', 'CH-39距离-RSSI对应图');

%%
tcf('nake');
figure('name', 'nake', 'color', 'w')
hold on
box on
title('rssi-距离对应关系(单信道-ch39)')

for k = 1:1:length(parse_data_ch39)
    cur_info = parse_data_ch39{k};
    scatter(ones(size(cur_info.RSSI)) * cur_info.distance, cur_info.RSSI, '*')

    if isequal(k, 1)
        avr_line = line('XData', cur_info.distance, 'YData', cur_info.mean_val, ...
            'LineWidth', 1.5, 'Color', 'C', 'Marker', 'd');
    else
        avr_line.XData = [avr_line.XData, cur_info.distance];
        avr_line.YData = [avr_line.YData, cur_info.mean_val];
    end

end

set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dbm');
legend('rssi', '均值')
xlim([0, 19])

%%
clc;
var_ch37 = zeros(0);
var_ch38 = zeros(0);
var_ch39 = zeros(0);

for k1 = 1:1:length(parse_data_ch37)
    var_ch37(k1) = parse_data_ch37{k1}.v_val;
    var_ch38(k1) = parse_data_ch38{k1}.v_val;
    var_ch39(k1) = parse_data_ch39{k1}.v_val;
end

tcf('var');
figure('name', 'var', 'color', 'w')
hold on
box on
title('不同信道方差(Variance)与距离对应关系')
plot(var_ch37, 'marker', 'd')
plot(var_ch38, 'marker', '<')
plot(var_ch39, 'marker', '>')
legend('ch37', 'ch38', 'ch39')
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'RSSI方差/dbm^2');
xlim([0, 19])

%%
% ch37_lfr = zeros(0);
% ch38_lfr = zeros(0);
ch39_lfr = zeros(0);
for k1 = 1:1:18
    file_name = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39', ...
        ['ch39-', num2str(k1), 'm.txt'])
    data_stamp = get_std_rssi_data_with_time_stamp('filepath', file_name);

    y_data = zeros(0);
    x_data = zeros(0);

    for k = 1:length(data_stamp)
        x_data(k) = data_stamp{k, 1};
        rssi_temp = data_stamp{k, 2};

        if isempty(rssi_temp)
            y_data(k) = 0;
        elseif length(rssi_temp) > 1
            y_data(k) = rssi_temp(end);
        else
            y_data(k) = rssi_temp(1:end);
        end

    end

    lose_frame_rate = length(y_data(y_data == 0)) / length(y_data);
    % fprintf('lose frame rate:%0.2f\n', lose_frame_rate);
    ch39_lfr(k1) = lose_frame_rate;
end

%%

%%
tcf('timestamp');
figure('name', 'timestamp', 'color', 'w')
hold on
box on
plot(x_data, y_data, 'Marker', '*');

title('time stamp')
set(get(gca, 'XLabel'), 'String', 'time/10ms');
set(get(gca, 'YLabel'), 'String', 'RSSI');

%% 
tcf('lpr');
figure('name', 'lpr', 'color', 'w')
hold on
box on
plot(ch37_lfr)
plot(ch38_lfr)
plot(ch39_lfr)
legend('ch37','ch38','ch39')
title('lose frame rate')
%% 
verify_midian_filter_and_model()