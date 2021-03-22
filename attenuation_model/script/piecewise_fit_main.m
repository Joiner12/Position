%% load data
clc;
% apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
std_rssi_one_HLK_8 = get_std_dist_rssi_data('src_folder',...
    'D:\Codes\Location\attenuation_model\data\8节点测试\8节点测试'...
    ,'ap_filter',{'HLK_8'});

clearvars -except std_rssi_one*
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
clearvars -except std_rssi_one* m_RSSI_HLK_* all_rssi_mean
save('std_rssi_onepos','std_rssi_one*','m_RSSI_HLK_*','all_rssi_mean')
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
    cur_rssi = all_rssi_mean{j};
    len_temp = length(cur_rssi);
    dist = linspace(1,len_temp,len_temp);
    fprintf('## AP:%.0f 拟合结果\n ### 分段RSSI:%.1f\n',j,cur_rssi(dist(dist==4)))
    create_logarithmic_model_fit(dist,cur_rssi','piecewise_rssi',cur_rssi(dist(dist==8)));
    fprintf('___________________\n');
end

%%
syms x;
fcof_1 = [ -40.99,1.411];
fcof_2 = [-16.68,3.724];
eq = power(10,(fcof_1(1)-x)/10/fcof_1(2)) == power(10,(fcof_2(1)-x)/10/fcof_2(2));
b = vpasolve(eq,x)