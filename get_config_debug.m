function config_value = get_config_debug(varargin)
    % ������
    %       �ⲿ�����ļ����������
    % ���壺
    %       function get_config_debug(config_name, varargin)
    % ���룺
    %       config_name,��������
    % �����
    %       config_value,������

    %
    config_s = struct();
    config_s(1).config_name = 'true_pos_index_1';
    config_s(1).config_value = 1;
    % markdown file - 1
    config_s(2).config_name = 'markdown_file_1';
    config_s(2).config_value = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ���̷���.md';
    % markdown file - 2
    config_s(2).config_name = 'markdown_file_2';
    config_s(2).config_value = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\����̬��λ�������.md';

    config_s(3).truepos = 'P1';
    config_value = config_s;
end
