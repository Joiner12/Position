%% load data
clc;
% apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
std_rssi_one_HLK_8 = get_std_dist_rssi_data('src_folder',...
    'D:\Codes\Location\attenuation_model\data\8节点测试\8节点测试'...
    ,'ap_filter',{'HLK_8'});
%% 提取静态测试单个位置结果
clc;
static_one_HLK_1 = get_std_dist_rssi_data('src_folder',...
    '../data'...
    ,'ap_filter',{'HLK_1'});
%%
%
clc;
model_parameter_1 = [-31.03,2.424]; % rssi >= -50拟合结果:A=-46.44,n=0.36
model_parameter_2 = [-46.44,0.3551];
piecewise_rssi = -49.08;
rssi_test = static_one_HLK_1{1}.RSSI;
distance = calculate_distance_based_on_rssi_piecewise(...
    model_parameter_1,model_parameter_2,rssi_test,piecewise_rssi);
% 
figure('name','hey','Color','w');
scatter_py(rssi_test,distance);
% 分析实际拟合效果
analysis_fit_model_piecewise(model_parameter_1(1),model_parameter_1(2),...
    model_parameter_2(1),model_parameter_2(2),...
    piecewise_rssi,rssi_test,8)

%%
all_rssi_mean = cell(0);
for i=1:1:8
    var_str = strcat('m_RSSI_HLK_',num2str(i));
    eval(['[',var_str,',~,~,~]',...
        strcat('=get_global_std_statistics(std_rssi_one_HLK_',num2str(i)),');']);
    eval(['rssi_temp = ',var_str])
    %     rssi_temp =
    all_rssi_mean{i,1} = rssi_temp;
end

%% save data
clearvars -except std_rssi_one* m_RSSI_HLK_* all_rssi_mean AP_*
save('std_rssi_onepos','std_rssi_one*','m_RSSI_HLK_*','all_rssi_mean','AP_*')
%% figure - 1
clc;
tcf('ss');
figure('Name','ss','Color','w')
len_temp = length(m_RSSI_HLK_1);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_1,'Marker','*',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_2);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_2 + m_RSSI_HLK_1(1)-m_RSSI_HLK_2(1),'Marker','o',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_3);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_3 + m_RSSI_HLK_1(1)-m_RSSI_HLK_3(1),'Marker','+',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_4);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_4 + m_RSSI_HLK_1(1)-m_RSSI_HLK_4(1),'Marker','x',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_5);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_5 + m_RSSI_HLK_1(1)-m_RSSI_HLK_5(1),'Marker','s',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_6);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_6 + m_RSSI_HLK_1(1)-m_RSSI_HLK_6(1),'Marker','d',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_7);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_7 + m_RSSI_HLK_1(1)-m_RSSI_HLK_7(1),'Marker','^',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_8);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_8 + m_RSSI_HLK_1(1)-m_RSSI_HLK_8(1),'Marker','v',...
    'LineWidth',1.5);
title({'HLK1~HLK8:距离-RSSI手动调整测试结果对比','RSSI = -10lg(d/d_0)+C+\Delta'})
grid minor
apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
legend(apfilter)
xlabel('距离/m');
ylabel('rssi/dB');
grid on

%% piecewise curve fitting
clc;
tcf;
for j =1:1:length(all_rssi_mean)
% for j =1:1:1
    cur_rssi = all_rssi_mean{j};
    len_temp = length(cur_rssi);
    dist = linspace(1,len_temp,len_temp);
    fprintf('## AP:%.0f 拟合结果\n ### 分段RSSI:%.1f\n',j,cur_rssi(dist(dist==4)))
    create_logarithmic_model_fit(dist,cur_rssi','piecewise_rssi',cur_rssi(dist(dist==8)));
    fprintf('___________________\n');
end
