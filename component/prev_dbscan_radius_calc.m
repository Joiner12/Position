function radius = prev_dbscan_radius_calc(ap, param)
%���ܣ�����DBSCAN���������뾶
%���壺radius = prev_dbscan_radius_calc(ap, param)
%������ 
%    ap��ap���ݣ����㷨ʹ��ÿ��ap�еľ�γ����Ϣ��
%    param����������,��������
%           param.radius_max������뾶���ֵ
%�����
%    radius������õ���DBSCAN���������뾶

    ap_num = length(ap);
    dist_buffer_num = 0;
    dist_buffer = [];
    radius_max = param.radius_max;

    %����������룬����С��radius_max�ľ���
    for i = 1:ap_num
        for j = (i + 1):ap_num
            dist = utm_distance(ap(i).lat, ap(i).lon, ap(j).lat, ap(j).lon);
            
            if dist < radius_max
                dist_buffer_num = dist_buffer_num + 1;
                dist_buffer(dist_buffer_num) = dist;
            end
        end
    end
    
    %��������뾶
    if isempty(dist_buffer) 
        %�������붼���ڵ���radius_max������뾶ȡradius_max
        radius = radius_max; 
    else
        radius = mean(dist_buffer) + 100;
    end
end 
    