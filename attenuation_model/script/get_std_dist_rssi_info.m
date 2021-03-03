function get_std_dist_rssi_info(src_folder,tar_folder)
% 功能:
%       从标准测试数据中提取RSSI-distance对应值,输出为std_rssi.mat文件，
%       并将其保存到tar_folder，如果该路径下存在std_rssi.mat则覆盖。
% 定义:
%       get_std_dist_rssi_info(src_folder)
% 输入：
%       src_folder:原始数据文件夹(e.g: d:xx\xx\xx\);
%       tar_folder:生成的std_rssi.mat目标路径;
% 输出:
%       None


%% 参数检查
if ~isfolder(src_folder)
    error('no such folder %s \n',src_folder);
end

if ~isfolder(tar_folder)
    error('no such folder %s \n',tar_folder);
end

[file,path] = uigetfile(fullfile(src_folder,'*.txt'),'Multiselect','on');

% 未选择文件
if isequal(file,0)
    warning('selection of files canceled');
    return;
end

% 多文件和单文件区分
% todo:std-namespace
if ~isa(file,'cell')
    % todo:
else
    name_head = 'm_';
    file_cnt = length(file);
    for i = 1:1:file_cnt
        file = reshape(file,[length(file),1]);
        cur_file = fullfile(src_folder,file{i,1});
        rssi_temp = get_rssi_info(cur_file);
        mat_name = [name_head,num2str(i)];
        eval([mat_name,'= rssi_temp;'])
    end
end
% load & save
% todo:mat-name(varargin)
try
    load(fullfile(tar_folder,'std_diss.mat'));
catch
    
end
% clearvars -except m_* tar_folder;
save(fullfile(tar_folder,'std_diss.mat'),'m_*');
end