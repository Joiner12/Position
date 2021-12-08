function draw_point_to_beacon_log_rssi_analysis(point, ...
                                                frame_ap_info, ...
                                                loss_coef, ...
                                                beacon_info)
%���ܣ��������ݶ���ģ�͵�rssi����ͼ
%���壺drwa_point_to_beacon_log_rssi_analysis(point, ...
%                                             frame_ap_info, ...
%                                             loss_coef, ...
%                                             beacon_info)
%������ 
%    point����λ��γ��,�ṹ��,������ʽ���£�
%          point.lat��γ��
%          point.lat������
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).id����i���ű��ID��
%                   frame_ap_info(i).rssi����λ���յ��ĵ�i���ű��rssi
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%                   frame_ap_info(i).rssi_reference����i���ű��1�״�rssi
%    loss_coef��·�����ϵ��
%    beacon_info�������ű��λ����Ϣ,�ṹ������,������ʽ���£�
%                beacon_info(i).name����i���ű������
%                beacon_info(i).id����i���ű��ID��
%                beacon_info(i).lat����i���ű��γ��
%                beacon_info(i).lon����i���ű�ľ���
%�����
%
%��ע��frame_ap_info(i)��beacon_info(i)Ԫ�ؿɶ���˵�������ᵽ��Ԫ��,��˵�������ᵽ��Ԫ�ر������

    %% ����Ԥ����
    %�жϽ��յ���ap�������Ƿ������ͬ���ű�
    ap_num = length(frame_ap_info);
    ap_name = cell(ap_num, 1);
    for i = 1:ap_num
       ap_name{i} = frame_ap_info(i).name; 
    end
    
    if length(unique(ap_name)) ~= ap_num
        error('�����ap���д�����ͬ��ap,��������֧����ͬap�Ĵ���');
    end    
    
    %�����λ���ű����ʵ����
    beacon = point_to_beacon_dist(point, beacon_info);
    
    %ȷ����ǰap���ű��
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    beacon_id = zeros(beacon_num, 1);
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
        beacon_id(i) = beacon_info(i).id;
    end
    
    if length(unique(beacon_name)) ~= beacon_num
        error('������ű꼯�д�����ͬ���Ƶ��ű�,��������֧����ͬ�����ű�Ĵ���');
    end
    
    if length(unique(beacon_id)) ~= beacon_num
        error('������ű꼯�д�����ͬ���ű��,��������֧����ͬ�ű�ŵĴ���');
    end
    
    beacon_index = zeros(ap_num, 1);
    for i = 1:ap_num
        index = find(ismember(beacon_name, frame_ap_info(i).name), beacon_num);
        if isempty(index)
            error(['��⵽ap(', frame_ap_info(i).name, ')���ű�ռ��ڲ�����,��������֧���ű�ռ��ڲ����ڵ�ap�����ݷ���']);
        end
        
        frame_ap_info(i).id = beacon_id(index);
        beacon_index(i) = index;
    end
    
    %��ȡ�յ�����ʵrssi
    rssi = zeros(ap_num, 1);
    for i = 1:ap_num
        rssi(i) = frame_ap_info(i).rssi;
    end
    
    %ͨ�������������rssi
    for i = 1:ap_num
        frame_ap_info(i).dist = beacon(beacon_index(i)).dist;
    end
    ap = reverse_rssi_basis_log(frame_ap_info, loss_coef);
    
    %��ȡ���Ƶ�rssi
    reverse_log_rssi = zeros(ap_num, 1);
    for i = 1:ap_num
        reverse_log_rssi(i) = ap(i).reverse_log_rssi;
    end
    
    %��ȡrssi���
    log_rssi_error = zeros(ap_num, 1);
    for i = 1:ap_num
        log_rssi_error(i) = ap(i).log_rssi_error;
    end
    
    log_rssi_error_max = max(log_rssi_error);
    log_rssi_error_min = min(log_rssi_error);
    
    %�ж��Ƿ������ͬ���ű��
    ap_id = zeros(ap_num, 1);
    for i = 1:ap_num
        ap_id(i) = ap(i).id;
    end
    
    if length(unique(ap_id)) ~= ap_num
        error('�����ap���д���apӳ�䵽����ͬ���ű��,��������֧����ͬ�ű�ŵĴ���');
    end    
    
    %% ���Ʒ���ͼ
    handle = figure();
    set(handle, 'name', '��λ���ű�ľ������ͼ');
    
    %����rssiͼ
    subplot(2, 1, 1);
    
    [x, sort_index] = sort(ap_id);
    y = rssi(sort_index);
    plot(x, y, 'r*');
    hold on;
    
    y = reverse_log_rssi(sort_index);
    plot(x, y, 'g*');
    hold on;
    
    xlabel('�ű��');
    ylabel('rssi');
    legend({'����rssi', '������ʵ�������Ƶ�rssi'});
    axis auto;
    
    %�������ͼ
    subplot(2, 1, 2);
    [x, sort_index] = sort(ap_id);
    y = log_rssi_error(sort_index);
    
    plot(x, y, 'b*-');
    hold on;
    
    y = repelem(log_rssi_error_max, length(x));
    plot(x, y, 'r--');
    hold on;
    
    y = repelem(log_rssi_error_min, length(x));
    plot(x, y, 'g--');
    hold on;
    
    xlabel('�ű��');
    ylabel('rssi���');
    legend({'rssi���', ...
            ['rssi������ֵ��', num2str(log_rssi_error_max)], ...
            ['rssi�����Сֵ��', num2str(log_rssi_error_min)]});
    axis auto;
end