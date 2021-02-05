function data = data_import()
%功能：导入数据

%选择待导入的文件
[file_name, path] = uigetfile('*.*', ...
    'Select One or More Files', ...
    'MultiSelect', 'on');

if isnumeric(path)
    if (file_name == 0) || (path == 0)
        file_name = cell(0);
    end
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