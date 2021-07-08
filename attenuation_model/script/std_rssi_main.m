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
title("����ʽ���-���뻷������(DEV)")
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

set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dbm');
set(get(gca, 'Title'), 'String', 'CH-39����-RSSI��Ӧͼ');

%%
tcf('nake');
figure('name', 'nake', 'color', 'w')
hold on
box on
title('rssi-�����Ӧ��ϵ(���ŵ�-ch39)')

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

set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dbm');
legend('rssi', '��ֵ')
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
    'D:\Code\BlueTooth\pos_bluetooth_matlab\data\ope���ŵ�-ch39����\static-3.txt', ...
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
set(get(gca, 'XLabel'), 'String', '��������');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'Title'), 'String', 'kalman & median filter');
box on

if true
    pic_name = 'kalman-median-filtering-3-ope4.png';
    saveas(f1, fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img', pic_name));
end
