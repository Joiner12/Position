%% -------------------------------------------------------------------------- %%
%% 标准测试数据对比6m和9m RSSI均值基本相同 11m和12m RSSI基本相同
clc;
load(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\', ...
    'data\std_diss.mat']);
mean_rssi_all = zeros(1, 18);

for k = 1:18
    eval(['rssi_temp=', 'm_', num2str(k)]);
    mean_rssi_all(k) = mean(rssi_temp);
end

tcf('std rssi-dist');
figure('name', 'std rssi-dist', 'color', 'w');
plot(linspace(1, length(mean_rssi_all), length(mean_rssi_all)), mean_rssi_all, ...
    'marker', 'o', 'linewidth', 1.5)
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'Title'), 'String', '标准测试数据');

%% -------------------------------------------------------------------------- %%
%% HLK 标准测试数据
clc;
load(['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\', ...
    'data\std_diss_hlk.mat']);
disp('HLK')
tcf('HLK');
figure('name', 'HLK', 'color', 'w');
subplot(4,2,1)
% rssi基本相同索引
%[7,14,15]
plot(linspace(1, 18, 18), m_RSSI_HLK_1, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 1')
subplot(4,2,2)
% rssi基本相同索引
%[9,13]
plot(linspace(1, 18, 18), m_RSSI_HLK_2, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 2')
subplot(4,2,3)
% rssi基本相同索引
%[3,14;7,13]
plot(linspace(1, 18, 18), m_RSSI_HLK_3, ...
    'marker', 'o', 'linewidth', 1.5)
    title('HLK 3')
subplot(4,2,4)
% rssi基本相同索引
%[5,10;7,16;4,14]
plot(linspace(1, 18, 18), m_RSSI_HLK_4, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 4')
subplot(4,2,5)
% rssi基本相同索引
%[5,13;7,14;4,14]
plot(linspace(1, 18, 18), m_RSSI_HLK_5, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 5')
subplot(4,2,6)
% rssi基本相同索引
%[3,8;5,14;7,13;10,16]
plot(linspace(1, 18, 18), m_RSSI_HLK_6, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 6')
subplot(4,2,7)
% rssi基本相同索引
%[5,13;12,14;11,18]
plot(linspace(1, 18, 18), m_RSSI_HLK_7, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 7')
subplot(4,2,8)
% rssi基本相同索引
%[8,13;7,15;10,15]
plot(linspace(1, 18, 18), m_RSSI_HLK_8, ...
    'marker', 'o', 'linewidth', 1.5)
title('HLK 8')
%%
filter_index = [6, 9, 11, 12];
% m6 & m9
tcf('m6-m9');
f1 = figure('name', 'm6-m9', 'color', 'w');
ax1 = subplot(2, 1, 1);
subplot_m(ax1, m_6, '6m')

ax2 = subplot(2, 1, 2);
subplot_m(ax2, m_9, '9m')
tcf('m11-m12');
f2 = figure('name', 'm11-m12', 'color', 'w');
ax1 = subplot(2, 1, 1);
subplot_m(ax1, m_11, '11m')
ax2 = subplot(2, 1, 2);
subplot_m(ax2, m_12, '12m')
%% HLK不同距离相同RSSI统计特征图
%[5,10;7,16;4,14]
% HLK-1
tcf('HLK-1')
figure('name','HLK-1','color','w')
ax1=subplot(2,1,1);
subplot_m(ax1, std_rssi_one_HLK_8{1,7}.RSSI, 'hlk-8-7m')
ax2=subplot(2,1,2);
subplot_m(ax2, std_rssi_one_HLK_8{1,15}.RSSI, 'hlk-8-15m')

tcf('HLK-2')
figure('name','HLK-2','color','w')
ax1=subplot(2,1,1);
subplot_m(ax1, std_rssi_one_HLK_8{1,8}.RSSI, 'hlk-8-8m')
ax2=subplot(2,1,2);
subplot_m(ax2, std_rssi_one_HLK_8{1,13}.RSSI, 'hlk-8-13m')

tcf('HLK-3')
figure('name','HLK-3','color','w')
ax1=subplot(2,1,1);
subplot_m(ax1, std_rssi_one_HLK_8{1,10}.RSSI, 'hlk-8-10m')
ax2=subplot(2,1,2);
subplot_m(ax2, std_rssi_one_HLK_8{1,15}.RSSI, 'hlk-8-15m')

% figure('name','HLK-4','color','w')
% ax1=subplot(2,1,1);
% subplot_m(ax1, std_rssi_one_HLK_7{1,10}.RSSI, 'hlk-7-10m')
% ax2=subplot(2,1,2);
% subplot_m(ax2, std_rssi_one_HLK_7{1,16}.RSSI, 'hlk-7-16m')

%% -------------------------------------------------------------------------- %%
%% p36测试数据分析
clc;
% ap_msg = blu_data_analyse_static();
rssi0 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\data\', ...
                    'data_beacon_100ms_6_15米 - rename \ P36.txt'], 'Beacon0');
rssi7 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\data\', ...
                    'data_beacon_100ms_6_15米-rename\P36.txt'], 'Beacon7');
rssi8 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\data\', ...
                    'data_beacon_100ms_6_15米-rename\P36.txt'], 'Beacon8');
rssi9 = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab\data\', ...
                    'data_beacon_100ms_6_15米-rename\P36.txt'], 'Beacon9');
tcf('p36-data')
f3 = figure('name', 'p36-data', 'color', 'w');
ax1 = subplot(2, 2, 1);
subplot_m(ax1, rssi0, 'Beacon0')
ax2 = subplot(2, 2, 2);
subplot_m(ax2, rssi7, 'Beacon7')
ax3 = subplot(2, 2, 3);
subplot_m(ax3, rssi8, 'Beacon8')
ax4 = subplot(2, 2, 4);
subplot_m(ax4, rssi9, 'Beacon9')
%% -------------------------------------------------------------------------- %%
%% Beacon 标准数据分析
% ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\','Beacon6-2m.txt']
tcf('Beacon-data')
f3 = figure('name', 'Beacon-data', 'color', 'w');
ax1 = subplot(2, 1, 1);
subplot_m(ax1, BeaconRSSI(4).rssi, 'Beacon 4m')
ax2 = subplot(2, 1, 2);
subplot_m(ax2, BeaconRSSI(10).rssi, 'Beacon 10m')
%% -------------------------------------------------------------------------- %%
%% 绘图函数-1
function subplot_m(ax, rssi_data, title_pre)
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

    if nargin < 3
        title_pre_temp = '';
    else
        title_pre_temp = title_pre;
    end

    title_str = [title_pre_temp, ' RSSI,', 'σ:', ...
                num2str(std(rssi_data), '%.2f'), 'μ:', ...
                num2str(mean(rssi_data), '%.2f')];
    title(title_str);
end
