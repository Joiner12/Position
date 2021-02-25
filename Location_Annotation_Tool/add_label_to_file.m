function add_label_to_file(lat,lon,src_file,tar_file)
% 功能: 根据设置的经纬度值、将源数据文件内容添加经纬度标签，并保存到目标数据文件中。
% 定义: add_label_to_file(lat,lon,src_file,tar_file)
% 输入:
%       lat:经度
%       lon:纬度
%       src_file:源数据文件完整路径(abspath)
%       tar_file:目标数据文件完成路径(abspath)
% 输出:
%       none

%------------------ 读取原始文件 ------------------%
origin_file = src_file;
src_file_id = fopen(origin_file);
src_data = cell(0);
cnt = 1;
while ~feof(src_file_id)
    line_temp = fgetl(src_file_id);
    if ~isempty(line_temp)
        src_data{cnt,1} = line_temp;
        cnt = cnt + 1;
    end
end
fclose(src_file_id);
%------------------ 添加标签 ------------------%
target_file = tar_file;
tar_file_id = fopen(target_file,'w+');
loc_label = sprintf('$TRUPS   %.8f    %.8f\n',lat,lon);
pre_splitStr = cell(1,1);
src_data_len = length(src_data);
for i = 1:1:src_data_len
    line_temp = src_data{i};
    line_temp = strtrim(line_temp);
    expression = '\s+';
    splitStr = regexp(line_temp,expression,'split');
    % 判断以'$APMSG'开头的行,以'$TRUPS'开始的行
    if ~isempty(splitStr) ...
            && strcmp(splitStr{1},'HEAD') ...
            && strcmp(pre_splitStr{1},'$APMSG')
        fprintf(tar_file_id,loc_label);
    end
    % 原始数据
    fprintf(tar_file_id,strcat(line_temp,'\n'));
    pre_splitStr = splitStr;
    % 最后一帧数据位置标签
    if isequal(i,src_data_len)
        fprintf(tar_file_id,loc_label);
    end
end
fclose(tar_file_id);
end