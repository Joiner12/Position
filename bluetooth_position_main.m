%% 控制参数配置
clc;
clear;
% 经纬度无效值
null_val = -10000;
t_main = tic();

if true
    % 根据全站仪修改ap经纬度信息
    % [~, data_file] = modify_geoinfo();
    % 读取待定位数据
    data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6\', ...
                'P6-added_lat_lon.txt'];
    files_data = data_import('datafile', data_file);
else
    files_data = data_import();
end

% 初始化1米处rssi值（实际工程中由蓝牙信标广播出来）
files_data = init_rssi_reference(files_data, -50.06763);

% 提取各文件的信标数据及真值
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, null_val);

disp('数据初始化成功');

% 蓝牙定位
% 初始化定位结果
% 批量删除缓存文件
write_markdown_flag = false;

if write_markdown_flag
    markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
end

file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
%逐个文件处理
for i = 1:file_num
    [position{i}.pos_res, debug{i}] = bluetooth_position(file_ap_msg{i});

    if false
        position{i}.true_pos = files_true_pos{i};
    else
        cfg = get_config_debug();
        true_pos_manual = get_test_point(cfg(3).truepos);
        true_pos_temp = struct('lat', true_pos_manual{1}.lat, ...
            'lon', true_pos_manual{1}.lon);

        position{i}.true_pos = repmat(true_pos_temp, ...
            size(position{i}.pos_res, 1), size(position{i}.pos_res, 2));
    end

    filter_points{i} = debug{i}.centroid;

    if write_markdown_flag
        markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.html', ...
            'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
    end

end

toc(t_main);
% 静态分析
if true
    draw_type = 'splashes';
    %获取环境特征
    env_feat = tencent_lib_environment();

    %获取信标信息
    beacon = hlk_beacon_location();
    position_error_statistics(position{1, 1}.pos_res, position{1, 1}.true_pos);

    if false
        draw_trajectory_and_error_diagram(position, ...
            null_val, ...
            env_feat, ...
            beacon, ...
            draw_type, ...
            'filter_point', ...
            filter_points);
    end

end

%% 动态分析
if true
    tcf('dynamic')
    f1 = figure('name', 'dynamic', 'color', 'w');
    % dynamic_point | dynamic_line
    draw_positioning_state(gca, 'dynamic_line', position{1}.pos_res)
    disp('绘图完成')
    % figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\动态定位效果-2.png')
end

disp('定位处理结束');
