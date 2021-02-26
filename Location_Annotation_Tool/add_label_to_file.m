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
target_file = tar_file;
tar_file_id = fopen(target_file,'w+');

pre_splitStr = cell(1,1);
src_data_len = length(src_data);
pre_APMSG_str = '';
loc_label='';
for i = 1:1:src_data_len
    origin_line = src_data{i};
    line_temp = strtrim(origin_line);
    expression = '\s+';
    splitStr = regexp(line_temp,expression,'split');
    % �ж���'$APMSG'��ͷ����,��'$TRUPS'��ʼ����
    if ~isempty(splitStr) ...
            && strcmp(splitStr{1},'HEAD') ...
            && strcmp(pre_splitStr{1},'$APMSG')
        APMSG_str_temp = pre_APMSG_str;
        expr = '\d{1,}\.\d{1,}';
        [head,~] = regexp(APMSG_str_temp,expr);
        lat_str_temp = sprintf('%0.8f',lat);
        space_cnt = head(2)-head(1)-length(lat_str_temp);
        space_cnt_1 = head(1)-length('$TRUPS')-1;
        loc_label = sprintf('$TRUPS%*s%.8f%*s%.8f\n',space_cnt_1,...
            '',lat,space_cnt,'',lon);
        fprintf(tar_file_id,'%s\n\n',loc_label);
    end
    % ԭʼ����
    fprintf(tar_file_id,strcat(origin_line,'\n'));
    pre_splitStr = splitStr;
    pre_APMSG_str = origin_line;
    % ���һ֡����λ�ñ�ǩ
    if isequal(i,src_data_len)
        fprintf(tar_file_id,loc_label);
    end
end
fclose(tar_file_id);
end