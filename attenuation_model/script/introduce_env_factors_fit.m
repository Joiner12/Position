%% 引入环境因子参数进行拟合
%{
    根据标准模型测试所得1m处RSSI值和传感器参考RSSI(rssi_reference)值。
    将上述差作为环境因子()引入到拟合数据中。
%}
clc;
rssi_ref = -50.068.*ones(1,length(all_rssi_mean));
all_rssi_mean_offside = cell(size(all_rssi_mean));
env_factor = zeros(0);
for i=1:1:length(all_rssi_mean)
    cur_std_rssi = all_rssi_mean{i};
    offset = rssi_ref(i) - cur_std_rssi(1); % 环境因子
    env_factor(i) = offset;
    vartemp = strcat('m_RSSI_HLK_',num2str(i),'_offside');
    
    eval([vartemp,'=','cur_std_rssi-offset;']);
    eval(['all_rssi_mean_offside','{',num2str(i),'} = ',vartemp,';']);
end
%% 
ds = linspace(1,18,18);
plot(ds,m_RSSI_HLK_1_offside)
hold on
plot(ds,m_RSSI_HLK_1)
legend({'f','o'})
%%
clearvars -except std_rssi_one* m_RSSI_HLK_* all_rssi_mean* AP_* static_one* all_apinfo all_static_oneHLK rssi_ref