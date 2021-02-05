function blu_data_analyse_dynamic()
%���ܣ���̬���ݷ�����
%��ϸ�����������������ڲ�ͬλ��ɨ�����ݣ���������ɨ�赽�Ĳ�ͬλ�õ����ݰ�ap��ȡ��
%         ����ÿ��ap�ڲ�ͬλ��ɨ�赽��rssi���ݵľ�ֵ������ͼ�У�ͬʱ��ÿ��ap��
%         ��ͬλ�õĶ����ʻ�����ͼ�У��ɷ���ap�ź�������˥������
%��ע���������ļ�����ʽ����Ϊ *_dist���ļ��������һ��_���dist��ʾ���ݲɼ�����

%��ȡ�ļ�
% ����ȫ�ֱ�����������Է���
file_ap_info = struct([]); % struct
different_ap = struct([]);

% ��file_name : cell
[file_name, path] = uigetfile('*.*', 'MultiSelect', 'on');
if ~iscell(file_name)
    tmp = file_name;
    file_name = {''};
    file_name{1} = tmp;
end

%��ȡÿ���ļ�������
for i = 1:length(file_name)
    %��ȡ�ļ���
    % file = [path, file_name{i}];
    file = strcat(path,file_name{i});
    
    %�����ļ�����ȡ���ݲɼ��ľ���
    file_split = strsplit(file, '_');
    info = file_split{end};
    
    %�ж��ļ���ʽ�Ƿ���ȷ��*_dist���˴���δ��dist�����жϣ�
    if isempty(info) || (length(file_split) < 2)
        error('�ļ�������%s', file);
    end
    
    %ȥ���ļ����ͣ�.txt .m�ȣ�
    info_split = strsplit(info, '.');
    dist = info_split{1};
    
    %�жϾ�����Ϣ�Ƿ���ȷ��dist�Ƿ�Ϊ��Ч���֣�
    match = regexp(dist, '\d', 'match');
    if isempty(match) || (length(match) ~= length(dist))
        error('�ļ�������%s', file);
    end
    file_ap_info(i).dist = str2double(dist);
    
    % ���ļ����������� data:cell
    [data, file_ap_info(i).frame_num_total] = blu_data_file_parsing(file);
    
    % ��ȡ��ɨ�赽�����������и�����ͬap����Ϣ
    file_ap_info(i).ap_info = extract_different_ap_info(data);
end

%�������ݲɼ������ap���������ļ�������
% different_ap:struct
different_ap = settle_different_file_ap_in_dist(file_ap_info);
save('apdata.mat','different_ap','file_ap_info');
disp('finished');
% return
%% 
%���ƶ�̬����ͼ
handle = [];
figur_num = 0;

%����rssi���������
different_ap_num = length(different_ap);
ap_rssi = cell(1, different_ap_num);
ap_dist = cell(1, different_ap_num);
ap_frame_lose_rate = cell(1, different_ap_num);
for i = 1:different_ap_num
    num = 0;
    for j = 1:length(different_ap(i).dist)
        if isempty(different_ap(i).frame_rssi_mean{j}) || ...
                (different_ap(i).dist(j) == 0)
            continue;
        else
            num = num + 1;
            ap_rssi{i}{num} = different_ap(i).frame_rssi_mean{j};
            ap_dist{i}(num) = different_ap(i).dist(j);
            ap_frame_lose_rate{i}(num) = ...
                different_ap(i).frame_lose_rate(j);
        end
    end
end

%% figure-1 ����rssi�����Ķ�Ӧ��ϵ ��
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    targ = [different_ap(i).name, ' rssi�����Ķ�Ӧ��ϵ'];
    
    rssi_mean = zeros(1, len);
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
    end
    
    rssi_mean_max = max(rssi_mean);
    rssi_mean_min = min(rssi_mean);
    dist_max = max(dist);
    dist_min = min(dist);
    
    %����rssi���ھ���dist��״̬ͼ
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, rssi_mean, 'r*-');
    if dist_min == dist_max
        dist_max = dist_max + 1;
    end
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = rssi_mean_min - 5;
    y_idx_high = rssi_mean_max + 5;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('����');
    ylabel('rssi��ֵ');
end

%% figure-2���ƶ����������ı仯����ͼ ��
for i = 1:different_ap_num
    frame_lose_rate = ap_frame_lose_rate{i};
    dist = ap_dist{i};
    targ = [different_ap(i).name, ' �����������ı仯����'];
    
    lose_rate_max = max(frame_lose_rate);
    dist_max = max(dist);
    dist_min = min(dist);
    
    %����rssi���ھ���dist��״̬ͼ
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, frame_lose_rate, 'r*-');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = 0;
    y_idx_high = lose_rate_max + 0.3;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    %         axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    axis auto;
    title(targ);
    xlabel('����');
    ylabel('������');
end

%% ��ϲ�������
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    
    rssi_mean = zeros(1, len);
    rssi_max = zeros(1, len);
    rssi_min = zeros(1, len);
    
    %����������и�֡rssi�ľ�ֵ�������Сֵ
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
        rssi_max(j) = max(rssi{j});
        rssi_min(j) = min(rssi{j});
    end
    %�����������Ļ�������
    rssi_reference = rssi_mean(1);
    loss_coef = zeros(1, len);
    for j = 2:len
        loss_coef(j) = abs(rssi_mean(j) - rssi_reference) / ...
            (10 * log10(dist(j)));
    end
    
    if len >= 2
        loss_coef(1) = loss_coef(2);
    else
        loss_coef(1) = 0;
    end
    
    log_dist_max = zeros(1, len);
    log_dist_min = zeros(1, len);
    log_dist_mean = zeros(1, len);
    log_dist_max_mean = zeros(1, len);
    log_dist_min_mean = zeros(1, len);
    log_dist_mean_mean = zeros(1, len);
    loss_coef_mean = mean(loss_coef);
    for j = 1:len
        log_dist_min(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_max(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
            (10 * loss_coef(j)));
        log_dist_min_mean(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
        log_dist_max_mean(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
        log_dist_mean_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
            (10 * loss_coef_mean));
    end
    
    %% figure-4���ƻ����������ھ���dist�ı仯ͼ
    targ = [different_ap(i).name, ' �������������ı仯����'];
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, loss_coef, 'r*-');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    y_idx_low = 0;
    y_idx_high = max(loss_coef) + 0.3;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('����');
    ylabel('��������');
    
    %% figure-5���Ƹ���������ڸ��Ի��������ľ��뷶Χ
    targ = [different_ap(i).name, ' �ڸ�����ľ���ת����Χ'];
    figur_num = figur_num + 1;
    handle(figur_num) = figure;
    set(handle(figur_num), 'name', targ);
    plot(dist, log_dist_max, 'r*-');
    hold on;
    plot(dist, log_dist_min, 'b*-');
    hold on;
    plot(dist, log_dist_mean, 'g*-');
    hold on;
    plot(dist, log_dist_max_mean, 'm*-');
    hold on;
    plot(dist, log_dist_min_mean, 'c*-');
    hold on;
    plot(dist, log_dist_mean_mean, 'k*-');
    hold on;
    legend('���Ի�������ת���������ֵ', '���Ի�������ת��������Сֵ', ...
        '���Ի�������ת�������ֵ', '����������ֵת���������ֵ', ...
        '����������ֵת��������Сֵ', '����������ֵת�������ֵ');
    x_idx_low = dist_min;
    x_idx_hign = dist_max;
    tmp1 = max(log_dist_max);
    tmp2 = max(log_dist_min);
    tmp3 = min(log_dist_max);
    tmp4 = min(log_dist_min);
    y_idx_low = min(tmp3, tmp4) - 1;
    y_idx_high = max(tmp1, tmp2) + 1;
    if x_idx_low == x_idx_hign
        x_idx_hign = x_idx_hign + 1;
    end
    axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
    title(targ);
    xlabel('����');
    ylabel('rssiת�������');
end
end