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
src_file_id = fopen(origin_file);
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
loc_label = sprintf('$TRUPS   %.8f    %.8f\n',lat,lon);
pre_splitStr = cell(1,1);
src_data_len = length(src_data);
for i = 1:1:src_data_len
    line_temp = src_data{i};
    line_temp = strtrim(line_temp);
    expression = '\s+';
    splitStr = regexp(line_temp,expression,'split');
    % �ж���'$APMSG'��ͷ����,��'$TRUPS'��ʼ����
    if ~isempty(splitStr) ...
            && strcmp(splitStr{1},'HEAD') ...
            && strcmp(pre_splitStr{1},'$APMSG')
        fprintf(tar_file_id,loc_label);
    end
    % ԭʼ����
    fprintf(tar_file_id,strcat(line_temp,'\n'));
    pre_splitStr = splitStr;
    % ���һ֡����λ�ñ�ǩ
    if isequal(i,src_data_len)
        fprintf(tar_file_id,loc_label);
    end
end
fclose(tar_file_id);
end