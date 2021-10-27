%% 控制参数配置
clc;
tcf;
clear;
system_config = sys_config(); % 读取配置文件
[files_data, test_file_name] = data_import();

% 初始化1米处rssi值（实际工程中由蓝牙信标广播出来）
files_data = init_rssi_reference(files_data, -50.06763);

% 提取各文件的信标数据及真值
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, -10000);

disp('数据初始化成功');
file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
% return;
% 逐个文件处理
for i = 1:1:file_num
    t_main = tic();

    position{i}.true_pos = files_true_pos{i};

    true_pos_temp = position{i}.true_pos;
    % debug block
    save_process_pic = true;

    if save_process_pic
        % delete procession pictures
        markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
    end

    [position{i}.pos_res, debug{i}] = bluetooth_position(file_ap_msg{i}, ...
        'true_pos', true_pos_temp(1), 'save_process_pic', save_process_pic);

    filter_points{i} = debug{i}.centroid;

    if save_process_pic
        system(['python', ' ', ...
                'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\MarkDownProcess.py']);
    end

    % 静态分析
    if true
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
                    regname{1}, '-2L.png'], ...
                'figure_visible', 'on', 'save_figure', false);

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

if false
    system(['python', ' ' ...
            'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\PositionMarkdown_Static.py']);
end

%% switch schemer
% schemer_import('solarized-light.prf');
% schemer_import('darksteel.prf');
