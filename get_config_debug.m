function config_value = get_config_debug(config_name, varargin)
    % 函数：
    %       外部配置文件，方便调试
    % 定义：
    %       function get_config_debug(config_name, varargin)
    % 输入：
    %       config_name,配置名称
    % 输出：
    %       config_value,配置量

    %
    config_s = struct();
    config_s(1).config_name = 'true_pos_index_1';
    config_s(1).config_value = 1;
    % markdown file - 1
    config_s(2).config_name = 'markdown_file_1';
    config_s(2).config_value = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md';
    % markdown file - 2
    config_s(2).config_name = 'markdown_file_2';
    config_s(2).config_value = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\动静态定位结果分析.md';

    index = strcmpi(fieldnames(config_s), config_name);
    b = config_s(index);
    b = 1;
end
