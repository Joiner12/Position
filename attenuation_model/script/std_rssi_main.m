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
tcf('trend');
figure('name', 'trend', 'color', 'white')
box on
hold on
plot(mean_vals_ch39, 'marker', '*', 'Linewidth', 1.0)
legend('mean-filter-ch39', 'mean-filter-ch38', 'mean-filter-ch39')

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
tcf('lpr');
figure('name', 'lpr', 'color', 'w')
hold on
box on
plot(ch37_lfr)
plot(ch38_lfr)
plot(ch39_lfr)
legend('ch37', 'ch38', 'ch39')
title('lose frame rate')
%%
distance = linspace(1, 18, 18);
dist_part = distance(1:15);
mean_vals_ch39_part = mean_vals_ch39(1:15);
%%
for k = 1:1:18
    verify_midian_filter_and_model(k);
    pause();
end

%% check for median filter
clc;
disp('check for median filter');
rssi_39_static_1 = get_rssi_info(...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\data\ope单信道-ch39测试\static-3.txt', ...
    'ope_4');
median_filter_rssi_39_static_1 = median_filter(rssi_39_static_1, 11);
kalman_filter_rssi_39_static_1 = kalman_filter_rssi(rssi_39_static_1, 0.1, 10);
median_kalman_filter_rssi_39_static_1 = median_filter(kalman_filter_rssi_39_static_1, 11);
tcf('medianfilter');
rssi_x = 1:1:length(rssi_39_static_1); %
% 'Position',[1,31,1920,972],'InnerPosition',[1,31,1920,972],'OuterPosition',[-7,23,1936,1066]
f1 = figure('name', 'medianfilter', 'color', 'w'); %,...
%'Position',[1,31,1920,972],'InnerPosition',[1,31,1920,972],'OuterPosition',[-7,23,1936,1066]...);

hold on
plot(rssi_x, rssi_39_static_1, 'Marker', '.', 'MarkerSize', 8)
plot(rssi_x, median_filter_rssi_39_static_1, 'Marker', '.', 'MarkerSize', 8)
plot(rssi_x, kalman_filter_rssi_39_static_1, 'Marker', '.', 'MarkerSize', 8)
plot(rssi_x, median_kalman_filter_rssi_39_static_1, 'Marker', '.', 'MarkerSize', 8)
legend({'org', 'median', 'kalman', 'kalman-median'});
set(get(gca, 'XLabel'), 'String', '采样序列');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'Title'), 'String', 'kalman & median filter');
box on

if true
    pic_name = 'kalman-median-filtering-3-ope4.png';
    saveas(f1, fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img', pic_name));
end

%%
clc;
% Linear model Poly2:
% f(x) = p1*x^2 + p2*x + p3
% where x is normalized by mean -47.11 and std 6.718
% Coefficients (with 95% confidence bounds):
% p1 =      0.8076  (-0.5569, 2.172)
% p2 =      -4.642  (-6.304, -2.98)
% p3 =       7.191  (5.202, 9.18)
poly_model_func = @(a, b, c, env, x)(a .* (x - env).^2 + b .* (x - env) + c);
rssi_x = linspace(min(mean_vals_ch39) - 15, max(mean_vals_ch39) + 5, 50);
% rssi_x = rssi_x ; % center
dist_y = poly_model_func(0.01789, 0.9949, 14.35, -10, rssi_x);
tcf('poly-model');
f1 = figure('name', 'poly-model', 'color', 'w');

plot(rssi_x, dist_y, 'Marker', '.')

%%
clc;
[dist, prx_set_1] = wireless_channel_simulation(2400 * 1000000, 1, 1);
[~, prx_set_2] = wireless_channel_simulation(2400 * 1000000, 2, 1);
[~, prx_set_3] = wireless_channel_simulation(2400 * 1000000, 3, 1);
[~, prx_set_4] = wireless_channel_simulation(2400 * 1000000, 4, 1);
tcf('wan');
figure('name', 'wan', 'color', 'w');
box on
hold on
plot(dist(1:25), prx_set_1(1:25), 'LineWidth', 2)
plot(dist(1:25), prx_set_2(1:25), 'LineWidth', 2)
plot(dist(1:25), prx_set_3(1:25), 'LineWidth', 2)
plot(dist(1:25), prx_set_4(1:25), 'LineWidth', 2)
legend('TXAntenna Gain 1', 'TXAntenna Gain 2', 'TXAntenna Gain 3', 'TXAntenna Gain 4')
ylabel('RX Power (dBm)');
xlabel('Distance (m)');
title('不同发射功率-路径损耗(path loss)模型')

%% 
clc;
struct_test = struct();
for k=1:8
    struct_test(k).name = '我为你翻山越岭 却无心看风景';
    struct_test(k).lyr = [3,4,5,1];
end