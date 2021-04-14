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
    lat = [30.325287460597, 30.325237242973, 30.325236181531, 30.325284586259];
    lat = lat';
    lon = [104.033140627770, 104.033135912516, 104.033084300271, 104.033084380912];
    lon = lon';
    TotalStationData = table(name, lat, lon);
    TotalStationData.Properties.VariableNames = {'name', 'lat', 'lon'};

    %% getfile
    [file, path] = uigetfile('../*.*', 'MultiSelect', 'off');

    if isequal(file, 0)
        disp('selected Cancel');
        status = 0;
    else
        disp(['selected ', fullfile(path, file)]);
    end

    [~, nametemp, ext] = fileparts(file);
    file_name = fullfile(path, strcat(nametemp, '-m.', ext));
    

    %% write to file
    fileId = fopen(file_name);
    fclose(fileId);

end
