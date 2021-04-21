%% ���Ʋ�������
%1�״�rssiֵ
% rssi_reference = -61.48;
rssi_reference = -50.06763;

%��γ����Чֵ
null_val = -10000;

%�켣ͼ���Ʒ�ʽ,֧�����·�ʽ��
%'splashes'������ɢ��ͼ
%'trajectory'�����ƹ켣ͼ
% draw_type = 'trajectory';
draw_type = 'splashes';

% ���ݳ�ʼ��
%��ȡ����λ����
files_data = data_import();

%��ʼ��1�״�rssiֵ��ʵ�ʹ������������ű�㲥������
files_data = init_rssi_reference(files_data, rssi_reference);

%��ȡ���ļ����ű����ݼ���ֵ
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, null_val);

%��ȡ��������
env_feat = tencent_lib_environment();

%��ȡ�ű���Ϣ
beacon = hlk_beacon_location();

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

%% ���嶨λ�������
% ���ƹ켣�����ͼ
%%
% position_error_statistics(position{1,1}.pos_res,  position{1,1}.true_pos);
% draw_trajectory_and_error_diagram(position, ...
%                                   null_val, ...
%                                   env_feat, ...
%                                   beacon, ...
%                                   draw_type, ...
%                                   'filter_point', ...
    %                                   filter_points);
tcf('dynamic')
figure('name', 'dynamic', 'color', 'w');
draw_positioning_state(gca, 'dynamic', debug{1, 1}.dynamic)
disp('��ͼ���')

%% write file to markdown file
% ![location-19](img/location-18.png)
% D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ������.md
clc;
fileId = fopen('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ������.md', 'w');
% <img src="img/location-14.png" alt="location-14" style="zoom:150%;" />
for k = 1:1:44
    fprintf(fileId, 'location error analysis-%s\n', num2str(k));
%     fprintf(fileId, sprintf('![location-%s](img/location-%s.png)\n\n', num2str(k), num2str(k)));
    fprintf(fileId, sprintf('<img src="img/location-%s.png" alt="location-%s" style="zoom:150%;" >\n\n', num2str(k), num2str(k)));
end

fclose(fileId);
