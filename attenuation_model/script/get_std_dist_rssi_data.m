function parse_data = get_std_dist_rssi_data(varargin)
    % 功能:
    %       从标准测试数据中提取RSSI-distance对应值。
    % 定义:
    %       parse_data = get_std_dist_rssi_info(varargin)
    % 输入：
    %       src_folder:原始数据文件夹(e.g: d:xx\xx\xx\);
    %       ap_filter:apmsg滤波器，cell数据结构，如：{'A3','A7'}
    %       varargin:保留参数
    %       'figure',绘制图示
    %       'statistical',统计信息
    % 输出:
    %       parse_data:解析数据(cell)
    % example:
    % get_std_dist_rssi_info(__,name,value);
    % get_std_dist_rssi_info('src_foler',D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\script);
    % 从D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\script获取源文件。

    %% 函数参数默认值
    src_folder = pwd(); % 数据源路径
    % tar_folder = src_folder; % 保存路径
    ap_filter = cell(0); % apmsg滤波选项
    parse_data = cell(0); % 解析数据

    %% 源文件路径
    if ~isempty(find(strcmpi(varargin, 'src_folder'), 1))
        src_folder = varargin{find(strcmpi(varargin, 'src_folder')) + 1};

        if ~isfolder(src_folder)
            error('no such folder %s \n', src_folder);
        end

    end

    %% apmsg
    if ~isempty(find(strcmpi(varargin, 'ap_filter'), 1))
        ap_filter = varargin{find(strcmpi(varargin, 'ap_filter')) + 1};

        if ~isa(ap_filter, 'cell')
            error('access point 不为cell数据类型.\n');
        end

    end

    %%
    [file, path] = uigetfile(fullfile(src_folder, '*.txt'), 'Multiselect', 'on');
    % 未选择文件
    if isequal(file, 0)
        warning('selection of files canceled');
        return;
    end

    a = tic();
    % 多文件和单文件区分
    file_selected = cell(0);
    file_cnt = 1;

    if ~isa(file, 'cell')
        file_selected{1, 1} = fullfile(path, file);
    else
        file_cnt = length(file);
        file = reshape(file, [file_cnt, 1]);

        for i = 1:1:file_cnt
            cur_file = fullfile(path, file{i});
            file_selected{i, 1} = cur_file;
        end

    end

    % 数据解析
    data_part_cnt = 1;

    for j = 1:1:file_cnt
        cur_file = file_selected{j, 1};
        [~, cur_file_name, ~] = fileparts(cur_file);

        % 根据文件名获取距离
        if false
            distance_temp = strrep(cur_file_name, '-', '_'); % 源数据命名格式:HLK-1m-50cm.txt
            expr = '-[0-9]{1,2}|-[0-9]{2,}';
            distance_temp = regexp(cur_file_name, expr, 'match');
            distance_temp = strrep(distance_temp, '-', '');
            distance_temp = str2double(distance_temp);
            distance = -1; % 真实距离

            if isequal(length(distance_temp), 2)
                distance = distance_temp(1) + distance_temp(2) / 100;
            end

        else
            distance_temp = strrep(cur_file_name, 'ch39-', ''); % 源数据命名格式:ch39-1m.txt
            distance_temp = str2double(strrep(distance_temp, 'm', ''));
            distance = distance_temp;
        end

        if ~isempty(ap_filter)

            for k = 1:1:length(ap_filter)
                filter_temp = ap_filter{k};
                rssi_temp = get_rssi_info(cur_file, filter_temp);
                % gauss-filter
                lgmf_val = like_gaussian_filter(rssi_temp, 1, 'mean');
                % mean
                mean_val = mean(rssi_temp);
                data_temp_s = struct('distance', distance, 'apInfo', filter_temp, ...
                    'RSSI', rssi_temp, 'lgmf_val', lgmf_val, 'mean_val', mean_val);

                % 统计信息
                if any(strcmpi(varargin, 'statistical'))
                    [~, v_val, k_val, s_val] = get_rssi_statistics(rssi_temp);
                    data_temp_s.v_val = v_val;
                    data_temp_s.k_val = k_val;
                    data_temp_s.s_val = s_val;
                end

                parse_data{data_part_cnt} = data_temp_s;
                data_part_cnt = data_part_cnt + 1;
            end

        else
            rssi_temp = get_rssi_info(cur_file);
            % gauss-filter
            lgmf_val = like_gaussian_filter(rssi_temp, 1, 'mean');
            % mean
            mean_val = mean(rssi_temp);
            data_temp_s = struct('distance', distance, 'apInfo', '', ...
                'RSSI', rssi_temp, 'lgmf_val', lgmf_val, 'mean_val', mean_val);
            % 统计信息
            if any(strcmpi(varargin, 'statistical'))
                [~, v_val, k_val, s_val] = get_rssi_statistics(rssi_temp);
                data_temp_s.v_val = v_val;
                data_temp_s.k_val = k_val;
                data_temp_s.s_val = s_val;
            end

            parse_data{data_part_cnt} = data_temp_s;
            data_part_cnt = data_part_cnt + 1;
        end

    end

    %% 绘图
    if any(strcmpi(varargin, 'figure'))
        fig_num = ceil(data_part_cnt / 4);

        for k1 = 1:1:fig_num
            figure('color', 'white', 'name', strcat('fig-', num2str(k1)))

            for k2 = 1:1:4

                if (k1 - 1) * 4 + k2 > data_part_cnt - 1
                    break;
                end

                subplot(2, 2, k2)
                data_temp = parse_data{(k1 - 1) * 4 + k2};
                plot(data_temp.RSSI, 'Marker', '*')
                title(strcat('distance:', num2str(data_temp.distance)))
            end

        end

    end

    toc(a);
end
