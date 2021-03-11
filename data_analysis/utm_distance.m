function dist = utm_distance(lat1, lon1, lat2, lon2)
%���ܣ�����������γ�ȵ㣨�ȸ�ʽ����UTM����ľ���
%���壺dist = utm_distance(lat1, lon1, lat2, lon2)
%������ 
%    lat1����һ�����γ��
%    lon1����һ����ľ���
%    lat2����һ�����γ��
%    lon2����һ����ľ���
%�����
%    dist����������UTM����ľ���(��λ��m)

    [x1, y1, lam1] = latlon_to_xy(lat1, lon1);
    [x2, y2, lam2] = latlon_to_xy(lat2, lon2);
    dist_x = x1 - x2;
    dist_y = y1 - y2;
    dist = (dist_x^2 + dist_y^2)^0.5;
end