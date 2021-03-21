%% load data
clc;
% apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
std_rssi_one_HLK_8 = get_std_dist_rssi_data('src_folder',...
    'D:\Codes\Location\attenuation_model\data\8节点测试\8节点测试'...
    ,'ap_filter',{'HLK_8'});

clearvars -except std_rssi_one*

for i=1:1:8
    var_str = strcat('m_HLK_',num2str(i));
    eval(['[',var_str,',~,~,~]',...
        strcat('=get_global_std_statistics(std_rssi_one_HLK_',num2str(i)),')']);
end
clearvars -except std_rssi_one* m_HLK_*

%% figure
clc;
tcf('ss');
figure('Name','ss','Color','w')
len_temp = length(m_HLK_1);
plot(linspace(1,len_temp,len_temp),m_HLK_1,'Marker','*',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_2);
plot(linspace(1,len_temp,len_temp),m_HLK_2 + m_HLK_1(1)-m_HLK_2(1),'Marker','o',...
    'LineWidth',1.5);       
hold on
len_temp = length(m_HLK_3);
plot(linspace(1,len_temp,len_temp),m_HLK_3 + m_HLK_1(1)-m_HLK_3(1),'Marker','+',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_4);
plot(linspace(1,len_temp,len_temp),m_HLK_4 + m_HLK_1(1)-m_HLK_4(1),'Marker','x',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_5);
plot(linspace(1,len_temp,len_temp),m_HLK_5 + m_HLK_1(1)-m_HLK_5(1),'Marker','s',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_6);
plot(linspace(1,len_temp,len_temp),m_HLK_6 + m_HLK_1(1)-m_HLK_6(1),'Marker','d',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_7);
plot(linspace(1,len_temp,len_temp),m_HLK_7 + m_HLK_1(1)-m_HLK_7(1),'Marker','^',...
    'LineWidth',1.5);
hold on
len_temp = length(m_HLK_8);
plot(linspace(1,len_temp,len_temp),m_HLK_8 + m_HLK_1(1)-m_HLK_8(1),'Marker','v',...
    'LineWidth',1.5);
title('HLK1~HLK8:距离-RSSI测试结果对比')
grid minor
apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
legend(apfilter)
xlabel('距离/m');
ylabel('rssi/dB');
grid minor
clearvars -except std_rssi_one* m_HLK_*