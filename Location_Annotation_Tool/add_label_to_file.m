function add_label_to_file(lat, lon, src_file, tar_file)
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
    src_file_id = fopen(origin_file, 'r');
    src_data = cell(0);
    cnt = 1;

    while ~feof(src_file_id)
        line_temp = fgetl(src_file_id);

        if ~isempty(line_temp)
            src_data{cnt, 1} = line_temp;
            cnt = cnt + 1;
        end

    end

    fclose(src_file_id);

    %------------------ ��ӱ�ǩ ------------------%
    % ��ȡ����֡��ʽ
    cnt_1 = 1;
    underscore_line = '';

    while cnt_1 < cnt - 1
        line_temp = src_data{cnt_1};
        expr = '^-{20,}-$';
        [head, ~] = regexp(strrep(line_temp, ' ', ''), expr);

        if ~isempty(head)
            underscore_line = line_temp;
            break;
        end

        cnt_1 = cnt_1 + 1;
    end

    [format_head, format_tail] = regexp(underscore_line, '\s', 'split');

    if isempty(format_tail)
        error('���ݴ���');
    end

    %%
    target_file = tar_file;
    tar_file_id = fopen(target_file, 'w+');
    src_data_len = length(src_data);
    lat_str_temp = sprintf('%0.8f', lat);

    if isnumeric(format_head)
        space_cnt_1 = format_head(4) - length('$TRUPS');
        space_cnt_2 = format_head(end) - format_head(4) - length(lat_str_temp);
    else
        space_cnt_1 = format_tail(4) - length('$TRUPS');
        space_cnt_2 = format_tail(end) - format_tail(4) - length(lat_str_temp);
    end

    loc_label = sprintf('$TRUPS%*s%.8f%*s%.8f', space_cnt_1, ...
        '', lat, space_cnt_2, '', lon);

    for i = 1:1:src_data_len
        origin_line = src_data{i};
        line_temp = strtrim(origin_line);
        expression = '\s+';
        splitStr = regexp(line_temp, expression, 'split');
        % �ж���'$APMSG'��ͷ����,��'$TRUPS'��ʼ����
        if ~isempty(splitStr) ...
                && strcmp(splitStr{1}, 'HEAD') && i > 1
            %         fprintf(tar_file_id,'%s\n\n',loc_label);
            fprintf(tar_file_id, '%s\n\n', loc_label);
        end

        % ԭʼ����
        %     fprintf(tar_file_id,strcat(origin_line,'\n'));
        fprintf(tar_file_id, strcat(origin_line, '\n'));
        % ���һ֡����λ�ñ�ǩ
        if isequal(i, src_data_len)
            fprintf(tar_file_id, '%s\n', loc_label);
        end

    end

    fclose(tar_file_id);
end
