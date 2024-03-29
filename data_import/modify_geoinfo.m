function [status, filename] = modify_geoinfo(varargin)
    % 功能:
    %       根据函数内部(全站仪)数据对原始蓝牙数据的地理坐标进行修改，需要在定位功能前使用该函数，
    %       因为：
    %           1、ble ap(bluetooth low energe access point)发送的地理位置有误。
    %           2、ble ap安装位置与测量位置未正确对应；
    % 定义:
    %       status = modify_geoinfo(varargin)
    % 输入:
    %       varargin:{key:value}
    % 输出:
    %       stauts，状态参数。
    %       filename,文件绝对路径

    %% 全站仪数据 ..//TotalStation//*
    if false
        % 原始坐标——修改时间2021-05-17 13:46
        % name = ["onepos_HLK_1", "onepos_HLK_3", ...
            %         "onepos_HLK_7", "onepos_HLK_8", ...
            %         "onepos_HLK_5", "onepos_HLK_2"];
        % name = name';
        % lat = [30.5480384, 30.5478864, ...
        %         30.5478867, 30.5480210, ...
        %         30.5478838, 30.5480286];
        % lat = lat';
        % lon = [104.0586489, 104.0586441, ...
        %         104.0585689, 104.0585709, ...
        %         104.0587162, 104.0587327];
        name = ["onepos_HLK_1", "onepos_HLK_2", ...
                "onepos_HLK_3", "onepos_HLK_5", ...
                "onepos_HLK_7", "onepos_HLK_8"];
        name = name';
        %
        lat = [30.548018797743, 30.548019508539, ...
                30.547880364315, 30.547874726343, ...
                30.547872167734, 30.548014837274];
        lat = lat';
        lon = [104.058730768827, 104.058895271369, ...
                104.058728300713, 104.058889206422, ...
                104.058567643123, 104.058567183453];
    end

    %% 7.5*7.5坐标数据 update:2021-08-17 10:24
    if true
        name = ["ope_0", "ope_1", ...
                "ope_6", "ope_7", ...
                "ope_8", "ope_9"];
        name = name';
        %
        lat = [30.5478762, 30.5478722, ...
                30.5478804, 30.5479558, ...
                30.5479469, 30.5479457];
        lat = lat';
        lon = [104.0586605, 104.0585676, ...
                104.0587283, 104.0585676, ...
                104.0586527, 104.0587305];
    end

    filename = ''; % 初始输出文件路径
    lon = lon';
    TotalStationData = table(name, lat, lon);
    TotalStationData.Properties.VariableNames = {'name', 'lat', 'lon'};

    %% fgetl
    [file, path] = uigetfile('../*.*', 'MultiSelect', 'off');

    if isequal(file, 0)
        disp('selected Cancel');
        status = 0;
        return;
    end

    % write to file
    modified_detail = cell(0);
    line_cnt = 1;
    fileId = fopen(fullfile(path, file), 'r');
    frame_cnt = 0;

    while ~feof(fileId)
        str_temp = fgetl(fileId);

        if contains(str_temp, '----')
            frame_cnt = frame_cnt + 1;
        end

        if contains(str_temp, '$APMSG')
            split_temp = strsplit(str_temp, ' ');
            ap_name = split_temp{2};
            index_logical = strcmp(name, ap_name);

            if any(index_logical)
                index = find(index_logical);
                lat = TotalStationData.lat(index);
                lon = TotalStationData.lon(index);

                strf_out = sprintf("%s%*s%s%*s%s%*s%s%*s%.7f%*s%.7f\n", ...
                    split_temp{1}, 1, '', split_temp{2}, 9, '', ...
                    split_temp{3}, 1, '', split_temp{4}, 2, '', ...
                    lat, 11, '', lon);
            else
                strf_out = sprintf(' \n');
            end

        else
            strf_out = str_temp;
        end

        modified_detail{line_cnt} = strf_out;
        line_cnt = line_cnt + 1;

        if contains(str_temp, '----')
            frame_cnt = frame_cnt + 1;
        end

    end

    fclose(fileId);
    %% fwrite
    modified_detail = reshape(modified_detail, [length(modified_detail), 1]);
    [~, nametemp, ext] = fileparts(file);
    file_name = fullfile(path, strcat(nametemp, '-m', ext));
    fileId_o = fopen(file_name, 'w');

    for i = 1:1:length(modified_detail)
        cur_line = modified_detail{i, :};
        fprintf(fileId_o, '%s\n', cur_line);
    end

    fclose(fileId_o);
    filename = file_name;
    status = 1;
    fprintf('数据帧:%0.0f\n', frame_cnt);
    fprintf('%s\n↓\n%s\n', fullfile(path, file), file_name);

end
