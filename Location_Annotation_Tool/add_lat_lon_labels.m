function ananoted_file = add_lat_lon_labels(lat,lon,varargin)
% ����: Ϊ�����ڵ�ɼ����������λ�ñ�ǩ(��γ��)
% ����: add_lat_lon_labels(lat,lon,varargin)
% ����:
%       lat:����
%       lon:γ��
%       varargin:�ɱ����
% ���:
%       ananoted_file:���λ�ñ�ǩ����ļ�
% �﷨:
%  add_lat_lon_labels(lat,lon)
%  add_lat_lon_labels(...,'originfile',full_file_path)
%  add_lat_lon_labels(...,'overwrite',yes_no)
%  add_lat_lon_labels(...,'targetfolder','c:\\ananoted folder\\')

%% �������
disp('�����������λ�ñ�ǩ');
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
    target_folder_temp = uigetdir(pwd);
    if isequal(target_folder_temp,0)
        target_folder_temp = '';
    end
end
if ~isfolder(target_folder_temp)
    warning('��ѡĿ��·��:%s ������,\n·��ѡ�����,���������г���',target_folder_temp);
    return
end
target_folder = target_folder_temp;


disp(origin_file,target_folder);


ananoted_file = 'no';
end