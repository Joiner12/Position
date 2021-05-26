%% ��׼RSSI������ϵĸ�˹�ֲ���mu��Ϊ�������ӦRSSI;
%% HLK-{1,8} �ֲ����ݻ�ȡ

std_rssi_dist_HLKALL = {std_rssi_one_HLK_1; std_rssi_one_HLK_2; ...
                        std_rssi_one_HLK_3; std_rssi_one_HLK_4; ...
                        std_rssi_one_HLK_5; std_rssi_one_HLK_6; ...
                        std_rssi_one_HLK_7; std_rssi_one_HLK_8};

for i = 1:1:8
    temp_std = std_rssi_dist_HLKALL{i};

    for k = 1:1:length(temp_std)
        rssi = temp_std{k}.RSSI;
        pd = fitdist(rssi, 'Normal')
        temp_std{k}.gaussian_fit = pd;
        temp_std{k}.mean_val = mean(rssi);
        temp_std{k}.gaussian_filter_val = like_gaussian_filter(rssi, 1, 'mean')
        disp(pd.mu);
        disp(mean(rssi));
        % kalman filter
        for j = 1:1:length(rssi)

            if isequal(j, 1)

            else

            end

        end

    end

    std_rssi_dist_HLKALL{i} = temp_std;
end

for k = 1:1:8
    eval(['std_rssi_one_HLK_', num2str(k), '=std_rssi_dist_HLKALL{', num2str(k), '}']);
end

clearvars pd k j cur_ap gauss_data ans temp_std i

%% �Աȸ�˹�ֲ���ֵ��ͳ�ƾ�ֵ
clc;

for k = 1:1:length(std_rssi_dist_HLKALL)
    cur_ap = std_rssi_dist_HLKALL{k};
    eval(['g_m_RSSI_HLK_', num2str(k), '=zeros(0)']);

    for j = 1:1:length(cur_ap)
        cur_ap_dist = cur_ap{j};
        pd = cur_ap_dist.gaussian_fit;
        eval(['g_m_RSSI_HLK_', num2str(k), '=[g_m_RSSI_HLK_', num2str(k), '; pd.mu]']);
    end

end

disp('ding');
clearvars pd k j cur_ap gauss_data ans

%%
clc;
g_m_RSSI_HLK_A = {g_m_RSSI_HLK_1, g_m_RSSI_HLK_2, g_m_RSSI_HLK_3, ...
                g_m_RSSI_HLK_4, g_m_RSSI_HLK_5, g_m_RSSI_HLK_6, ...
                g_m_RSSI_HLK_7, g_m_RSSI_HLK_8};

m_RSSI_HLK_A = {m_RSSI_HLK_1, m_RSSI_HLK_2, m_RSSI_HLK_3, ...
                m_RSSI_HLK_4, m_RSSI_HLK_5, m_RSSI_HLK_6, ...
                m_RSSI_HLK_7, m_RSSI_HLK_8};

for k = 1:1:8
    tcf('kamaz');
    f1 = figure('name', 'kamaz');
    plot(g_m_RSSI_HLK_A{k}, 'Linewidth', 2)
    hold on
    plot(m_RSSI_HLK_A{k}, 'Linewidth', 2);
    xlabel('����/m')
    ylabel('RSSI/dB')
    legend({'��̬�ֲ���ֵ', 'ͳ�ƾ�ֵ'})
    title('��̬�ֲ���ֵvsͳ�ƾ�ֵ')
    grid minor
    figname = sprintf('D:\\Code\\BlueTooth\\pos_bluetooth_matlab\\attenuation_model\\figure\\��̬�ֲ���ֵvsͳ�ƾ�ֵ-HLK_%s.fig', ...
        num2str(k));
    pause(1);
end

%% ��˹�ֲ�����Ա�
clc;
g_m_RSSI_HLK_A = {g_m_RSSI_HLK_1, g_m_RSSI_HLK_2, g_m_RSSI_HLK_3, ...
                g_m_RSSI_HLK_4, g_m_RSSI_HLK_5, g_m_RSSI_HLK_6, ...
                g_m_RSSI_HLK_7, g_m_RSSI_HLK_8};

m_RSSI_HLK_A = {m_RSSI_HLK_1, m_RSSI_HLK_2, m_RSSI_HLK_3, ...
                m_RSSI_HLK_4, m_RSSI_HLK_5, m_RSSI_HLK_6, ...
                m_RSSI_HLK_7, m_RSSI_HLK_8};

tcf('kamaz-1');
figure('name', 'kamaz-1');

subplot(211)

for k = 1:1:length(g_m_RSSI_HLK_A)
    plot(g_m_RSSI_HLK_A{k})
    hold on
end

title('��˹�ֲ���ֵ��ͬAP�Ա�')
legend({'oneposHLK-1', 'oneposHLK-2', 'oneposHLK-3', ...
        'oneposHLK-4', 'oneposHLK-5', 'oneposHLK-6', ...
        'oneposHLK-7', 'oneposHLK-8'});
subplot(212)

for k = 1:1:length(m_RSSI_HLK_A)
    plot(m_RSSI_HLK_A{k})
    hold on
end

legend({'oneposHLK-1', 'oneposHLK-2', 'oneposHLK-3', ...
        'oneposHLK-4', 'oneposHLK-5', 'oneposHLK-6', ...
        'oneposHLK-7', 'oneposHLK-8'});
title('ͳ�ƾ�ֵ��ͬAP�Ա�')

clearvars pd k j cur_ap gauss_data ans f1
%% ��˹�˲��ԱȾ�ֵ�˲�

for kk = 1:1:1
    clc;
    dist_p = linspace(1, length(temp_data_1), length(temp_data_1));
    disp('��˹�˲��ԱȾ�ֵ�˲�');
    tcf('danwo');
    f1 = figure('name', 'danwo', 'color', 'w');
    hold on
    temp_data_1 = zeros(0);
    temp_data_2 = zeros(0);

    eval(['temp_hlk = std_rssi_one_HLK_', num2str(kk), ';']);
    % temp_hlk = std_rssi_one_HLK_1;

    for k = 1:length(temp_hlk)
        temp_data_1(k) = temp_hlk{k}.mean_val;
        temp_data_2(k) = temp_hlk{k}.gaussian_filter_val;
    end

    plot(dist_p, temp_data_1, 'marker', '*');
    plot(dist_p, temp_data_2, 'marker', '^');
    xlim([0, 19])
    legend('average', 'gaussian filter value')
    xlabel('dist/m'); ylabel('rssi/dbm')
    title(strcat('HKL-', num2str(kk)));

    if false
        tar_file = ...
            strcat('D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\doc\img\Gaussian-Filter-HLK-', ...
            num2str(kk), '.png');
        tar_file_1 = strcat('D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\figure\gaussian-filter-HLK-', ...
            num2str(kk), '.fig');
        saveas(f1, tar_file_1)
        figure2img(f1, tar_file)
    end

end

%% ����ģ�ͶԱ�(����)����ʽ���
clc;
slg_gof = cell([8, 4]);
slg_fit = cell([8, 4]);

for kk = 1:1:8
    eval(['temp_hlk = std_rssi_one_HLK_', num2str(kk), ';']);
    % temp_hlk = std_rssi_one_HLK_1;

    for k = 1:length(temp_hlk)
        temp_data_1(k) = temp_hlk{k}.mean_val;
        temp_data_2(k) = temp_hlk{k}.gaussian_filter_val;
    end

    % ��ֵ+����ʽ
    [fit_p_mean, gof_p_mean] = create_polynomial_model_fit(dist_p, temp_data_1);
    fcof_p_mean = coeffvalues(fit_p_mean);
    slg_fit{kk, 1} = fit_p_mean;
    slg_gof{kk, 1} = gof_p_mean;
    % ��ֵ+����
    [fit_log_mean, gof_log_mean] = create_logarithmic_model_fit(dist_p, temp_data_1);
    fcof_log_mean = coeffvalues(fit_log_mean);
    slg_fit{kk, 2} = fit_log_mean;
    slg_gof{kk, 2} = gof_log_mean;
    % ��˹+����ʽ
    [fit_p_gauss, gof_p_gauss] = create_polynomial_model_fit(dist_p, temp_data_2);
    fcof_p_gauss = coeffvalues(fit_p_gauss);
    slg_fit{kk, 3} = fit_p_gauss;
    slg_gof{kk, 3} = gof_p_gauss;
    % ��˹+����
    [fit_log_gauss, gof_log_gauss] = create_logarithmic_model_fit(dist_p, temp_data_2);
    fcof_log_gauss = coeffvalues(fit_log_gauss);
    slg_fit{kk, 4} = fit_log_gauss;
    slg_gof{kk, 4} = gof_log_gauss;

    rssi_c = linspace(min(min(rssi) - 2, -90), max(rssi) + 5, 50);
    y_log_mean = power(10, (fcof_log_mean(1) - rssi_c) / 10 / fcof_log_mean(2));
    y_p_mean = fcof_p_mean(1) * rssi_c.^2 + fcof_p_mean(2) * rssi_c + fcof_p_mean(3);
    y_log_gauss = power(10, (fcof_log_gauss(1) - rssi_c) / 10 / fcof_log_gauss(2));
    y_p_gauss = fcof_p_gauss(1) * rssi_c.^2 + fcof_p_gauss(2) * rssi_c + fcof_p_gauss(3);

    tcf('log-p')
    f1 = figure('name', 'log-p', 'Color', 'w');
    subplot(2, 1, 1)
    box on
    hold on
    % p1
    p1 = plot(fit_p_mean, temp_data_1, dist_p);
    p1(1).MarkerSize = 12;
    p1(1).LineStyle = ':';
    p1(1).Color = [188, 15, 213] ./ 255;
    p1(2).Color = [226, 81, 36] ./ 255;
    % p1(2).LineStyle = '--'; %-- :
    p1(2).LineWidth = 1.2;
    % p2
    p2 = plot(fit_log_mean, temp_data_1, dist_p);
    p2(1).MarkerSize = 1;
    p2(1).Color = 'w';
    p2(2).Color = [228, 207, 23] ./ 255;
    % p2(2).LineStyle = '--';
    p2(2).LineWidth = 1.2;
    % p3
    p3 = plot(fit_p_gauss, temp_data_2, dist_p);
    p3(1).MarkerSize = 12;
    p3(1).LineStyle = ':';
    p3(1).Color = [9, 192, 185] ./ 255;
    p3(2).Color = [72, 191, 21] ./ 255;
    p3(2).LineStyle = '--';
    p3(2).LineWidth = 1.2;
    % p4
    p4 = plot(fit_log_gauss, temp_data_2, dist_p);
    p4(1).MarkerSize = 1;
    p4(1).Color = 'w';
    p4(2).Color = [15, 110, 213] ./ 255;
    p4(2).LineWidth = 1.2;
    p4(2).LineStyle = '--';
    %
    legend('��ֵ', '��ֵ-����ʽ���', ...
        '', '��ֵ-�������', '��˹�˲�ֵ', '��˹-����ʽ���', '', '��˹-�������')
    set(get(gca, 'Title'), 'String', strcat('���ζ���ʽģ�ͶԱȶ���ģ�� HLK-', num2str(kk)));
    subplot(2, 1, 2)
    box on
    hold on
    plot(rssi_c, y_p_mean, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
    plot(rssi_c, y_log_mean, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
    plot(rssi_c, y_p_gauss, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
    plot(rssi_c, y_log_gauss, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);

    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'dist/m');
    legend('��ֵ-����ʽ���', '��ֵ-�������', '��˹-����ʽ���', '��˹-�������')
    % save figure

    if false
        % D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\figure
        % D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\script
        % D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\doc
        tar_file_png = strcat('./temp/ployfit-logafit-mean-gauss-', num2str(kk), '.png');
        tar_file_fig = strcat('./temp/ployfit-logafit-mean-gauss-', num2str(kk), '.fig');
        saveas(f1, tar_file_fig)
        figure2img(f1, tar_file_png)
    end

end

%% write log
clc;

if ~isfolder('./temp')
    mkdir('temp');
end

fileID = fopen('./temp/log.md', 'w');

for kk = 8:8
    % ��ֵ+����ʽ
    disp('**��ֵ+����ʽ���ģ��**')
    slg_fit{kk, 1} % = fit_p_mean;
    disp('**��ֵ+����ʽ��Ͻ��**')
    slg_gof{kk, 1} % = gof_p_mean;
    % ��ֵ+����
    disp('**��ֵ+�������ģ��**')
    slg_fit{kk, 2} % = fit_log_mean;
    disp('**��ֵ+������Ͻ��**')
    slg_gof{kk, 2} % = gof_log_mean;
    % ��˹+����ʽ
    disp('**��˹+����ʽ���ģ��**')
    slg_fit{kk, 3} % = fit_p_gauss;
    disp('**��˹+����ʽ��Ͻ��**')
    slg_gof{kk, 3} % = gof_p_gauss;
    % ��˹+����
    disp('**��˹+�������ģ��**')
    slg_fit{kk, 4} % = fit_log_gauss;
    disp('**��˹+������Ͻ��**')
    slg_gof{kk, 4} % = gof_log_gauss;
end

fclose(fileID);

%%
clc;
all_rssi_gauss = cell(0);
ap_rssi_gauss_specdist = zeros(8, 18);
ap_rssi_gauss_pp = zeros(0);

for ii = 1:8
    eval(['temp_hlk = std_rssi_one_HLK_', num2str(ii), ';']);
    % temp_hlk = std_rssi_one_HLK_1;
    for k = 1:length(temp_hlk)
        temp_data_2(k) = temp_hlk{k}.gaussian_filter_val;
    end

    ap_rssi_gauss_specdist(ii, :) = temp_data_2;
    all_rssi_gauss{ii} = temp_data_2;
end

for j = 1:18
    ap_rssi_gauss_gauss(j) = like_gaussian_filter(ap_rssi_gauss_specdist(:, j), 1, 'mean');
    ap_rssi_gauss_mean(j) = mean(ap_rssi_gauss_specdist(:, j));
end

% v
clc;
tcf('expmean');
figure('name', 'expmean', 'color', 'w');
legds = cell(0);
mark_symbol = ['o', '+', '*', '.', 'x', '^', 'v', ...
                '>', '<', 'pentagram', 'hexagram', 'square', 'diamond'];

for k = 1:1:length(all_rssi_gauss)
    rssi_temp = all_rssi_gauss{k};
    plot(rssi_temp, 'marker', mark_symbol(k))
    hold on
    legds = [legds, num2str(k)];
end

plot(ap_rssi_gauss_gauss, 'LineWidth', 2, 'Marker', '.')
hold on
legds = [legds, 'gauss-gauss'];
plot(ap_rssi_gauss_mean, 'LineWidth', 2, 'Marker', '+')
hold on
legds = [legds, 'gauss-mean'];
plot(ap_rssi_mean_specdist, 'LineWidth', 2, 'Marker', '*')
legds = [legds, 'mean'];
legend(legds)
xlim([0, 19])

%% ����ģ�ͶԱ�(����)����ʽ���
clc;
% ap_rssi_gauss_gauss
% ap_rssi_gauss_mean
% ap_rssi_mean_specdist

% mean mean +����ʽ
[fit_p_meanmean, gof_p_meanmean] = create_polynomial_model_fit(dist_p, ap_rssi_mean_specdist);
fcof_p_meanmean = coeffvalues(fit_p_meanmean);
% mean mean +����
[fit_log_meanmean, gof_log_meanmean] = create_logarithmic_model_fit(dist_p, ap_rssi_mean_specdist);
fcof_log_meanmean = coeffvalues(fit_log_meanmean);
% gauss mean+����ʽ
[fit_p_gaussmean, gof_p_gaussmean] = create_polynomial_model_fit(dist_p, ap_rssi_gauss_mean);
fcof_p_gaussmean = coeffvalues(fit_p_gaussmean);
% gauss mean+����
[fit_log_gaussmean, gof_log_gaussmean] = create_logarithmic_model_fit(dist_p, ap_rssi_gauss_mean);
fcof_log_gaussmean = coeffvalues(fit_log_gaussmean);

% gauss gauss+����ʽ
[fit_p_gaussgauss, gof_p_gaussgauss] = create_polynomial_model_fit(dist_p, ap_rssi_gauss_gauss);
fcof_p_gaussgauss = coeffvalues(fit_p_gaussgauss);
% gauss gauss+����
[fit_log_gaussgauss, gof_log_gaussgauss] = create_logarithmic_model_fit(dist_p, ap_rssi_gauss_gauss);
fcof_log_gaussgauss = coeffvalues(fit_log_gaussgauss);

rssi_c = linspace(min(min(rssi) - 2, -90), max(rssi) + 5, 50);
y_log_meanmean = power(10, (fcof_log_meanmean(1) - rssi_c) / 10 / fcof_log_meanmean(2));
y_p_meanmean = fcof_p_meanmean(1) * rssi_c.^2 + fcof_p_meanmean(2) * rssi_c + fcof_p_meanmean(3);
y_log_gaussmean = power(10, (fcof_log_gaussmean(1) - rssi_c) / 10 / fcof_log_gaussmean(2));
y_p_gaussmean = fcof_p_gaussmean(1) * rssi_c.^2 + fcof_p_gaussmean(2) * rssi_c + fcof_p_gaussmean(3);
y_log_gaussgauss = power(10, (fcof_log_gaussgauss(1) - rssi_c) / 10 / fcof_log_gaussgauss(2));
y_p_gaussgauss = fcof_p_gaussgauss(1) * rssi_c.^2 + fcof_p_gaussgauss(2) * rssi_c + fcof_p_gaussgauss(3);
disp('fit finished')
%% 
tcf('log-p')
f1 = figure('name', 'log-p', 'Color', 'w');
subplot(2, 1, 1)
box on
hold on
% p1
p1 = plot(fit_p_mean, temp_data_1, dist_p);
p1(1).MarkerSize = 12;
p1(1).LineStyle = ':';
p1(1).Color = [188, 15, 213] ./ 255;
p1(2).Color = [226, 81, 36] ./ 255;
% p1(2).LineStyle = '--'; %-- :
p1(2).LineWidth = 1.2;
% p2
p2 = plot(fit_log_mean, temp_data_1, dist_p);
p2(1).MarkerSize = 1;
p2(1).Color = 'w';
p2(2).Color = [228, 207, 23] ./ 255;
% p2(2).LineStyle = '--';
p2(2).LineWidth = 1.2;
% p3
p3 = plot(fit_p_gauss, temp_data_2, dist_p);
p3(1).MarkerSize = 12;
p3(1).LineStyle = ':';
p3(1).Color = [9, 192, 185] ./ 255;
p3(2).Color = [72, 191, 21] ./ 255;
p3(2).LineStyle = '--';
p3(2).LineWidth = 1.2;
% p4
p4 = plot(fit_log_gauss, temp_data_2, dist_p);
p4(1).MarkerSize = 1;
p4(1).Color = 'w';
p4(2).Color = [15, 110, 213] ./ 255;
p4(2).LineWidth = 1.2;
p4(2).LineStyle = '--';
%
legend('��ֵ', '��ֵ-����ʽ���', ...
    '', '��ֵ-�������', '��˹�˲�ֵ', '��˹-����ʽ���', '', '��˹-�������')
set(get(gca, 'Title'), 'String', strcat('���ζ���ʽģ�ͶԱȶ���ģ�� HLK-', num2str(kk)));
subplot(2, 1, 2)
box on
hold on
plot(rssi_c, y_p_mean, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
plot(rssi_c, y_log_mean, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
plot(rssi_c, y_p_gauss, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);
plot(rssi_c, y_log_gauss, 'Marker', '*', 'LineWidth', 1.2, 'MarkerSize', 4);

set(get(gca, 'XLabel'), 'String', 'rssi/dB');
set(get(gca, 'YLabel'), 'String', 'dist/m');
legend('��ֵ-����ʽ���', '��ֵ-�������', '��˹-����ʽ���', '��˹-�������')
% save figure
