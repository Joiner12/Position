function parse_data = get_std_dist_rssi_info(src_folder,tar_folder,varargin)
% ����:
%       �ӱ�׼������������ȡRSSI-distance��Ӧֵoutmat_name.mat�ļ���
%       �����䱣�浽tar_folder�������·���´���outmat_name.mat�򸲸ǡ�
% ����:
%       get_std_dist_rssi_info(src_folder,tar_folder)
% ���룺
%       src_folder:ԭʼ�����ļ���(e.g: d:xx\xx\xx\);
%       tar_folder:���ɵ�XX.matĿ��·��;
%       varargin:��������
%       outmat_name:���mat����
% ���:
%       parse_data:��������(cell)


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

% ���ļ��͵��ļ����� todo:
%{
file_selected = cell(0);
file_cnt = 1;
if ~isa(file,'cell')
    file_selected{1,1} = fullfile(path,file);
else
    file_cnt = length(file);
    for i = 1:1:file_cnt
        cur_file = fullfile(path,file{i,1});
        file_selected{i,1} = cur_file;
    end
end

% ���ݽ���
ap_filter = {'A3','A7'};
data_part_cnt = 1;
parse_data = cell(0);
for j = 1:1:file_cnt
    cur_file = file_selected{i,1};
    [~,cur_file_name,~] = fileparts(cur_file);
    filename = strrep(cur_file_name,'-','_');
    if ~isempty(ap_filter)
        for k = 1:1:length(ap_filter)
            filter_temp = ap_filter{k};
            rssi_temp = get_rssi_info(cur_file,filter_temp);
            mat_name = [filename,filter_temp];
            eval([mat_name,'= rssi_temp;']);
            parse_data{data_part_cnt} = mat_name;
            data_part_cnt = data_part_cnt + 1;
        end
    else
        rssi_temp = get_rssi_info(cur_file);
        eval([mat_name,'= rssi_temp;']);
        parse_data{data_part_cnt} = mat_name;
        data_part_cnt = data_part_cnt + 1;
    end
end
%}
parse_data = 1;
if ~isa(file,'cell')
    % file_selected{1,1} = fullfile(path,file);
    % todo:single file
else
    file_cnt = length(file);
    for i = 1:1:file_cnt
        file = reshape(file,[length(file),1]);
        [~,filename,~] = fileparts(file{i,1});
        filename = strrep(filename,'-','_');
        cur_file = fullfile(src_folder,file{i,1});
        % filter A3
        filter_A3 = 'A3';
        rssi_temp = get_rssi_info(cur_file,filter_A3);
        mat_name = [filename,filter_A3];
        eval([mat_name,'= rssi_temp;'])
        % filter A7
        filter_A7 = 'A7';
        rssi_temp = get_rssi_info(cur_file,filter_A7);
        mat_name = [filename,filter_A7];
        eval([mat_name,'= rssi_temp;'])
    end
end
% load & save
% todo:mat-name(varargin)
outmat_name = varargin{1};
if isfile(fullfile(tar_folder,outmat_name)) && false
    % clearvars -except m_* tar_folder;
    save(fullfile(tar_folder,'std_diss_hlk.mat'),'HLK_*');
end

end