function ananoted_file = add_lat_lon_labels(lat,lon,varargin)
% 功能: 为蓝牙节点采集的数据添加位置标签(经纬度)
% 定义: add_lat_lon_labels(lat,lon,varargin)
% 输入:
%       lat:经度
%       lon:纬度
%       varargin:可变参数
% 输出:
%       ananoted_file:添加位置标签后的文件
% 语法:
%       add_lat_lon_labels(lat,lon)
%       add_lat_lon_labels(...,'originfile',full_file_path)
%       add_lat_lon_labels(...,'overwrite',yes_no)
%       add_lat_lon_labels(...,'targetfolder','c:\\ananoted folder\\')
% 示例:
%     add_lat_lon_labels(1,1, ...
%         'originfile',...
%         'D:\Code\BlueTooth\pos_bluetooth_matlab\Location_Annotation_Tool\数据格式示例.txt',...
%         'targetfolder',pwd);
% 时间:
%       2021-02-24 11:41

%%
% 参数检查
disp('原始数据添加位置标签');
assert(isnumeric(lat) && isequal(size(lat),[1,1]),'lat应该为数字');
assert(isnumeric(lon) && isequal(size(lon),[1,1]),'lon应该为数字');

%% 读取原始数据文件
para_temp = strcmpi(varargin,'originfile');
origin_file = 'none';
if any(para_temp)
    origin_file = varargin{find(para_temp)+1};
else
    [file,path] = uigetfile({'*.txt';'*.log';'*.*'},...
        '选择需要转换的文件',...
        'MultiSelect', 'off');
    if ~isequal(file,0)
        origin_file = fullfile(path,file);
    end
end

% 检查选择的文件
if ~isfile(origin_file)
    warning('所选文件:%s 不存在,\n文件选择出错,请重新运行程序',origin_file);
    return
end
%% 设置转换后文件保存路径
para_temp = strcmpi(varargin,'targetfolder');
if any(para_temp)
    target_folder_temp = varargin{find(para_temp)+1};
else
    target_folder_temp = uigetdir(pwd,'选择目标文件保存路径');
    if isequal(target_folder_temp,0)
        target_folder_temp = '';
    end
end
if ~isfolder(target_folder_temp)
    warning('所选目标路径:%s 不存在,\n路径选择出错,请重新运行程序',target_folder_temp);
    return
end
target_folder = target_folder_temp;
% 拼接目标文件
src_file_temp = regexp(origin_file,'\\','split');
name_temp = strsplit(src_file_temp{end},'.');
tar_file_name = strcat(name_temp{1},'-added_lat_lon','.',name_temp{end});
target_file = fullfile(target_folder,tar_file_name);
add_label_to_file(lat,lon,origin_file,target_file);
ananoted_file = target_file;
fprintf('%s\n添加位置标签lat:%0.7f lon:%0.7f 完成...\n保存于:%s\n', ...
    origin_file,lat,lon,target_file);
end

%% static function
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