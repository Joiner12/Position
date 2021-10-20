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
filename = 'testdata.xlsx';
test_point_1_name = {'P0', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', ...
                    'P11', 'P12', 'P13', 'P14', ...
                    'P15', 'P16', 'P17', 'P18', 'P19', 'P20', 'P21', ...
                    'P22', 'P23', 'P24', 'P25'};

for k = 1:1:22
    sheet = test_point_1_name{k};
    % filename = ['testdata-', test_point_1_name{k}, '.xlsx'];
    temp = position{k}.true_pos;
    temp_lat = cell(0);
    temp_lon = cell(0);
    temp_lat{1} = 'true_lat';
    temp_lon{1} = 'true_lon';

    for i_1 = 1:length(temp)
        temp_lat{length(temp_lat) + 1} = temp(i_1).lat;
        temp_lon{length(temp_lon) + 1} = temp(i_1).lon;
    end

    if true
        xlswrite(filename, temp_lat', sheet, 'A');
        xlswrite(filename, temp_lon', sheet, 'B');
    end

    temp_1 = position{k}.pos_res;
    temp_1_lat = cell(0);
    temp_1_lon = cell(0);
    temp_1_lat{1} = 'res_lat';
    temp_1_lon{1} = 'res_lon';

    for i_2 = 1:length(temp_1)
        temp_1_lat{length(temp_1_lat) + 1} = temp_1{i_2}.lat;
        temp_1_lon{length(temp_1_lon) + 1} = temp_1{i_2}.lon;
    end

    if true
        xlswrite(filename, temp_1_lat', sheet, 'C');
        xlswrite(filename, temp_1_lon', sheet, 'D');
    end

end

%%
system(['python ', ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\test.py']);

if true
    system(['python ', ...
            'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\PositionMarkdown_Static.py']);
end

%%
clc;
test_point_1_name = test_file_name{21};
[dirname, filename, ext] = fileparts(test_point_1_name);
regexp(filename, '^P\d{1,}', 'match')
