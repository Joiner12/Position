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

%% 整体统计分析;
figure('name','norm-analysis','Color',[1 1 1]);

subplot(2,2,1)
plot_py(dist,mean_vals)
set(get(gca, 'Title'), 'String', '均值随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB');

subplot(2,2,2)
plot_py(dist,variance_vals)
set(get(gca, 'Title'), 'String', '方差随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'rssi/dB^2');

subplot(2,2,3)
plot_py(dist,kurtosis_vals);
set(get(gca, 'Title'), 'String', '峰度随距离变化趋势');
hold on
plot_py([1 18],[3 3]);
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '峰度');
legend({'测试样本峰度','正态分布峰度'})

subplot(2,2,4)
plot_py(dist,skewness_vals)
hold on
plot_py([1,18],[0,0])
set(get(gca, 'Title'), 'String', '偏度随距离变化趋势');
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '偏度');
legend({'测试样本偏度','正态分布偏度(0偏度)'})

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

%% 分段拟合
clc;
dist_1 = dist(1:5);
dist_2 = dist(6:end);
rssi_1 = rssi_gmfs(1:5);
rssi_2 = rssi_gmfs(6:end);

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