%% 蓝牙定位主程序，调试前需要添加相应文件夹及子文件夹到matlab路径中。
% matlab不能定位脚本文件，路径设置为绝对路径，使用前需要检查相关路径设置.
% D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model
% D:\Code\BlueTooth\pos_bluetooth_matlab\component
% D:\Code\BlueTooth\pos_bluetooth_matlab\data_import
% D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool
% D:\Code\BlueTooth\pos_bluetooth_matlab\Trilateration
% D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis
clc;
workspace_folder = 'D:\Code\BlueTooth\pos_bluetooth_matlab';
scripts_folder = {'attenuation_model', 'component', 'data_import', ...
                'MarkDownTool', 'Trilateration', 'data_analysis'};

for k = 1:length(scripts_folder)
    cur_folder = fullfile(workspace_folder, scripts_folder{k});
    addpath(genpath(cur_folder), '-end');
end

% 保存路径文件
% savepath matlab/myfiles/pathdef.m

%% 控制参数配置
clc;
tcf;
clear;
system_config = sys_config(); % 读取配置文件
[files_data, test_file_name] = data_import('datafile', ...
'D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6_15米-rename\P30.txt');

% 初始化1米处rssi值(实际工程中由蓝牙信标广播出来)
files_data = init_rssi_reference(files_data, -50.06763);

% 提取各文件的信标数据及真值
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, -10000);

file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
disp('数据初始化成功');

% 逐个文件处理
for i = 1:1:file_num
    t_main = tic();

    position{i}.true_pos = files_true_pos{i};

    true_pos_temp = position{i}.true_pos;
    % debug block
    save_process_pic = false;

    if save_process_pic
        % delete procession pictures
        markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
    end

    [position{i}.pos_res, debug{i}] = bluetooth_position(file_ap_msg{i}, ...
        'true_pos', true_pos_temp(1), 'save_process_pic', save_process_pic);

    filter_points{i} = debug{i}.centroid;

    % 静态分析
    if false
        draw_type = 'splashes';
        %获取环境特征
        env_feat = tencent_lib_environment();

        %获取信标信息
        beacon = hlk_beacon_location();

        if true
            % 测试数据头命名
            test_point_1_name = test_file_name{i};
            [dirname, filename, ext] = fileparts(test_point_1_name);
            regname = regexp(filename, '^P\d{1,}', 'match');
            position_error_statistics(position{i, 1}.pos_res, position{i, 1}.true_pos, ...
                'target_pic', ['D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-', ...
                    regname{1}, '-2.png'], ...
                'figure_visible', 'off', 'save_figure', true);

        end

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
    if false
        tcf('dynamic')
        f1 = figure('name', 'dynamic', 'color', 'w');
        % dynamic_point | dynamic_line
        draw_positioning_state(gca, 'dynamic_line', position{1}.pos_res)
        disp('绘图完成')
    end

    disp('定位处理结束');
    toc(t_main);
end

if true
    opts = struct('WindowStyle', 'modal', ...
        'Interpreter', 'tex');
    f = warndlg('\fontsize{15} \color{gray} this is a alert window', ...
        'this is a alert window', opts);
end
