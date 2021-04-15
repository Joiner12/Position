function status = modify_geoinfo(varargin)
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
    %

    %% 全站仪数据 ..//TotalStation//*
    name = ["onepos_HLK_1", "onepos_HLK_3", ...
            "onepos_HLK_7", "onepos_HLK_8"];
    name = name';
    lat = [30.5479562, 30.5479558, 30.5480210, 30.5480286];
    lat = lat';
    lon = [104.0587338, 104.0585699, 104.0585709, 104.0587327];
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
            index_logical = strcmp(["onepos_HLK_1", "onepos_HLK_3", ...
                                    "onepos_HLK_7", "onepos_HLK_8"], ap_name);

            if any(index_logical)
                index = find(index_logical);
                lat = TotalStationData.lat(index);
                lon = TotalStationData.lon(index);

                strf_out = sprintf("%s%*s%s%*s%s%*s%s%*s%.12f%*s%.12f\n", ...
                    split_temp{1}, 1, '', split_temp{2}, 9, '', ...
                    split_temp{3}, 1, '', split_temp{4}, 2, '', ...
                    lat, 6, '', lon);
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
    fprintf('数据帧:%0.0f\n', frame_cnt);
    fprintf('%s\n↓\n%s\n', fullfile(path, file), file_name);

end
