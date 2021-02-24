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
%  add_lat_lon_labels(lat,lon)
%  add_lat_lon_labels(...,'originfile',full_file_path)
%  add_lat_lon_labels(...,'overwrite',yes_no)
%  add_lat_lon_labels(...,'targetfolder','c:\\ananoted folder\\')

%% 参数检查
disp('蓝牙数据添加位置标签');
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
    target_folder_temp = uigetdir(pwd);
    if isequal(target_folder_temp,0)
        target_folder_temp = '';
    end
end
if ~isfolder(target_folder_temp)
    warning('所选目标路径:%s 不存在,\n路径选择出错,请重新运行程序',target_folder_temp);
    return
end
target_folder = target_folder_temp;


disp(origin_file,target_folder);


ananoted_file = 'no';
end