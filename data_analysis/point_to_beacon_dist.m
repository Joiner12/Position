function beacon_info = point_to_beacon_dist(point, beacon_info)
%���ܣ���λ���ű����ʵ����
%���壺beacon_info = point_to_beacon_dist(point, beacon_info)
%������ 
%    point����λ��γ��,�ṹ��,������ʽ���£�
%          point.lat��γ��
%          point.lat������
%    beacon_info�������ű��λ����Ϣ,�ṹ������,������ʽ���£�
%                beacon_info(i).name����i���ű������
%                beacon_info(i).id����i���ű��ID��
%                beacon_info(i).lat����i���ű��γ��
%                beacon_info(i).lon����i���ű�ľ���
%�����
%    beacon_info����λ�������ű�ľ���,�ṹ������,������ʽ���£�
%                beacon_info(i).name����i���ű������
%                beacon_info(i).id����i���ű��ID��
%                beacon_info(i).lat����i���ű��γ��
%                beacon_info(i).lon����i���ű�ľ���
%                beacon_info(i).dist����i���ű����λ�ľ���
%��ע��frame_ap_info(i)��beacon_info(i)Ԫ�ؿɶ������������ᵽ��Ԫ��,��˵������
%     �ᵽ��Ԫ�ر������

    beacon_info_num = length(beacon_info);
    
    for i = 1:beacon_info_num
        beacon_info(i).dist = utm_distance(point.lat, point.lon, ...
                                           beacon_info(i).lat, beacon_info(i).lon);
    end
end