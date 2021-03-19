function draw_point_to_beacon_dist_analysis_chart(point, ...
                                                  frame_ap_info, ...
                                                  beacon_info)
%���ܣ����Ƶ�λ���ű�ľ������ͼ
%���壺draw_point_to_beacon_dist_analysis_chart(point, ...
%                                               frame_ap_info, ...
%                                               beacon_info)
%������ 
%    point����λ��γ��,�ṹ��,������ʽ���£�
%          point.lat��γ��
%          point.lat������
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).name����i���ű������
%                   frame_ap_info(i).lat����i���ű��γ��
%                   frame_ap_info(i).lon����i���ű�ľ���
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%    beacon_info�������ű��λ����Ϣ,�ṹ������,������ʽ���£�
%                beacon_info(i).name����i���ű������
%                beacon_info(i).id����i���ű��ID��
%                beacon_info(i).lat����i���ű��γ��
%                beacon_info(i).lon����i���ű�ľ���
%�����
%    
%��ע��frame_ap_info(i)��beacon_info(i)Ԫ�ؿɶ���˵�������ᵽ��Ԫ��,��˵������
%     �ᵽ��Ԫ�ر������

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
    
    %�ж��Ƿ������ͬ���ű�
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
    end
    
    if length(unique(beacon_name)) ~= beacon_num
        error('������ű꼯�д�����ͬ���ű�,��������֧����ͬ�ű�Ĵ���');
    end
    
    %�����λ���ű����ʵ����
    beacon = point_to_beacon_dist(point, beacon_info);
    
    %�����λ���ű�ļ���������
    ap = point_to_beacon_dist_error(frame_ap_info, beacon);
    
    %�ж��Ƿ������ͬ���ű��
    ap_id = zeros(ap_num, 1);
    
    for i = 1:ap_num
        ap_id(i) = ap(i).id; 
    end
    
    if length(unique(ap_id)) ~= ap_num
        error('�����ap���д���apӳ�䵽����ͬ���ű��,��������֧����ͬ�ű�ŵĴ���');
    end    
    
    %��ȡ�������
    calc_dist = zeros(ap_num, 1);
    for i = 1:ap_num
        calc_dist(i) = ap(i).dist;
    end
    
    %��ȡ��ʵ����
    true_dist = zeros(ap_num, 1);
    for i = 1:ap_num
        true_dist(i) = ap(i).true_dist;
    end
    
    %��ȡ�������
    dist_error = zeros(ap_num, 1);
    for i = 1:ap_num
        dist_error(i) = ap(i).dist_error;
    end
    
    error_max = max(dist_error);
    error_min = min(dist_error);
    
    %% ���Ʒ���ͼ
    handle = figure();
    set(handle, 'name', '��λ���ű�ľ������ͼ');
    
    %���ƾ���ͼ
    subplot(2, 1, 1);
    
    [x, sort_index] = sort(ap_id);
    y = calc_dist(sort_index);
    plot(x, y, 'r*');
    hold on;
    
    y = true_dist(sort_index);
    plot(x, y, 'g*');
    hold on;
    
    xlabel('�ű��');
    ylabel('���룺��');
    legend({'�������', '��ʵ����'});
    axis auto;
    
    %�������ͼ
    subplot(2, 1, 2);
    [x, sort_index] = sort(ap_id);
    y = dist_error(sort_index);
    
    plot(x, y, 'b*-');
    hold on;
    
    y = repelem(error_max, length(x));
    plot(x, y, 'r--');
    hold on;
    
    y = repelem(error_min, length(x));
    plot(x, y, 'g--');
    hold on;
    
    xlabel('�ű��');
    ylabel('��������');
    legend({'�������', ...
            ['����������ֵ��', num2str(error_max)], ...
            ['���������Сֵ��', num2str(error_min)]});
    axis auto;
end