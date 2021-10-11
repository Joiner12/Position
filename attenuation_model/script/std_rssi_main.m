%% 获取beacon的rssi信息
clc;
BeaconRSSI = struct();
mean_vals = zeros(0);
std_vals = zeros(0);
fluct_vals = zeros(0);
C_s = cell(0);
Clusters = cell(0);
median_mean_vals = zeros(0);

for k = 1:1:11
    cur_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\Beacon6-', ...
                num2str(k), 'm.txt'];
    rssi = get_rssi_info(cur_file, 'Beacon6');
    BeaconRSSI(k).dist = k;
    BeaconRSSI(k).rssi = rssi;
    BeaconRSSI(k).rssi_mean = mean(rssi);
    BeaconRSSI(k).rssi_std = std(rssi);
    BeaconRSSI(k).rssi_fluctuation = max(rssi) - min(rssi);
    mean_vals(k) = BeaconRSSI(k).rssi_mean;
    std_vals(k) = BeaconRSSI(k).rssi_std;
    fluct_vals(k) = BeaconRSSI(k).rssi_fluctuation;
    % 信道聚类
    [org_idx, C] = channel_clustering(BeaconRSSI(k).rssi, 3);
    BeaconRSSI(k).C = C;
    BeaconRSSI(k).clustering = org_idx;
    Clusters{k} = org_idx;
    C_s{k} = C;
    % 中值滤波 窗口大小21
    BeaconRSSI(k).rssi_medianfilter = medfilt1(rssi, 21);
    median_mean_vals(k) = mean(BeaconRSSI(k).rssi_medianfilter);
end

%%
for k = 1:length(C_s)
    temp = C_s{k}
    C_s{k} = sort(temp);
end

%% check for part clustering
disp('check for part clustering');

for w_i = 1:3
    window_temp = [20, 30, 40];
    clustering_window = window_temp(w_i);

    for index_beacon = 1:1:11
        org_rssi = BeaconRSSI(index_beacon).rssi;
        c_ref = BeaconRSSI(index_beacon).C;
        check_idx_s = cell(0);
        check_c_s = cell(0);

        for k = 1:clustering_window:length(org_rssi) - clustering_window
            rssi_temp = org_rssi(k:clustering_window + k - 1);
            [idx_a, c_a] = channel_clustering(rssi_temp, 3);
            index_k = (k - 1) / clustering_window + 1;
            check_idx_s{index_k} = idx_a;
            check_c_s{index_k} = c_a;
        end

        % figure
        tcf('clustering-check-1');
        f1 = figure('name', 'clustering-check-1', 'color', 'w', 'Position', [425, 327, 880, 578]);
        subplot(311)
        hold on

        scatter(zeros(size(c_ref)), c_ref, 25, zeros(size(c_ref)), 'filled');

        for j = 1:length(check_c_s)
            c_temp = check_c_s{j};
            scatter(j .* ones(size(c_temp)), c_temp, 25, j .* ones(size(c_temp)), 'filled');
        end

        legend('ref-clustering')
        set(get(gca, 'Title'), 'String', ['聚类结果校验-', num2str(index_beacon), 'm']);
        set(get(gca, 'XLabel'), 'String', '聚类序列');
        set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
        %
        subplot(312)
        c_temp_1 = cell2mat(check_c_s);
        residuals = zeros(0);
        residuals_diff = cell(0);

        for j1 = 1:length(c_temp_1)
            residuals_other = zeros(0);

            for k_2 = 1:length(C_s)
                c_temp = C_s{k_2};
                c_temp = sort(c_temp);
                residuals_other(k_2) = norm(sort(c_temp_1(:, j1)) - reshape(c_temp, [3, 1]));
            end

            residuals_diff{j1} = residuals_other;
            residuals(j1) = norm(reshape(sort(c_ref), [3, 1]) - sort(c_temp_1(:, j1)));
        end

        plot(residuals, 'LineWidth', 1.5)
        set(get(gca, 'Title'), 'String', ['聚类结果校验-', num2str(index_beacon), 'm']);
        set(get(gca, 'XLabel'), 'String', '聚类序列');
        set(get(gca, 'YLabel'), 'String', '残差/dBm');
        pic_name = ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\doc\img\', ...
                    'clustering-check-', num2str(index_beacon), 'm-', ...
                    num2str(clustering_window), '-1', '.png'];
        % 聚类结果和其他距离下RSSI聚类中心距离
        subplot(313)

        for k_3 = 1:length(residuals_diff)
            plot(residuals_diff{k_3})
            hold on
        end

        set(get(gca, 'Title'), 'String', ['距离:', num2str(index_beacon), 'm到其他聚类中心欧式距离']);
        set(get(gca, 'XLabel'), 'String', '距离/m');
        set(get(gca, 'YLabel'), 'String', '残差/dBm');
        saveas(f1, pic_name);
        fig_name = ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\figure\', ...
                    'Beacon-clustering-check-', num2str(index_beacon), 'm-', ...
                    num2str(clustering_window), '-1', '.fig'];
        savefig(f1, fig_name);
    end

end

%% 生成markdown
%{
< div style = "text - align:center; background - color:white; " >
< img src = "./img/clustering-check-1m-20-1.png" >< br >
< p > 距离1m 窗口大小20 信道聚类结果及残差 </ p >
< img src = "./img/clustering-check-1m-30-1.png" >< br >
< p > 距离1m 窗口大小30 信道聚类结果及残差 </ p >
< img src = "./img/clustering-check-1m-40-1.png" >< br >
< p > 距离1m 窗口大小40 信道聚类结果及残差 </ p >< br >
</ div >
%}
clc;
htmlId = fopen('D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\doc\channle-clustering-analysis.html', 'w');
fprintf(htmlId, '%s\n', ['<h1 style="text-align:center;">', '信道聚类分析', '</h1>']);

for index_beacon = 1:1:11
    window_temp = [20, 30, 40];
    fprintf(htmlId, '%s\n', ['<h2 style="text-align:center;">', '测试距离：' ...
                        , num2str(index_beacon), 'm分析', '</h2>']);
    fprintf(htmlId, '%s\n', '<div style="text-align:center; background-color:white;">');

    for w_i = 1:3
        clustering_window = window_temp(w_i);
        fprintf(htmlId, '%s\n', ['<p style="font-size:20px;color:#55544C"> 距离', num2str(index_beacon), 'm 窗口大小', ...
                            num2str(clustering_window), '聚类结果分析</p>']);
        fprintf(htmlId, '%s\n', ['<img src="./img/clustering-check-', ...
                            num2str(index_beacon), 'm-', ...
                            num2str(clustering_window), '-1.png"><br>']);

        if false
            fprintf(htmlId, '%s\n', ['<a href="', './../figure/', ...
                                'Beacon-clustering-check-', num2str(index_beacon), 'm-', ...
                                num2str(clustering_window), '-1', '.fig', ...
                                '">', 'Link text', '</a>']);
        end

        fprintf(htmlId, '%s\n', '<HR style="FILTER: alpha(opacity=100,finishopacity=0,style=3)" width="80%" color=#B9DBD6 SIZE=3>');
    end

    fprintf(htmlId, '%s\n', '<HR style="border:3 double #987cb9" width="80%" color=#B9DBD6 SIZE=3>');

    fprintf(htmlId, '%s\n', '</div>');
end

fclose(htmlId);

%% figure 混合信道下 dist-rssi
clc;
tcf('beacon-1'); f1 = figure('name', 'beacon-1', 'color', 'w');

for k = 1:1:6
    subplot(3, 2, k);
    plot(BeaconRSSI(k).rssi);
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-2'); f2 = figure('name', 'beacon-2', 'color', 'w');

for k = 7:1:11
    subplot(3, 2, k - 6);
    plot(BeaconRSSI(k).rssi);
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-3'); figure('name', 'beacon-3', 'color', 'w');
subplot(2, 2, 1)
plot(1:1:11, mean_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI均值');
subplot(2, 2, 2)
plot(1:1:11, std_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI标准差');
subplot(2, 2, 3)
plot(1:1:11, fluct_vals);
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'Title'), 'String', '距离——RSSI波动值');

%% figure-4
tcf('clustering'); figure('name', 'clustering', 'color', 'w');
hold on

for k = 1:11
    cur_C = BeaconRSSI(k).C;
    cur_dist = BeaconRSSI(k).dist;
    cur_clustering = BeaconRSSI(k).clustering;
    idx_temp = cur_clustering(:, 2);
    ch37 = idx_temp(idx_temp == 1);
    ch38 = idx_temp(idx_temp == 2);
    ch39 = idx_temp(idx_temp == 3);
    plot(cur_dist .* ones(size(cur_C)), cur_C, 'LineStyle', 'None', 'Marker', '*');
end

set(get(gca, 'Title'), 'String', '距离——RSSI信道聚类结果');
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');

%% figure median filter vs origin
clc;
tcf('beacon-median-1');
figure('name', 'beacon-median-1', 'color', 'w', 'Position', [425, 327, 880, 578]);

for k = 1:1:6
    subplot(3, 2, k);
    plot(BeaconRSSI(k).rssi);
    hold on
    plot(BeaconRSSI(k).rssi_medianfilter);
    legend('origin RSSI', 'median RSSI');
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

tcf('beacon-median-2');
figure('name', 'beacon-median-2', 'color', 'w', 'Position', [425, 327, 880, 578]);

for k = 7:1:11
    subplot(3, 2, k - 6);
    plot(BeaconRSSI(k).rssi);
    hold on
    plot(BeaconRSSI(k).rssi_medianfilter);
    legend('origin RSSI', 'median RSSI');
    title(strcat(num2str(BeaconRSSI(k).dist), 'm'));
end

subplot(3, 2, 6)
plot(linspace(1, length(median_mean_vals), length(median_mean_vals)), median_mean_vals)
set(get(gca, 'XLabel'), 'String', 'dist/m');
set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');

%% check clusteing is linear
C_sF = zeros([length(C_s), 3]);

for k = 1:length(C_s)
    C_sF(k, :) = (C_s{k});
end

tcf('plot3 clustering')
figure('name', 'plot3 clustering', 'color', 'w');
hold on
plot3(C_sF(:, 1), C_sF(:, 2), C_sF(:, 3))
plot3(C_sF(:, 1), C_sF(:, 2), C_sF(:, 3), 'LineStyle', 'None', 'Marker', '*')

for k = 1:length(C_s)
    text(C_sF(k, 1), C_sF(k, 2), C_sF(k, 3), [num2str(k), ' m'], ...
        'Color', 'b');
end

grid on

%%
clc;
dist = calc_distance_based_on_rssi_clustering([2, 3, 1]');
