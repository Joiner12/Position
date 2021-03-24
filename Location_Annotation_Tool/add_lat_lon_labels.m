function ananoted_file = add_lat_lon_labels(lat,lon,varargin)
% 功能: 为蓝牙节点采集的数据添加位置标签(经纬度)
% 定义: add_lat_lon_labels(lat,lon)
% 输入:
%       lat:纬度
%       lon:经度
%       varargin:可选参数(key:value)
%       可选参数
%       1.'originfile'指定原始数据文件的完整路径为full_file_path，如果未输入则弹出文件选择对话框;
%       2.'targetfolder'指定添加标签后目标文件的保存路径为target_folder，若未输入则弹出文件夹选择对话框;
% 输出:
%       ananoted_file:添加位置标签后的文件
% 语法:
%       add_lat_lon_labels(lat,lon)
%       add_lat_lon_labels(...,'originfile',full_file_path)
%       add_lat_lon_labels(...,'targetfolder','target_folder')
%       ....

% 功能: 为蓝牙节点采集的数据添加位置标签，通过''originfile'指定原始文件绝对路径
%       示例:
%           add_lat_lon_labels(1,1, 'originfile',...
%           'D:\Code\BlueTooth\pos_bluetooth_matlab\Location_Annotation_Tool\数据格式示例.txt'


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
% add_label_to_file(lat,lon,origin_file,target_file);
add_label_to_file(lat,lon,origin_file,target_file);
ananoted_file = target_file;
fprintf('%s\n添加位置标签lat:%0.7f lon:%0.7f 完成...\n保存于:%s\n', ...
    origin_file,lat,lon,target_file);
end