function ananoted_file = add_lat_lon_labels(lat,lon,varargin)
% ����: Ϊ�����ڵ�ɼ����������λ�ñ�ǩ(��γ��)
% ����: add_lat_lon_labels(lat,lon)
% ����:
%       lat:����
%       lon:γ��
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
tar_file_name = strcat(name_temp{1},'-������ֵ','.',name_temp{end});
target_file = fullfile(target_folder,tar_file_name);
% add_label_to_file(lat,lon,origin_file,target_file);
add_label_to_file(lat,lon,origin_file,target_file);
ananoted_file = target_file;
fprintf('%s\n���λ�ñ�ǩlat:%0.7f lon:%0.7f ���...\n������:%s\n', ...
    origin_file,lat,lon,target_file);
end


function add_label_to_file(lat,lon,src_file,tar_file)
% ����: �������õľ�γ��ֵ����Դ�����ļ�������Ӿ�γ�ȱ�ǩ�������浽Ŀ�������ļ��С�
% ����: add_label_to_file(lat,lon,src_file,tar_file)
% ����:
%       lat:����
%       lon:γ��
%       src_file:Դ�����ļ�����·��(abspath)
%       tar_file:Ŀ�������ļ����·��(abspath)
% ���:
%       none

%------------------ ��ȡԭʼ�ļ� ------------------%
origin_file = src_file;
src_file_id = fopen(origin_file,'r');
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

%------------------ ��ӱ�ǩ ------------------%
% ��ȡ����֡��ʽ
cnt_1 = 1;
underscore_line = '';
while  cnt_1 < cnt - 1
    line_temp = src_data{cnt_1};
    expr = '^-{20,}-$';
    [head,~] = regexp(strrep(line_temp,' ',''),expr);
    if ~isempty(head)
        underscore_line = line_temp;
        break;
    end
    cnt_1 = cnt_1 + 1;
end
[format_head,format_tail] = regexp(underscore_line,'\s','split');
if isempty(format_tail)
    error('���ݴ���');
end

%%
target_file = tar_file;
tar_file_id = fopen(target_file,'w+');
src_data_len = length(src_data);
lat_str_temp = sprintf('%0.8f',lat);
if isnumeric(format_head)
    space_cnt_1 = format_head(4)-length('$TRUPS');
    space_cnt_2 = format_head(end)- format_head(4)- length(lat_str_temp);
else
    space_cnt_1 = format_tail(4)-length('$TRUPS');
    space_cnt_2 = format_tail(end)- format_tail(4)- length(lat_str_temp);
end

loc_label = sprintf('$TRUPS%*s%.8f%*s%.8f',space_cnt_1,...
    '',lat,space_cnt_2,'',lon);

for i = 1:1:src_data_len
    origin_line = src_data{i};
    line_temp = strtrim(origin_line);
    expression = '\s+';
    splitStr = regexp(line_temp,expression,'split');
    % �ж���'$APMSG'��ͷ����,��'$TRUPS'��ʼ����
    if ~isempty(splitStr) ...
            && strcmp(splitStr{1},'HEAD') && i>1
        %         fprintf(tar_file_id,'%s\n\n',loc_label);
        fprintf(tar_file_id,'%s\n\n',loc_label);
    end
    % ԭʼ����
    %     fprintf(tar_file_id,strcat(origin_line,'\n'));
    fprintf(tar_file_id,strcat(origin_line,'\n'));
    % ���һ֡����λ�ñ�ǩ
    if isequal(i,src_data_len)
        fprintf(tar_file_id,'%s\n',loc_label);
    end
end
fclose(tar_file_id);
end