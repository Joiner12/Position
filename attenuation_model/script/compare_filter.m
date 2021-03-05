%% ��ͬ�˲���ʽ�Ա�
clc;
try
    load(['D:\Code\BlueTooth\pos_bluetooth_matlab\',...
        'attenuation_model\data\std_diss_splicing.mat']);
catch
end

%% ��ֵ�˲�
rssi_median = zeros(18,1);
for i = 1:1:18
    e_str = strcat('cm_',num2str(i));
    eval(['m_temp = median(',e_str,');']);
    rssi_median(i,1) = m_temp;
end
rssi_mean = mean_vals;

%% ���˹�˲�
clc;
rssi_gmfs = zeros(18,1);
for i=1:1:length(std_rssi_all)
    temp = std_rssi_all{i};
    temp = temp.rssi;
    gmf_temp = like_gaussian_filter(temp,2,'mean');
    rssi_gmfs(i,1) = gmf_temp;
end

% clearvars -except cm_* m_* kur* dist mean* rssi* ske* varian* std_*
%%
clc;
std_log10 = @(d) -53.32 - 15.32.*log10(d);
d = dist;
fd = std_log10(d);

tcf('filter')
figure('name','filter','Color',[1 1 1]);

plot_py(dist,rssi_gmfs,dist,rssi_mean,dist,rssi_median,d,fd)
legend({'��˹��ֵ�˲�','��ֵ�˲�','��ֵ�˲�','logarithmic'})
