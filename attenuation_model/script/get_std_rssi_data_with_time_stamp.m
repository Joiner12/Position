function rssi_time = get_std_rssi_data_with_time_stamp(varargin)
    % 函数:
    %       获取带时间戳的RSSI信息
    % 定义:
    %       rssi_time = get_std_rssi_data_with_time_stamp(varargin)
    % 输入:
    %       varargin
    % 输出:
    %       rssi_time,带时间戳的RSSI信息(cell)

    if any(strcmpi(varargin, 'filepath'))
        index_temp = find(strcmpi(varargin, 'filepath'));
        file_id = fopen(varargin{index_temp + 1}, 'r');
    else
        [file, path] = uigetfile('*.txt', 'MultiSelect', 'off');
        rssi_time = cell(0);

        if isequal(file, 0)
            return;
        end

        file_id = fopen(fullfile(path, file), 'r');
    end

    % 按行读取数据
    data_all = cell(0);
    line_cnt = 1;

    tick_lines = zeros(0); % 包含tick标签行

    while ~feof(file_id)
        cur_line_temp = fgetl(file_id);

        if ~isempty(cur_line_temp)

            if contains(cur_line_temp, 'scan_tick', 'IgnoreCase', true)
                tick_lines = [tick_lines; line_cnt];
            end

            data_all{line_cnt} = cur_line_temp;
            line_cnt = line_cnt +1;
        end

    end

    fclose(file_id);

    if isempty(data_all)
        disp('empty cell');
        return;
    end

    % 数组组合
    data_all = reshape(data_all, [length(data_all), 1]);

    for k = 1:length(tick_lines) - 1
        line_s_temp = data_all(tick_lines(k) + 1:tick_lines(k + 1) - 1, :);
        line_temp = data_all{tick_lines(k), :};
        % time stamp
        time_stamp_temp = regexp(line_temp, '[\d]*', 'match');
        rssi_time{k, 1} = str2double(time_stamp_temp{1, 1});
        rssi_temp = zeros(0);

        for k1 = 1:1:length(line_s_temp)
            cur_line_temp = line_s_temp{k1};
            % valid data line
            if contains(cur_line_temp, 'APMSG')
                regout = regexp(cur_line_temp, '\s*', 'split');
                val_temp = regout{4};
                rssi_temp = [rssi_temp, str2double(val_temp)];
            end

        end

        rssi_time{k, 2} = rssi_temp;
    end

end
