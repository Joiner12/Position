%% ���Ʋ�������
clc;
tcf;
clear;
system_config = sys_config(); % ��ȡ�����ļ�

if false
    % ����ȫվ���޸�ap��γ����Ϣ
    % [~, data_file] = modify_geoinfo();
    % ��ȡ����λ����
    data_file = system_config.origin_data_file;
    files_data = data_import('datafile', data_file);
else
    files_data = data_import();
end

% ��ʼ��1�״�rssiֵ��ʵ�ʹ������������ű�㲥������
files_data = init_rssi_reference(files_data, -50.06763);

% ��ȡ���ļ����ű����ݼ���ֵ
[file_ap_msg, files_true_pos] = extract_files_apmsg_truepos(files_data, -10000);

disp('���ݳ�ʼ���ɹ�');
file_num = length(files_data);
position = cell(file_num, 1);
filter_points = cell(file_num, 1);
debug = cell(file_num, 1);
%% ����ļ�����
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
        % markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ���̷���.html', ...
            %     'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
    end

    % ��̬����
    if true
        draw_type = 'splashes';
        %��ȡ��������
        env_feat = tencent_lib_environment();

        %��ȡ�ű���Ϣ
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

    %% ��̬����
    if false
        tcf('dynamic')
        f1 = figure('name', 'dynamic', 'color', 'w');
        % dynamic_point | dynamic_line
        draw_positioning_state(gca, 'dynamic_line', position{1}.pos_res)
        disp('��ͼ���')
        % figure2img(f1, 'D:\Code\BlueTooth\pos_bluetooth_matlab\��̬��λЧ��-2.png')
    end

    disp('��λ�������');
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
