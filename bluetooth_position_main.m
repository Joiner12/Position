%% 清空工作环境
close all;
clc;
clear;

%% 添加工作路径
addpath('data_import', 'component', 'data_analysis');

%% 控制参数配置
%1米处rssi值
% rssi_reference = -61.48; 
rssi_reference = -50.06763; 

%经纬度无效值
null_val = -10000;

%轨迹图绘制方式,支持如下方式：
%'splashes'：绘制散点图
%'trajectory'：绘制轨迹图
% draw_type = 'trajectory'; 
draw_type = 'splashes'; 

%% 数据初始化
%读取待定位数据
files_data = data_import();

%初始化1米处rssi值（实际工程中由蓝牙信标广播出来）
files_data = init_rssi_reference(files_data, rssi_reference);

%提取各文件的信标数据及真值
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, null_val);

%获取环境特征
env_feat = tencent_lib_environment();

%获取信标信息
beacon = hlk_beacon_location();

disp('数据初始化成功');

%% 蓝牙定位
%初始化定位结果
file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);

%逐个文件处理
for i = 1:file_num
   [position{i}.pos_res, debug{i}] = bluetooth_position(file_ap_msg{i});
   position{i}.true_pos = files_true_pos{i};
   filter_points{i} = debug{i}.centroid;
end

disp('定位处理结束');

%% 整体定位结果分析
% 绘制轨迹及误差图

% draw_trajectory_and_error_diagram(position, ...
%                                   null_val, ...
%                                   env_feat, ...
%                                   beacon, ...
%                                   draw_type, ...
%                                   'filter_point', ...
%                                   filter_points);
