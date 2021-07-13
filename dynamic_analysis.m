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

