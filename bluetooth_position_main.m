%% 控制参数配置
clc;
tcf;
clear;
system_config = sys_config(); % 读取配置文件

if false
    % 根据全站仪修改ap经纬度信息
    % [~, data_file] = modify_geoinfo();
    % 读取待定位数据
    data_file = system_config.origin_data_file;
    files_data = data_import('datafile', data_file);
else
    files_data = data_import();
end

% 初始化1米处rssi值（实际工程中由蓝牙信标广播出来）
files_data = init_rssi_reference(files_data, -50.06763);

% 提取各文件的信标数据及真值
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, -10000);

disp('数据初始化成功');
file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
%% 逐个文件处理
for i = 1:1:file_num
    t_main = tic();

    if true
        position{i}.true_pos = files_true_pos{i};
    else
        true_pos_temp = struct('lat', system_config.cur_true_pos.lat, ...
            'lon', system_config.cur_true_pos.lon);
        position{i}.true_pos = repmat(true_pos_temp, ...
            size(position{i}.pos_res, 1), size(position{i}.pos_res, 2));
    end

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

    if save_process_pic
        system(['python',' ' , ...
                'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\MarkDownProcess.py']);
        % markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.html', ...
            %     'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
    end

    % 静态分析
    if true
        draw_type = 'splashes';
        %获取环境特征
        env_feat = tencent_lib_environment();

        %获取信标信息
        beacon = hlk_beacon_location();

        if true
            test_point_1_name = {'P0', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', ...
                                'P11', 'P12', 'P13', 'P14', ...
                                'P15', 'P16', 'P17', 'P18', 'P19', 'P20', 'P21', ...
                                'P22', 'P23', 'P24', 'P25'};

            if false
                position_error_statistics(position{i, 1}.pos_res, position{i, 1}.true_pos, ...
                    'figure_visible', 'on');
            else
                position_error_statistics(position{i, 1}.pos_res, position{i, 1}.true_pos, ...
                    'target_pic', ['D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-', ...
                        test_point_1_name{i}, '-2.png'], ...
                    'figure_visible', 'off');
            end

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
        % figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\动态定位效果-2.png')
    end

    disp('定位处理结束');
    toc(t_main);
end

if true
    system(['python',' ' ...
            'D:\Code\BlueTooth\pos_bluetooth_matlab\MarkDownTool\PositionMarkdown_Static.py']);
end
%% 
if true
    debegshow();
end

%% switch schemer
% schemer_import('solarized-light.prf');
% schemer_import('darksteel.prf');
