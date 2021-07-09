%%
clc;
% markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md', ...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
%%
clc;
fileId = fopen('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\temp.md', 'w');
fprintf(fileId, '**%s** \r\n', string(datetime('now')));
fclose(fileId);
%%
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\temp.mat');
distance = calc_distance_based_on_rssi(trilateration_ap(2));
disp(distance)

%%
clc;
A = [1, 3, 4, 5, 5]
[C, ia, ic] = unique(A)

%%
clc;
trilat_table = ap_selector(2:end, :);
trilat_table.CHARAC_ACT = zeros(size(trilat_table, 1), 1); % ap选择特征值[rssi信号稳定度]
trilat_table.CHARAC_MEAN = zeros(size(trilat_table, 1), 1); % ap选择特征值[RSSI均值排序]
trilat_table.CHARAC_VAR = zeros(size(trilat_table, 1), 1); % ap选择特征值[RSSI方差排序]
trilat_table.SELECT_WEIGHT = zeros(size(trilat_table, 1), 1); % ap输出权重
% trilat_table.CALCDIST = zeros(size(trilat_table.RECVRSSI)); % 节点信号接收RSSI序列
% trilat_table.MEANVAL = zeros(size(trilat_table, 1), 1); % RSSI均值
% trilat_table.VARVAL = zeros(size(trilat_table, 1), 1); % RSSI方差

for k = 1:size(trilat_table, 1)
    rssi_s = trilat_table.RECVRSSI(k, :);
    cur_rssi = rssi_s(rssi_s ~= 0);
    trilat_table.CHARAC_ACT(k) = ceil(length(cur_rssi) / 2);
    trilat_table.CHARAC_MEAN(k) = mean(cur_rssi);
    trilat_table.CHARAC_VAR(k) = var(cur_rssi);
end

% mean sort character
gen_index_mean = 1:1:length(trilat_table.CHARAC_MEAN);
[~, charac_mean_index] = maxk(trilat_table.CHARAC_MEAN, 5);

for k1 = 1:length(charac_mean_index)
    trilat_table.CHARAC_MEAN(charac_mean_index(k1)) = length(charac_mean_index) + 1 - k1;
end

trilat_table.CHARAC_MEAN(gen_index_mean(~ismember(gen_index_mean, charac_mean_index))) = 0;
% variance sort character
gen_index_var = 1:1:length(trilat_table.CHARAC_VAR);
[~, charac_var_index] = mink(trilat_table.CHARAC_VAR, 5);

for k2 = 1:length(charac_var_index)
    trilat_table.CHARAC_VAR(charac_var_index(k2)) = length(charac_var_index) + 1 - k2;
end

trilat_table.CHARAC_VAR(gen_index_var(~ismember(gen_index_var, charac_var_index))) = 0;

% 神经元
charac_weight = [0.3, 0.6, 0.1]; % 特征值权重
charc_temp = [trilat_table.CHARAC_ACT, trilat_table.CHARAC_MEAN, trilat_table.CHARAC_VAR];
trilat_table.SELECT_WEIGHT = charc_temp * charac_weight';
