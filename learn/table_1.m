clc;
% 读取原始数据
data_file = './动态2021-04-20-m-apfilter.txt';
fileId = fopen(data_file);
frame_block = cell(0);
block_flag = false;
frame_data = cell(0);
piece_cnt = 0;

% 'VariableNames',{'HEAD' 'NAME' 'MAC' 'RSSI','LAT','LON'}
while ~feof(fileId)
    cur_line = fgetl(fileId);

    if ~isempty(cur_line)
        cur_line_split = regexp(cur_line, '[\s]?[\S]{1,}[\s]?', 'match');

        if contains(cur_line_split{1}, '---')
            block_flag = true;
        end

        if contains(cur_line_split{1}, 'HEAD') && block_flag
            block_flag = false;

            if ~isempty(frame_block)
                frame_data{length(frame_data) + 1} = frame_block';
            end

            frame_block = cell(0);
        end

        if block_flag && contains(cur_line_split{1}, '$APMSG')
            piece_temp = cell(size(cur_line_split));
            % HEAD
            piece_temp{1} = strrep(cur_line_split{1}, '\s', '');
            % NAME
            piece_temp{2} = strrep(cur_line_split{2}, '\s', '');
            % MAC
            piece_temp{3} = strrep(cur_line_split{3}, '\s', '');
            % RSSI
            piece_temp{4} = strrep(cur_line_split{4}, '\s', '');
            % LAT
            piece_temp{5} = str2double(strrep(cur_line_split{5}, '\s', ''));
            % LON
            piece_temp{6} = str2double(strrep(cur_line_split{6}, '\s', ''));

            frame_block{length(frame_block) + 1} = piece_temp;
        end

    end

end

frame_data = frame_data';
fclose(fileId);

