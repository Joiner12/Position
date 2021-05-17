%% ���Ʋ�������
clc;
% ��γ����Чֵ
null_val = -10000;
% ����ȫվ���޸�ap��γ����Ϣ
modify_geoinfo();
% ��ȡ����λ����
files_data = data_import();

%��ʼ��1�״�rssiֵ��ʵ�ʹ������������ű�㲥������
files_data = init_rssi_reference(files_data, -50.06763);

%��ȡ���ļ����ű����ݼ���ֵ
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, null_val);

disp('���ݳ�ʼ���ɹ�');

%% ������λ
%��ʼ����λ���
file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
%����ļ�����
for i = 1:file_num
    [position{i}.pos_res, debug{i}] = bluetooth_position(file_ap_msg{i});
    position{i}.true_pos = files_true_pos{i};
    filter_points{i} = debug{i}.centroid;
end

disp('��λ�������');

%% ��̬����
if true

    draw_type = 'splashes';
    %��ȡ��������
    env_feat = tencent_lib_environment();

    %��ȡ�ű���Ϣ
    beacon = hlk_beacon_location();
    position_error_statistics(position{1, 1}.pos_res, position{1, 1}.true_pos);
    draw_trajectory_and_error_diagram(position, ...
        null_val, ...
        env_feat, ...
        beacon, ...
        draw_type, ...
        'filter_point', ...
        filter_points);

end

%% ��̬����
if true
    tcf('dynamic')
    f1 = figure('name', 'dynamic', 'color', 'w');
    draw_positioning_state(gca, 'dynamic_line', debug{1, 1}.dynamic)
    disp('��ͼ���')
    % figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\��̬��λЧ��-2.png')
end