%% split data frame
%{
现有数据发送频率高，单帧数据量大，不适用于前置选择器。
将现有数据分割为单帧数据条数为5的数据。
%}

%% fgetl
clc;
[file, path] = uigetfile('../*.*', 'MultiSelect', 'off');

if isequal(file, 0)
    disp('selected Cancel');
    return;
end

% read from file
modified_detail = cell(0);
fileId = fopen(fullfile(path, file), 'r');

while ~feof(fileId)
    str_temp = fgetl(fileId);

    if ~isempty(strrep(str_temp, ' ', ''))
        modified_detail = [modified_detail; str_temp];
    end

end

fclose(fileId);
disp('数据读取完成')
%% fwrite
[~, nametemp, ext] = fileparts(file);
file_name = fullfile(path, strcat(nametemp, '-split', ext));
fileId_o = fopen(file_name, 'w');
ap_cnt = 0;
frame_feature = ["  HEAD         NAME                MAC        RSSI      LAT                  LON            ", ...
                "------ -------------------- ----------------- ---- -------------------- --------------------"];
frame_cnt = 0;
outline = cell(0);
for i = 1:1:length(modified_detail)
    cur_line = modified_detail{i};
    fprintf(fileId_o, '%s\n', cur_line);
    outline = [outline;cur_line];
    if contains(cur_line, '$APMSG')
        frame_cnt = frame_cnt + 1;
    end

    if isequal(mod(frame_cnt, 5), 0) && i > 2
        frame_cnt = 0;
        fprintf(fileId_o, '%s\n', frame_feature(1));
        outline = [outline;frame_feature(1)];
        fprintf(fileId_o, '%s\n', frame_feature(2));
        outline = [outline;frame_feature(2)];
    end

end

fclose(fileId_o);
fprintf('%s\n↓\n%s\n', fullfile(path, file), file_name);
