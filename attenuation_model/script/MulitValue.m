%% 两值问题分析
clc;
tcf();
% 'beacon4两值波动-3-单个信标测试-1m.fig'
% 'beacon4两值波动-3-多个信标测试-2m.fig'
open('beacon4两值波动-3-多个信标测试-2m.fig');
a = gca;
beacon4_m_2m = a.Children.YData;
tcf();

%%
clearvars -except beacon* rssi_figure
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
tcf('lg');
figure('name', 'lg', 'color', 'w');
subplot(3,2,[1,2])
plot(beacon4_s_1m,'Marker','*')
hold on
plot(beacon4_s_2m,'Marker','*')
hold on
plot(beacon4_m_1m,'Marker','*')
hold on
plot(beacon4_m_2m,'Marker','*')
legend({'单beacon-1m','单beacon-2m','多beacon-1m','多beacon-2m'})
xlabel('采样序列'); ylabel('RSSI/dBm');
subplot(323)
histogram(beacon4_s_1m, max(beacon4_s_1m) - min(beacon4_s_1m))
title('单beacon-1m');xlabel('RSSI/dBm'); ylabel('频次');
subplot(324)
histogram(beacon4_s_2m, max(beacon4_s_2m) - min(beacon4_s_2m))
title('单beacon-2m');xlabel('RSSI/dBm'); ylabel('频次');
subplot(325)
histogram(beacon4_m_1m, max(beacon4_m_1m) - min(beacon4_m_1m))
title('多beacon-1m');xlabel('RSSI/dBm'); ylabel('频次');
subplot(326)
histogram(beacon4_m_2m, max(beacon4_m_2m) - min(beacon4_m_2m))
title('多beacon-2m');xlabel('RSSI/dBm'); ylabel('频次');