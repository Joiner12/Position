function data = data_import()
    %功能：从文件夹中选择数据文件，导入数据文件中的数据，可同时导入多份数据文件
    %定义：data = data_import()
    %参数：
    %
    %输出：
    %    data：数据文件中的数据

    %选择待导入的文件
    [file_name, path] = uigetfile('*', ...
        'Select One or More Files', ...
        'MultiSelect', 'on', '.\data\');

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
        file{i} = [path, file_name{i}];
    end

    %解析数据
    data = cell(length(file), 1);

    for i = 1:length(data)
        [data{i}, frame_num_total] = blu_data_file_parsing(file{i});
    end

end
