
clc;
src_folder = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\对数衰减模型标准测试HLK-DATA';
get_std_dist_rssi_info(src_folder,pwd,'');
%% 
overall_statistical_analysis(dist,hlk_mean_vals_A7,...
    hlk_var_vals_A7,hlk_kur_vals_A7,hlk_ske_vals_A7)
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

%%
clc;
leaveUnow = get_std_dist_rssi_data('src_folder',...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\对数衰减模型标准测试HLK-DATA'...
    ,'ap_filter',{'A3','A7'});

%% 
clc;
model_log = create_logarithmic_model_fit(dist,hlk_mean_vals_A7,'piecewise_rssi',-50);

%% 
% a =      -41.43  (-43.22, -39.64)
% b =      -1.445  (-1.638, -1.252)
clc;
analysis_fit_model_normal(-25.59,3.038,HLK_18m_00cmA7,18);

%%
% -39.29  1.6
% -12 4.282 
clc;
a = [-39.29,-12];
b = [1.6 4.282];
analysis_fit_model_piecewise(a(1),b(1),a(2),b(2),-50,HLK_1m_00cmA7,1)
