function frame_ap_info = point_to_beacon_dist_error(frame_ap_info, beacon_info)
%���ܣ���λ���ű�ļ���������
%���壺frame_ap_info = point_to_beacon_dist_error(frame_ap_info, beacon_info)
%������ 
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).name����i���ű������
%                   frame_ap_info(i).lat����i���ű��γ��
%                   frame_ap_info(i).lon����i���ű�ľ���
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%    beacon_info����λ�������ű����Ϣ,�ṹ������,������ʽ���£�
%                 beacon_info(i).name����i���ű������
%                 beacon_info(i).id����i���ű��ID��
%                 beacon_info(i).lat����i���ű��γ��
%                 beacon_info(i).lon����i���ű�ľ���
%                 beacon_info(i).dist����i���ű����λ��ʵ�ʾ���,��λ��m
%�����
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).name����i��ap������
%                   frame_ap_info(i).id����i��ap��ID��(�ű�ID��)
%                   frame_ap_info(i).lat����i��ap��γ��
%                   frame_ap_info(i).lon����i��ap�ľ���
%                   frame_ap_info(i).dist����i��ap���λ�ļ������,��λ��m
%                   frame_ap_info(i).true_dist����i��ap���λ��ʵ�ʾ���,��λ��m
%                   frame_ap_info(i).dist_error����i��ap���λ��ʵ�ʾ���
%                                                ����ʵ��������,��λ��m
%��ע��frame_ap_info(i)��beacon_info(i)Ԫ�ؿɶ���˵�������ᵽ��Ԫ��,��˵������
%     �ᵽ��Ԫ�ر������

    ap_num = length(frame_ap_info);
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    beacon_dist = zeros(beacon_num, 1);
    beacon_id = zeros(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
        beacon_dist(i) = beacon_info(i).dist;
        beacon_id(i) = beacon_info(i).id;
    end
    
    for i = 1:ap_num
        true_dist = beacon_dist(ismember(beacon_name, frame_ap_info(i).name) == 1);
        id = beacon_id(ismember(beacon_name, frame_ap_info(i).name) == 1);
        
        if isempty(true_dist)
            frame_ap_info(i).true_dist = -1;
            frame_ap_info(i).dist_error = -1;
            frame_ap_info(i).id = -1;
            continue;
        end
        
        if length(true_dist) > 1
            error(['����������ͬ����(', frame_ap_info(i).name, ')���ű�']);
        end
        
        frame_ap_info(i).id = id;
        frame_ap_info(i).true_dist = true_dist;
        frame_ap_info(i).dist_error = abs(true_dist - frame_ap_info(i).dist);
    end
end