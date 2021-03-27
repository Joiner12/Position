function ananoted_file = add_lat_lon_labels(lat,lon,varargin)
% ����: Ϊ�����ڵ�ɼ����������λ�ñ�ǩ(��γ��)
% ����: add_lat_lon_labels(lat,lon)
% ����:
%       lat:γ��
%       lon:����
%       varargin:��ѡ����(key:value)
%       ��ѡ����
%       1.'originfile'ָ��ԭʼ�����ļ�������·��Ϊfull_file_path�����δ�����򵯳��ļ�ѡ��Ի���;
%       2.'targetfolder'ָ����ӱ�ǩ��Ŀ���ļ��ı���·��Ϊtarget_folder����δ�����򵯳��ļ���ѡ��Ի���;
% ���:
%       ananoted_file:���λ�ñ�ǩ����ļ�
% �﷨:
%       add_lat_lon_labels(lat,lon)
%       add_lat_lon_labels(...,'originfile',full_file_path)
%       add_lat_lon_labels(...,'targetfolder','target_folder')
%       ....

% ����: Ϊ�����ڵ�ɼ����������λ�ñ�ǩ��ͨ��''originfile'ָ��ԭʼ�ļ�����·��
%       ʾ��:
%           add_lat_lon_labels(1,1, 'originfile',...
%           'D:\Code\BlueTooth\pos_bluetooth_matlab\Location_Annotation_Tool\���ݸ�ʽʾ��.txt'


%%
% �������
disp('ԭʼ�������λ�ñ�ǩ');
assert(isnumeric(lat) && isequal(size(lat),[1,1]),'latӦ��Ϊ����');
assert(isnumeric(lon) && isequal(size(lon),[1,1]),'lonӦ��Ϊ����');

%% ��ȡԭʼ�����ļ�
para_temp = strcmpi(varargin,'originfile');
origin_file = 'none';
if any(para_temp)
    origin_file = varargin{find(para_temp)+1};
else
    [file,path] = uigetfile({'*.txt';'*.log';'*.*'},...
        'ѡ����Ҫת�����ļ�',...
        'MultiSelect', 'off');
    if ~isequal(file,0)
        origin_file = fullfile(path,file);
    end
end

% ���ѡ����ļ�
if ~isfile(origin_file)
    warning('��ѡ�ļ�:%s ������,\n�ļ�ѡ�����,���������г���',origin_file);
    return
end
%% ����ת�����ļ�����·��
para_temp = strcmpi(varargin,'targetfolder');
if any(para_temp)
    target_folder_temp = varargin{find(para_temp)+1};
else
    target_folder_temp = uigetdir(pwd,'ѡ��Ŀ���ļ�����·��');
    if isequal(target_folder_temp,0)
        target_folder_temp = '';
    end
end
if ~isfolder(target_folder_temp)
    warning('��ѡĿ��·��:%s ������,\n·��ѡ�����,���������г���',target_folder_temp);
    return
end
target_folder = target_folder_temp;
% ƴ��Ŀ���ļ�
src_file_temp = regexp(origin_file,'\\','split');
name_temp = strsplit(src_file_temp{end},'.');
tar_file_name = strcat(name_temp{1},'-added_lat_lon','.',name_temp{end});
target_file = fullfile(target_folder,tar_file_name);
% add_label_to_file(lat,lon,origin_file,target_file);
add_label_to_file(lat,lon,origin_file,target_file);
ananoted_file = target_file;
fprintf('%s\n���λ�ñ�ǩlat:%0.7f lon:%0.7f ���...\n������:%s\n', ...
    origin_file,lat,lon,target_file);
end