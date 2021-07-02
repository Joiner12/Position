function parse_data = get_std_dist_rssi_data(varargin)
    % ����:
    %       �ӱ�׼������������ȡRSSI-distance��Ӧֵ��
    % ����:
    %       parse_data = get_std_dist_rssi_info(varargin)
    % ���룺
    %       src_folder:ԭʼ�����ļ���(e.g: d:xx\xx\xx\);
    %       ap_filter:apmsg�˲�����cell���ݽṹ���磺{'A3','A7'}
    %       varargin:��������
    %       'figure',����ͼʾ
    %       'statistical',ͳ����Ϣ
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
            error('access point ��Ϊcell��������.\n');
        end

    end

    %%
    [file, path] = uigetfile(fullfile(src_folder, '*.txt'), 'Multiselect', 'on');
    % δѡ���ļ�
    if isequal(file, 0)
        warning('selection of files canceled');
        return;
    end

    a = tic();
    % ���ļ��͵��ļ�����
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

    % ���ݽ���
    data_part_cnt = 1;

    for j = 1:1:file_cnt
        cur_file = file_selected{j, 1};
        [~, cur_file_name, ~] = fileparts(cur_file);

        % �����ļ�����ȡ����
        if false
            distance_temp = strrep(cur_file_name, '-', '_'); % Դ����������ʽ:HLK-1m-50cm.txt
            expr = '-[0-9]{1,2}|-[0-9]{2,}';
            distance_temp = regexp(cur_file_name, expr, 'match');
            distance_temp = strrep(distance_temp, '-', '');
            distance_temp = str2double(distance_temp);
            distance = -1; % ��ʵ����

            if isequal(length(distance_temp), 2)
                distance = distance_temp(1) + distance_temp(2) / 100;
            end

        else
            distance_temp = strrep(cur_file_name, 'ch39-', ''); % Դ����������ʽ:ch39-1m.txt
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

                % ͳ����Ϣ
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
            % ͳ����Ϣ
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

    %% ��ͼ
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
