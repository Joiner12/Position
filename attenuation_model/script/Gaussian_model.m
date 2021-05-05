%% 标准RSSI采用拟合的高斯分布的mu作为采样点对应RSSI;
%% HLK-{1,8} 分布数据获取

std_rssi_dist_HLKALL = {std_rssi_one_HLK_1; std_rssi_one_HLK_2; ...
                        std_rssi_one_HLK_3; std_rssi_one_HLK_4; ...
                        std_rssi_one_HLK_5; std_rssi_one_HLK_6; ...
                        std_rssi_one_HLK_7; std_rssi_one_HLK_8};

for k = 1:1:length(std_rssi_one_HLK_2)
    rssi = std_rssi_one_HLK_2{k}.RSSI;
    pd = fitdist(rssi, 'Normal')
    std_rssi_one_HLK_2{k}.gaussian_fit = pd;
    disp(pd.mu);
    disp(mean(rssi));
end

clearvars pd k j cur_ap gauss_data ans

%% 对比高斯分布均值和统计均值
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
    xlabel('距离/m')
    ylabel('RSSI/dB')
    legend({'正态分布均值', '统计均值'})
    title('正态分布均值vs统计均值')
    grid minor
    figname = sprintf('D:\\Code\\BlueTooth\\pos_bluetooth_matlab\\attenuation_model\\figure\\正态分布均值vs统计均值-HLK_%s.fig', ...
        num2str(k));
    pause(1);
end

%% 高斯分布整体对比
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

title('高斯分布均值不同AP对比')
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
title('统计均值不同AP对比')

clearvars pd k j cur_ap gauss_data ans f1


