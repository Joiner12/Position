function parse_data = get_std_dist_rssi_data(varargin)
% ����:
%       �ӱ�׼������������ȡRSSI-distance��Ӧֵ��
% ����:
%       parse_data = get_std_dist_rssi_info(varargin)
% ���룺
%       src_folder:ԭʼ�����ļ���(e.g: d:xx\xx\xx\);
%       ap_filter:apmsg�˲�����cell���ݽṹ���磺{'A3','A7'}
%       varargin:��������
% ���:
%       parse_data:��������(cell)
% example:
% get_std_dist_rssi_info(__,name,value);
% get_std_dist_rssi_info('src_foler',D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\script);
% ��D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\script��ȡԴ�ļ���



%% ��������Ĭ��ֵ
src_folder = pwd(); % ����Դ·��
% tar_folder = src_folder; % ����·��
ap_filter = cell(0); % apmsg�˲�ѡ��
parse_data = cell(0); % ��������

%% Դ�ļ�·��
if ~isempty(find(strcmpi(varargin,'src_folder'),1))
    src_folder = varargin{find(strcmpi(varargin,'src_folder'))+1};
    if ~isfolder(src_folder)
        error('no such folder %s \n',src_folder);
    end
end

%% apmsg
if ~isempty(find(strcmpi(varargin,'ap_filter'),1))
    ap_filter = varargin{find(strcmpi(varargin,'ap_filter'))+1};
    if ~isa(ap_filter,'cell')
        error('access point ��Ϊcell��������.\n');
    end
end


%%
[file,path] = uigetfile(fullfile(src_folder,'*.txt'),'Multiselect','on');
% δѡ���ļ�
if isequal(file,0)
    warning('selection of files canceled');
    return;
end
a = tic();
% ���ļ��͵��ļ�����
file_selected = cell(0);
file_cnt = 1;
if ~isa(file,'cell')
    file_selected{1,1} = fullfile(path,file);
else
    file_cnt = length(file);
    file = reshape(file,[file_cnt,1]);
    for i = 1:1:file_cnt
        cur_file = fullfile(path,file{i});
        file_selected{i,1} = cur_file;
    end
end

% ���ݽ���
data_part_cnt = 1;
for j = 1:1:file_cnt
    cur_file = file_selected{j,1};
    [~,cur_file_name,~] = fileparts(cur_file);
    distance_temp = strrep(cur_file_name,'-','_'); % Դ����������ʽ:HLK-1m-50cm.txt
    expr = '-[0-9]{1,2}|-[0-9]{2,}';
    distance_temp = regexp(cur_file_name,expr,'match');
    distance_temp = strrep(distance_temp,'-','');
    distance_temp = str2double(distance_temp);
    distance = -1; % ��ʵ����
    if isequal(length(distance_temp),2)
        distance = distance_temp(1)+distance_temp(2)/100;
    end
    if ~isempty(ap_filter)
        for k = 1:1:length(ap_filter)
            filter_temp = ap_filter{k};
            rssi_temp = get_rssi_info(cur_file,filter_temp);
            data_temp_s = struct('distance',distance,'apInfo',filter_temp,...
                'RSSI',rssi_temp);
            parse_data{data_part_cnt} = data_temp_s;
            data_part_cnt = data_part_cnt + 1;
        end
    else
        rssi_temp = get_rssi_info(cur_file);
        data_temp_s =  struct('distance',distance,'apInfo','',...
            'RSSI',rssi_temp);
        parse_data{data_part_cnt} = data_temp_s;
        data_part_cnt = data_part_cnt + 1;
    end
end
toc(a);
end