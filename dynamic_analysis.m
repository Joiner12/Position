%%
clc;
% markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md', ...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
%%
% get_config_debug('markdown_file_1')
config_s = table();
config_s.config_name(1) = 'true_pos_index_1';
config_s.config_value(1) = 1;
% markdown file - 1
config_s.config_name(2) = 'markdown_file_1';
config_s.config_value(2) = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md';
% markdown file - 2
config_s.config_name(3) = 'markdown_file_2';
config_s(3).config_value(3) = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\动静态定位结果分析.md';
config_names = config_s.config_name;
b = 2;
%index = strcmpi(fieldnames(config_s), config_name);

%% 对比分析相同位置静态条件下RSSI变化情况
clc;
rssi_data_1_new = struct();
rssi_data_1 = struct();
ap_filter = {'ope_1', 'ope_2', 'ope_3', 'ope_4', 'ope_5', 'ope_6'};

for j = 1:length(ap_filter)
    rssi_data_1(j).name = ap_filter{j};
    rssi_data_1(j).rssi = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab', ...
                                        '\data\ope单信道-ch39测试\static-1.txt'], ...
        ap_filter{j});
end

for k = 1:length(ap_filter)
    rssi_data_1_new(k).name = strcat(ap_filter{k}, 'new');
    rssi_data_1_new(k).rssi = get_rssi_info(['D:\Code\BlueTooth\pos_bluetooth_matlab', ...
                                            '\data\ope单信道-ch39测试\static-1-new.txt'], ...
        ap_filter{k});
end

tcf('test-1');
figure('name', 'test-1', 'color', 'w');
index = 0;
subplot(3, 2, 1) % ope_1
index = index + 1;
plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
subplot(3, 2, 2) % ope_1
index = index + 1;

plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
subplot(3, 2, 3) % ope_1
index = index + 1;

plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
subplot(3, 2, 4) % ope_1
index = index + 1;

plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
subplot(3, 2, 5) % ope_1
index = index + 1;

plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
subplot(3, 2, 6) % ope_1
index = index + 1;

plot(rssi_data_1(index).rssi, 'marker', '.');
hold on
plot(rssi_data_1_new(index).rssi, 'marker', '.');
legend(rssi_data_1(index).name, rssi_data_1_new(index).name)
title(strcat('ope-', num2str(index)));
%%
clc;
show_figure()
