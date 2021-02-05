%% 清空工作环境
close all;
clc;
clear;

%% 添加工作路径
addpath('data_import', 'component');

%% 数据初始化
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

disp('数据导入成功');

%% 蓝牙定位处理
%初始化定位结果
file_num = length(files_data);
position = cell(file_num, 1);

%逐个文件处理
for i = 1:file_num
% file_num = 31;
% for i = file_num:file_num
   position{i}.pos_res = bluetooth_position(files_data{i});
   
   position{i}.true_valu = true_location{i};
   
   disp(['第', num2str(i), '个文件的数据定位结束']);
end

disp('定位处理结束');

%% 定位结果分析
success_flag = 1;
for i = 1:file_num
% for i = file_num:file_num
    true_num = size(position{i}.true_valu, 1);
    pos_num = size(position{i}.pos_res, 2);
    if true_num ~= pos_num
        error(['第', num2str(i), '个文件的结果个数不对']);
    end
    
    for j = 1:length(position{i}.true_valu)
%         disp(['比较第', num2str(i), '个文件第', num2str(j), '帧数据']);
        lat_error = abs((position{i}.true_valu(j, 1) - position{i}.pos_res{j}.lat) / position{i}.true_valu(j, 1));
        lon_error = abs((position{i}.true_valu(j, 2) - position{i}.pos_res{j}.lon) / position{i}.true_valu(j, 2));
        if lat_error > 1e-14 || lon_error > 1e-14
            success_flag = 0;
            warning(['文件', num2str(i), '中第', num2str(j), '帧数据结果不对']);
        end
    end
end

if success_flag
    disp('定位结果正确');
end

