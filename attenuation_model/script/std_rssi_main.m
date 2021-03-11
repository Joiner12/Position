%%
clc;
%{
struct{
data;
info;
mean_val;
variance_val;
kurtosis_val;
skewness_val;
}
%}
mean_vals = zeros(18,1);
variance_vals = zeros(size(mean_vals));
kurtosis_vals = zeros(size(mean_vals));
skewness_vals = zeros(size(mean_vals));
std_rssi_all = cell(size(mean_vals));
for i=1:1:18
    cval = {};
    var_temp = strcat('cm_',num2str(i));
    cval.info = sprintf('distance:%.0f m',i);
    eval(['cval.rssi= ',var_temp,';']);
    eval(['[a,b,c,d]','= exhibit_std_rssi_analysis(',var_temp,');']);
    eval(['cval.mean_val','=a;']);
    eval(['cval.variance_val','=b;']);
    eval(['cval.kurtosis_val','=c;']);
    eval(['cval.skewness_val','=d;']);
    std_rssi_all{i} = cval;
    mean_vals(i,1) = a;
    variance_vals(i,1) = b;
    kurtosis_vals(i,1) = c;
    skewness_vals(i,1) = d;
end
dist = linspace(1,18,18);
clearvars -except cm_* m_* kur* dist mean* rssi* ske* varian* std_*


%% 单文件分析
clc;
for i=1:1:18
    tcf;
    var_temp = strcat('cm_',num2str(i));
    eval(['exhibit_std_rssi_analysis(',var_temp,');']);
    saveas(gcf,sprintf('std-rssi-test-%.0fm分析',i));
end
tcf;

%%
clearvars -except cm_* m_* kur* dist* mean* rssi* ske* varian* std_*

%% 将不同测量结果绘制到一张图上
clc;
lgds = cell(size(std_rssi_all));
tcf('fl');
figure('name','fl','Color',[1 1 1]);
markers = ['o','*','+','x','s','d','^','>','<','p','h'];
for i=1:1:length(std_rssi_all)
    curdata = std_rssi_all{i,1};
    info_temp = curdata.info;
    rssi_temp = curdata.rssi;
    plot(linspace(1,length(rssi_temp),length(rssi_temp)),...
        rssi_temp,'LineWidth',0.2,'MarkerSize',5,...
        'Marker',markers(randi(length(markers))),...
        'Color',rand(3,1));
    hold on
    lgds{i,1} = info_temp;
end
set(get(gca,'Title'),'String','不同距离信号强度时间序列（静态）')
set(get(gca,'XLabel'),'String','历元个数')
set(get(gca,'YLabel'),'String','RSSI/dB')
legend(lgds);

%%
clc;
src_folder = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\对数衰减模型标准测试HLK-DATA';
get_std_dist_rssi_info(src_folder,pwd,'');

%%
clc;
A3 = {HLK_0m_25cmA3,HLK_0m_50cmA3,HLK_0m_75cmA3,...
    HLK_1m_00cmA3,HLK_1m_25cmA3,HLK_1m_50cmA3,HLK_1m_75cmA3,...
    HLK_2m_00cmA3,HLK_2m_25cmA3,HLK_2m_50cmA3,HLK_2m_75cmA3,...
    HLK_3m_00cmA3,HLK_3m_25cmA3,HLK_3m_50cmA3,HLK_3m_75cmA3,...
    HLK_4m_00cmA3,HLK_4m_25cmA3,HLK_4m_50cmA3,HLK_4m_75cmA3,...
    HLK_5m_00cmA3,HLK_5m_25cmA3,HLK_5m_50cmA3,HLK_5m_75cmA3,...
    HLK_6m_00cmA3,HLK_6m_25cmA3,HLK_6m_50cmA3,HLK_6m_75cmA3,...
    HLK_7m_00cmA3,HLK_7m_25cmA3,HLK_7m_50cmA3,HLK_7m_75cmA3,...
    HLK_8m_00cmA3,HLK_8m_25cmA3,HLK_8m_50cmA3,HLK_8m_75cmA3,...
    HLK_9m_00cmA3,HLK_9m_25cmA3,HLK_9m_50cmA3,HLK_9m_75cmA3,...
    HLK_10m_00cmA3,HLK_10m_25cmA3,HLK_10m_50cmA3,HLK_10m_75cmA3,...
    HLK_11m_00cmA3,HLK_11m_25cmA3,HLK_11m_50cmA3,HLK_11m_75cmA3,...
    HLK_12m_00cmA3,HLK_12m_25cmA3,HLK_12m_50cmA3,HLK_12m_75cmA3,...
    HLK_13m_00cmA3,HLK_13m_25cmA3,HLK_13m_50cmA3,HLK_13m_75cmA3,...
    HLK_14m_00cmA3,HLK_14m_25cmA3,HLK_14m_50cmA3,HLK_14m_75cmA3,...
    HLK_15m_00cmA3,HLK_15m_25cmA3,HLK_15m_50cmA3,HLK_15m_75cmA3,...
    HLK_16m_00cmA3,HLK_16m_25cmA3,HLK_16m_50cmA3,HLK_16m_75cmA3,...
    HLK_17m_00cmA3,HLK_17m_25cmA3,HLK_17m_50cmA3,HLK_17m_75cmA3,...
    HLK_18m_00cmA3};

    A7 = {HLK_0m_25cmA7,HLK_0m_50cmA7,HLK_0m_75cmA7,...
    HLK_1m_00cmA7,HLK_1m_25cmA7,HLK_1m_50cmA7,HLK_1m_75cmA7,...
    HLK_2m_00cmA7,HLK_2m_25cmA7,HLK_2m_50cmA7,HLK_2m_75cmA7,...
    HLK_3m_00cmA7,HLK_3m_25cmA7,HLK_3m_50cmA7,HLK_3m_75cmA7,...
    HLK_4m_00cmA7,HLK_4m_25cmA7,HLK_4m_50cmA7,HLK_4m_75cmA7,...
    HLK_5m_00cmA7,HLK_5m_25cmA7,HLK_5m_50cmA7,HLK_5m_75cmA7,...
    HLK_6m_00cmA7,HLK_6m_25cmA7,HLK_6m_50cmA7,HLK_6m_75cmA7,...
    HLK_7m_00cmA7,HLK_7m_25cmA7,HLK_7m_50cmA7,HLK_7m_75cmA7,...
    HLK_8m_00cmA7,HLK_8m_25cmA7,HLK_8m_50cmA7,HLK_8m_75cmA7,...
    HLK_9m_00cmA7,HLK_9m_25cmA7,HLK_9m_50cmA7,HLK_9m_75cmA7,...
    HLK_10m_00cmA7,HLK_10m_25cmA7,HLK_10m_50cmA7,HLK_10m_75cmA7,...
    HLK_11m_00cmA7,HLK_11m_25cmA7,HLK_11m_50cmA7,HLK_11m_75cmA7,...
    HLK_12m_00cmA7,HLK_12m_25cmA7,HLK_12m_50cmA7,HLK_12m_75cmA7,...
    HLK_13m_00cmA7,HLK_13m_25cmA7,HLK_13m_50cmA7,HLK_13m_75cmA7,...
    HLK_14m_00cmA7,HLK_14m_25cmA7,HLK_14m_50cmA7,HLK_14m_75cmA7,...
    HLK_15m_00cmA7,HLK_15m_25cmA7,HLK_15m_50cmA7,HLK_15m_75cmA7,...
    HLK_16m_00cmA7,HLK_16m_25cmA7,HLK_16m_50cmA7,HLK_16m_75cmA7,...
    HLK_17m_00cmA7,HLK_17m_25cmA7,HLK_17m_50cmA7,HLK_17m_75cmA7,...
    HLK_18m_00cmA7};

hlk_mean_vals_A3 = zeros(0);
hlk_var_vals_A3 = zeros(0);
hlk_kur_vals_A3 = zeros(0);
hlk_ske_vals_A3 = zeros(0);

hlk_mean_vals_A7 = zeros(0);
hlk_var_vals_A7 = zeros(0);
hlk_kur_vals_A7 = zeros(0);
hlk_ske_vals_A7 = zeros(0);

for i = 1:1:length(A3)
    [mval,varval,kurval,skeval] = exhibit_std_rssi_analysis(A3{i});
    hlk_mean_vals_A3(i) = mval;
    hlk_var_vals_A3(i) = varval;
    hlk_kur_vals_A3(i) = kurval;
    hlk_ske_vals_A3(i) = skeval;
end

for i = 1:1:length(A7)
    [mval,varval,kurval,skeval] = exhibit_std_rssi_analysis(A7{i});
    hlk_mean_vals_A7(i) = mval;
    hlk_var_vals_A7(i) = varval;
    hlk_kur_vals_A7(i) = kurval;
    hlk_ske_vals_A7(i) = skeval;
end

%% 
figure('Color','w');
dist = 1:1:length(A7);
dist = dist.*0.25;
plot_py(dist,hlk_mean_vals_A3);
hold on
plot_py(dist,hlk_mean_vals_A7);
xlabel('距离/m')
ylabel('rssi/dB')
title('RSSI均值随距离变化关系')
legend({'AP:3';'AP:7'})