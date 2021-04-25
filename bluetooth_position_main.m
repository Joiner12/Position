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

% 数据初始化
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
f1 = figure('name', 'dynamic', 'color', 'w');
draw_positioning_state(gca, 'dynamic_line', debug{1, 1}.dynamic)
disp('绘图完成')
figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\动态定位效果-2.png')
