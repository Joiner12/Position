function data = data_import(varargin)
    %���ܣ����ļ�����ѡ�������ļ������������ļ��е����ݣ���ͬʱ�����������ļ�
    %���壺data = data_import()
    %������
    %       varargin,��չ����('key',value)
    %       'datafile',�����ļ�����·�������ļ�:�ַ������飬���ļ���Ԫ������
    %�����
    %    data�������ļ��е�����

    %ѡ���������ļ�
    if any(strcmp(varargin, 'datafile'))
        file_name = varargin{find(strcmp(varargin, 'datafile')) + 1};
        path = '';
    else
        [file_name, path] = uigetfile('*', ...
            'Select One or More Files', ...
            'MultiSelect', 'on', '.\data\');
    end

    if isnumeric(path)

        if (file_name == 0) || (path == 0)
            file_name = cell(0);
        end

    end

    if ischar(file_name)
        tmp = file_name;
        file_name = cell(1);
        file_name{1} = tmp;
    end

    file = cell(length(file_name), 1);

    for i = 1:length(file_name)
        % file{i} = [path, file_name{i}];
        file{i} = fullfile(path, file_name{i});
    end

    %��������
    data = cell(length(file), 1);

    for i = 1:length(data)
        [data{i}, frame_num_total] = blu_data_file_parsing(file{i});
    end

end
