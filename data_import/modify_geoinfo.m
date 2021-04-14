function status = modify_geoinfo(varargin)
    % ����:
    %       ���ݺ����ڲ�(ȫվ��)���ݶ�ԭʼ�������ݵĵ�����������޸ģ���Ҫ�ڶ�λ����ǰʹ�øú�����
    %       ��Ϊ��
    %           1��ble ap(bluetooth low energe access point)���͵ĵ���λ������
    %           2��ble ap��װλ�������λ��δ��ȷ��Ӧ��
    % ����:
    %       status = modify_geoinfo(varargin)
    % ����:
    %       varargin:{key:value}
    % ���:
    %       stauts��״̬������
    %

    %% ȫվ������ ..//TotalStation//*
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
