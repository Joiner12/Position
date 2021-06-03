function data = data_import(varargin)
    %功能：从文件夹中选择数据文件，导入数据文件中的数据，可同时导入多份数据文件
    %定义：data = data_import()
    %参数：
    %       varargin,扩展参数('key',value)
    %       'datafile',数据文件绝对路径，单文件:字符串数组，多文件：元胞数组
    %输出：
    %    data：数据文件中的数据

    %选择待导入的文件
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

    %解析数据
    data = cell(length(file), 1);

    for i = 1:length(data)
        [data{i}, frame_num_total] = blu_data_file_parsing(file{i});
    end

end
