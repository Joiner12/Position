%%
clc;
data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\7x7静态测试数据-1\', ...
            'static-P1-1.txt'];
files_data = data_import('datafile', data_file);
files_data = init_rssi_reference(files_data, -50.06763);
[file_ap_msg, ~] = extract_files_apmsg_truepos(files_data, 10000);
file_ap_msg = file_ap_msg{1}; % 单文件数据
ope_0 = cell([2, 1]);
ope_1 = cell([2, 1]);
ope_6 = cell([2, 1]);
ope_7 = cell([2, 1]);
ope_8 = cell([2, 1]);
ope_9 = cell([2, 1]);

for k = 1:length(file_ap_msg)
    % 整合相同的ap数据
    cur_frame_ap = file_ap_msg{k};
    config = sys_config();
    cur_frame_ap = prev_data_redcution_integrate_same_ap(cur_frame_ap, ...
        config.integrate_same_ap_param);

    for j = 1:length(cur_frame_ap)
        rssi_draw = cur_frame_ap(j).recv_rssi;
        x_draw = linspace(1, length(rssi_draw), length(rssi_draw)) + (k - 1) * 10;

        if strcmpi(cur_frame_ap(j).name, 'ope_0')
            temp = ope_0{1, 1};
            temp = [temp, rssi_draw];
            ope_0{1, 1} = temp;
            temp = ope_0{2, 1};
            temp = [temp, x_draw];
            ope_0{2, 1} = temp;
        end

        if strcmpi(cur_frame_ap(j).name, 'ope_1')
            temp = ope_1{1, 1};
            temp = [temp, rssi_draw];
            ope_1{1, 1} = temp;
            temp = ope_1{2, 1};
            temp = [temp, x_draw];
            ope_1{2, 1} = temp;
        end

        if strcmpi(cur_frame_ap(j).name, 'ope_6')
            temp = ope_6{1, 1};
            temp = [temp, rssi_draw];
            ope_6{1, 1} = temp;
            temp = ope_6{2, 1};
            temp = [temp, x_draw];
            ope_6{2, 1} = temp;
        end

        if strcmpi(cur_frame_ap(j).name, 'ope_7')
            temp = ope_7{1, 1};
            temp = [temp, rssi_draw];
            ope_7{1, 1} = temp;
            temp = ope_7{2, 1};
            temp = [temp, x_draw];
            ope_7{2, 1} = temp;
        end

        if strcmpi(cur_frame_ap(j).name, 'ope_8')
            temp = ope_8{1, 1};
            temp = [temp, rssi_draw];
            ope_8{1, 1} = temp;
            temp = ope_8{2, 1};
            temp = [temp, x_draw];
            ope_8{2, 1} = temp;
        end

        if strcmpi(cur_frame_ap(j).name, 'ope_9')
            temp = ope_9{1, 1};
            temp = [temp, rssi_draw];
            ope_9{1, 1} = temp;
            temp = ope_9{2, 1};
            temp = [temp, x_draw];
            ope_9{2, 1} = temp;
        end

    end

end

%%
tcf('frame-data');
figure('name', 'frame-data', 'color', 'white');
hold on
%{
scatter(ope_0{2, 1}, ope_0{1, 1}, 'filled', ...
    'MarkerEdgeColor', [101, 207, 213] ./ 255, 'MarkerFaceColor', [101, 207, 213] ./ 255);
scatter(ope_1{2, 1}, ope_1{1, 1}, 'filled', ...
    'MarkerEdgeColor', [120, 213, 101] ./ 255, 'MarkerFaceColor', [120, 213, 101] ./ 255);
scatter(ope_6{2, 1}, ope_6{1, 1}, 'filled', ...
    'MarkerEdgeColor', [197, 213, 101] ./ 255, 'MarkerFaceColor', [197, 213, 101] ./ 255);
scatter(ope_7{2, 1}, ope_7{1, 1}, 'filled', ...
    'MarkerEdgeColor', [213, 154, 101] ./ 255, 'MarkerFaceColor', [213, 154, 101] ./ 255);
scatter(ope_8{2, 1}, ope_8{1, 1}, 'filled', ...
    'MarkerEdgeColor', [67, 94, 190] ./ 255, 'MarkerFaceColor', [67, 94, 190] ./ 255);
scatter(ope_9{2, 1}, ope_9{1, 1}, 'filled', ...
    'MarkerEdgeColor', [189, 67, 190] ./ 255, 'MarkerFaceColor', [189, 67, 190] ./ 255);
%}
plot(ope_0{2, 1}, ope_0{1, 1}, 'Marker', '*');
plot(ope_1{2, 1}, ope_1{1, 1}, 'Marker', 'o');
plot(ope_6{2, 1}, ope_6{1, 1}, 'Marker', 'd');
plot(ope_7{2, 1}, ope_7{1, 1}, 'Marker', '<');
plot(ope_8{2, 1}, ope_8{1, 1}, 'Marker', 'x');
plot(ope_9{2, 1}, ope_9{1, 1}, 'Marker', '^');
hold off
legend({'ope_0', 'ope_1', 'ope_6', 'ope_7', 'ope_8', 'ope_9'})
