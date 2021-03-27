%% ��չ�������
close all;
clc;
clear;

%% ��ӹ���·��
addpath('data_import', 'component', 'data_analysis');

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

%% ���ݳ�ʼ��
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

% draw_trajectory_and_error_diagram(position, ...
%                                   null_val, ...
%                                   env_feat, ...
%                                   beacon, ...
%                                   draw_type, ...
%                                   'filter_point', ...
%                                   filter_points);
