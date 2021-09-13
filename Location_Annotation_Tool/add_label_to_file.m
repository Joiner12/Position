function add_label_to_file(lat, lon, src_file, tar_file)
    % 功能: 根据设置的经纬度值、将源数据文件内容添加经纬度标签，并保存到目标数据文件中。
    % 定义: add_label_to_file(lat,lon,src_file,tar_file)
    % 输入:
    %       lat:经度
    %       lon:纬度
    %       src_file:源数据文件完整路径(abspath)
    %       tar_file:目标数据文件完成路径(abspath)
    % 输出:
    %       none

    %------------------ 读取原始文件 ------------------%
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

    %------------------ 添加标签 ------------------%
    % 读取数据帧格式
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
        error('数据错误');
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
        % 判断以'$APMSG'开头的行,以'$TRUPS'开始的行
        if ~isempty(splitStr) ...
                && strcmp(splitStr{1}, 'HEAD') && i > 1
            %         fprintf(tar_file_id,'%s\n\n',loc_label);
            fprintf(tar_file_id, '%s\n\n', loc_label);
        end

        % 原始数据
        %     fprintf(tar_file_id,strcat(origin_line,'\n'));
        fprintf(tar_file_id, strcat(origin_line, '\n'));
        % 最后一帧数据位置标签
        if isequal(i, src_data_len)
            fprintf(tar_file_id, '%s\n', loc_label);
        end

    end

    fclose(tar_file_id);
end
