function overview_origin_rssi_trends(varargin)
    % 功能：
    %       总览原始数据文件中不同ap的RSSI整体变化情况
    % 定义:
    %       overview_origin_rssi_trends(varargin)
    % 输入:
    %       varargin,扩展变量
    % 输出:
    %       none

    if false
        [file, path] = uigetfile('./data/*.*', 'Multiselect', 'off');
        filename = fullfile(path, file);
    else
        % filename = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\动态2021-04-20-m-apfilter.txt';
        filename = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\动态2021-04-20-m.txt';
    end

    fileId = fopen(filename, 'r');
    src_line = cell(0);

    while ~feof(fileId)
        src_line = [src_line; fgetl(fileId)];
    end

    fclose(fileId);
    fprintf('原始数据读取完成:%s\n', filename);

    %%
    ap_all = struct('name', '', 'rssi', [], 'counter', 0);
    stored_ap_name = cell(0);
    stored_ap_cnt = 0;

    for k = 1:1:length(src_line)
        piece_str = string(src_line{k});

        if isequal(k, 90)
            d_line = 1;
        end

        if contains(piece_str, 'APMSG')
            exp_1 = '\s*';
            piece_o = regexp(piece_str, exp_1, 'split');
            name_temp = piece_o{2};
            rssi_temp = str2num(piece_o{4});

            if ~strcmpi(name_temp, "onepos_HLK_1") &&~strcmpi(name_temp, "onepos_HLK_3")

                if any(strcmp(stored_ap_name, name_temp))
                    index = find(strcmp(stored_ap_name, name_temp));
                    % -
                    rssi_temp_ap = ap_all(index).rssi;
                    ap_all(index).rssi = [rssi_temp_ap; rssi_temp];
                    ap_all(index).counter = ap_all(index).counter + 1;
                else
                    % 初始化新的ap结构体
                    stored_ap_name = [stored_ap_name, name_temp];
                    stored_ap_cnt = stored_ap_cnt + 1;
                    ap_all(stored_ap_cnt).name = name_temp;
                    ap_all(stored_ap_cnt).rssi = rssi_temp;
                    ap_all(stored_ap_cnt).counter = 1;
                end

            end

        end

    end

    fprintf('数据读取完成\n');
    %%
    tcf('ap-statistics');
    figure('name', 'ap-statistics');
    hold on

    for k = 1:1:length(ap_all)
        rssi_s = ap_all(k).rssi;
        plot(rssi_s, 'linestyle', '-.', 'marker', '*')
    end

    legend(stored_ap_name')

    if any(strcmpi(varargin, 'SaveFigure'))
        fig_name = char(datetime('now', 'format', 'yyyyddMMHHmmss'));
        saveas(f, strcat(fig_name));
    end

end
