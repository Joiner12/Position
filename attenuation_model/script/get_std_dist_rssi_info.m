function get_std_dist_rssi_info(src_folder,tar_folder)
% ����:
%       �ӱ�׼������������ȡRSSI-distance��Ӧֵ,���Ϊstd_rssi.mat�ļ���
%       �����䱣�浽tar_folder�������·���´���std_rssi.mat�򸲸ǡ�
% ����:
%       get_std_dist_rssi_info(src_folder)
% ���룺
%       src_folder:ԭʼ�����ļ���(e.g: d:xx\xx\xx\);
%       tar_folder:���ɵ�std_rssi.matĿ��·��;
% ���:
%       None


%% �������
if ~isfolder(src_folder)
    error('no such folder %s \n',src_folder);
end

if ~isfolder(tar_folder)
    error('no such folder %s \n',tar_folder);
end

[file,path] = uigetfile(fullfile(src_folder,'*.txt'),'Multiselect','on');

% δѡ���ļ�
if isequal(file,0)
    warning('selection of files canceled');
    return;
end

% ���ļ��͵��ļ�����
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