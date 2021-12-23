%%
clc;
% blu_data_analyse_static()
clear;
load(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\', ...
    'data\std_diss.mat']);
mean_rssi_all = zeros(1, 18);
filter_index = [6, 9, 11, 12];
%%
% m6 & m9
tcf('m6-m9');
f1 = figure('name', 'm6-m9', 'color', 'w');
ax1 = subplot(2, 1, 1);
subplot_m(ax1, m_6)

ax2 = subplot(2, 1, 2);
subplot_m(ax2, m_9)

f2 = figure('name', 'm11-m12', 'color', 'w');
ax1 = subplot(2, 1, 1);
subplot_m(ax1, m_11)

ax2 = subplot(2, 1, 2);
subplot_m(ax2, m_12)
%%
for k = 1:length(filter_index)
    char_temp = strcat('m_', num2str(filter_index(k)));
    tcf(char_temp);
    % continue;
    figure('name', char_temp, 'color', 'w');
    hold on;
    eval(['temp_rssi=', char_temp, ';']);
    plot(temp_rssi, 'r*-');
    %绘制rssi均值线、最大值线、最小值线
    rssi_mean = mean(temp_rssi);
    rssi_max = max(temp_rssi);
    rssi_min = min(temp_rssi);
    plot([1, length(temp_rssi)], [rssi_mean, rssi_mean], 'b-');

    plot([1, length(temp_rssi)], [rssi_max, rssi_max], 'm--');
    plot([1, length(temp_rssi)], [rssi_min, rssi_min], 'c--');

    %设置标签
    legend('rssi', ['rssi mean:', num2str(rssi_mean)], ...
    ['rssi max:', num2str(rssi_max)], ...
        ['rssi min:', num2str(rssi_min)]);
    title(char_temp);
    ylabel('rssi');
    hold off
    tcf(char_temp);
    mean_rssi_all(k) = rssi_mean;
end

function subplot_m(ax, rssi_data)
    hold on
    plot(ax, rssi_data, 'r*-');
    %绘制rssi均值线、最大值线、最小值线
    % hold on
    rssi_mean = mean(rssi_data);
    rssi_max = max(rssi_data);
    rssi_min = min(rssi_data);
    plot(ax, [1, length(rssi_data)], [rssi_mean, rssi_mean], 'b-');

    plot(ax, [1, length(rssi_data)], [rssi_max, rssi_max], 'm--');
    plot(ax, [1, length(rssi_data)], [rssi_min, rssi_min], 'c--');

    %设置标签
    legend('rssi', ['rssi mean:', num2str(rssi_mean)], ...
    ['rssi max:', num2str(rssi_max)], ...
        ['rssi min:', num2str(rssi_min)]);
    ylabel('rssi');
    hold off
end
