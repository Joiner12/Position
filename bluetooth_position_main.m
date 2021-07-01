%% ���Ʋ�������
clc;
clear;
% ��γ����Чֵ
null_val = -10000;

if false
    % ����ȫվ���޸�ap��γ����Ϣ
    [~, data_file] = modify_geoinfo();
    % ��ȡ����λ����
    files_data = data_import('datafile', data_file);
else
    files_data = data_import();
end

% ��ʼ��1�״�rssiֵ��ʵ�ʹ������������ű�㲥������
files_data = init_rssi_reference(files_data, -50.06763);

% ��ȡ���ļ����ű����ݼ���ֵ
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

    if false
        position{i}.true_pos = files_true_pos{i};
    else
        % lat:30.5479692317,lon:104.0585915092 static-1
        % lat:30.5479705577,lon:104.0586741723 static-2
        % lat:30.5479727197,lon:104.0587717089 static-3
        true_pos_manual = [30.5479692317, 104.0585915092; ...
                            30.5479705577, 104.0586741723; ...
                            30.5479727197, 104.0587717089];
        true_pos_temp = struct('lat', true_pos_manual(3, 1), 'lon', true_pos_manual(3, 2));

        position{i}.true_pos = repmat(true_pos_temp, ...
            size(position{i}.pos_res, 1), size(position{i}.pos_res, 2));
    end

    filter_points{i} = debug{i}.centroid;
end

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
    % dynamic_point | dynamic_line
    draw_positioning_state(gca, 'dynamic_line', position{1}.pos_res)
    disp('��ͼ���')
    % figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\��̬��λЧ��-2.png')
end

disp('��λ�������');

