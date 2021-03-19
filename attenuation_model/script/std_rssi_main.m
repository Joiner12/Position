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
noise_data_1 = get_std_dist_rssi_data('src_folder',...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data'...
    ,'ap_filter',{'A3','A7'});

noise_data_2 = get_std_dist_rssi_data('src_folder',...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data'...
    ,'ap_filter',{'A3','A7'});
%%
dist_a3_1 = zeros(0);
dist_a7_1 = zeros(0);
dist_a3_2 = zeros(0);
dist_a7_2 = zeros(0);

mean_vals_a3_1 = zeros(0);
mean_vals_a7_1 = zeros(0);
mean_vals_a3_2 = zeros(0);
mean_vals_a7_2 = zeros(0);
cnt_1 = 1;
cnt_2 = 1;

for i=1:1:length(noise_data_1)
    temp = noise_data_1{1,i};
    if strcmpi(temp.apInfo,'A3')
        mean_vals_a3_1(int8(temp.distance)) = mean(temp.RSSI);
        dist_a3_1(int8(temp.distance)) = temp.distance;
    end
    if strcmpi(temp.apInfo,'A7')
        mean_vals_a7_1(int8(temp.distance)) = mean(temp.RSSI);
        dist_a7_1(int8(temp.distance)) = temp.distance;
    end
end

for i=1:1:length(noise_data_2)
    temp = noise_data_2{1,i};
    if strcmpi(temp.apInfo,'A3')
        mean_vals_a3_2(int8(temp.distance/0.25)) = mean(temp.RSSI);
        dist_a3_2(int8(temp.distance/0.25)) = temp.distance;
    end
    if strcmpi(temp.apInfo,'A7')
        mean_vals_a7_2(int8(temp.distance/0.25)) = mean(temp.RSSI);
        dist_a7_2(int8(temp.distance/0.25)) = temp.distance;
    end
end
%%
tcf

figure('Color','w')
plot(dist_a3_1,mean_vals_a3_1,'-.');
hold on
plot(dist_a7_1,mean_vals_a7_1);
hold on
plot(dist_a3_2,mean_vals_a3_2,'-.');
hold on
plot(dist_a7_2,mean_vals_a7_2);
legend({'cur-a3','cur-a7','pre-a3','pre-a7'})
title 干扰对比测试
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

%%

