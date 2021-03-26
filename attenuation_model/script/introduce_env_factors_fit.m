%% 引入环境因子参数进行拟合
%{
    根据标准模型测试所得1m处RSSI值和传感器参考RSSI(rssi_reference)值。
    将上述差作为环境因子()引入到拟合数据中。
    % 1.修改后半段曲线函数;
    % 2.调整拟合点位置;
%}
clc;
rssi_ref = -50.068.*ones(1,length(all_rssi_mean));
all_rssi_mean_offside = cell(size(all_rssi_mean));
env_factor = zeros(0);
for i=1:1:length(all_rssi_mean)
    cur_std_rssi = all_rssi_mean{i};
    offset = rssi_ref(i) - cur_std_rssi(1); % 环境因子
    env_factor(i) = offset;
    vartemp = strcat('m_RSSI_HLK_',num2str(i),'_offset');
    
    eval([vartemp,'=','cur_std_rssi + offset;']);
    eval(['all_rssi_mean_offset','{',num2str(i),'} = ',vartemp,';']);
end
%%
ds = linspace(1,18,18);
plot(ds,m_RSSI_HLK_1_offset)
hold on
plot(ds,m_RSSI_HLK_1)
legend({'offset','origin'})

%% 拟合结果检验
clc;
% AP_1 =  struct('Name','onepos_HLK_1',...
%     'param_less_rssi',[-31.03,2.424],...
%     'param_more_rssi',[-46.44,0.3551],...
%     'piecewise_rssi', -49.08);
all_apinfo_offset = {AP_1_offset,AP_2_offset,AP_3_offset,AP_4_offset,...
    AP_5_offset,AP_6_offset,AP_7_offset,AP_8_offset};
all_static_oneHLK = {static_one_HLK_1,static_one_HLK_2,static_one_HLK_3,...
    static_one_HLK_4,static_one_HLK_5,...
    static_one_HLK_6,static_one_HLK_7,static_one_HLK_8};
for i = 1:1:length(all_apinfo_offset)
    cur_ap = all_apinfo_offset{i};
    cur_static_one_HLK = all_static_oneHLK{i};
    mp_l = cur_ap.param_less_rssi; % rssi >= -50拟合结果:A=-46.44,n=0.36
    mp_m = cur_ap.param_more_rssi;
    piecewise_rssi = cur_ap.piecewise_rssi;
    rssi_test = cur_static_one_HLK{1}.RSSI;
    distance = calculate_distance_based_on_rssi_piecewise(mp_l,mp_m,rssi_test,piecewise_rssi);
    % 分析实际拟合效果
    % analysis_fit_model_piecewise(Am,bm,Al,bl,piecewise_rssi,rssi,true_dist,varargin)
    analysis_fit_model_piecewise(mp_m(1),mp_m(2),...
        mp_l(1),mp_l(2),...
        piecewise_rssi,rssi_test,10)
end

%%
clearvars -except std_rssi_one* m_RSSI_HLK_* all_rssi_mean* AP_* static_one* all_apinfo all_static_oneHLK rssi_ref