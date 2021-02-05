%% ��չ�������
close all;
clc;
clear;

%% ��ӹ���·��
addpath('data_import', 'component');

%% ���ݳ�ʼ��
% files_data = data_import();
num = 31;
files_data = cell(num, 1);
true_location = cell(num, 1);
for i = 1:31
    src = ['data/src_', num2str(i), '.mat'];
    dst = ['data/dst_', num2str(i), '.mat'];
    load(src);
    load(dst);
    
    files_data{i} = rssi;
    true_location{i} = filterPosOut1;
end

for i = 1:length(files_data)
    for j = 1:length(files_data{i})
        for k = 1:length(files_data{i}{j})
            files_data{i}{j}(k).name = 'HLK-OnePos';
        end
    end
end

disp('���ݵ���ɹ�');

%% ������λ����
%��ʼ����λ���
file_num = length(files_data);
position = cell(file_num, 1);

%����ļ�����
for i = 1:file_num
% file_num = 31;
% for i = file_num:file_num
   position{i}.pos_res = bluetooth_position(files_data{i});
   
   position{i}.true_valu = true_location{i};
   
   disp(['��', num2str(i), '���ļ������ݶ�λ����']);
end

disp('��λ�������');

%% ��λ�������
success_flag = 1;
for i = 1:file_num
% for i = file_num:file_num
    true_num = size(position{i}.true_valu, 1);
    pos_num = size(position{i}.pos_res, 2);
    if true_num ~= pos_num
        error(['��', num2str(i), '���ļ��Ľ����������']);
    end
    
    for j = 1:length(position{i}.true_valu)
%         disp(['�Ƚϵ�', num2str(i), '���ļ���', num2str(j), '֡����']);
        lat_error = abs((position{i}.true_valu(j, 1) - position{i}.pos_res{j}.lat) / position{i}.true_valu(j, 1));
        lon_error = abs((position{i}.true_valu(j, 2) - position{i}.pos_res{j}.lon) / position{i}.true_valu(j, 2));
        if lat_error > 1e-14 || lon_error > 1e-14
            success_flag = 0;
            warning(['�ļ�', num2str(i), '�е�', num2str(j), '֡���ݽ������']);
        end
    end
end

if success_flag
    disp('��λ�����ȷ');
end

