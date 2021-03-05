function pos_res = location_least_squares(ap)
%���ܣ���С���˷�
%���壺pos_res = location_least_squares(ap)
%������ 
%    ap�����ڼ��㾭γ�ȵĲο�����Ϣ
%�����
%    pos_res�������λ�ý��������Ϊ�ṹ�壬����Ԫ�����£�
%             pos_res.lat��γ��
%             pos_res.lon������

    %��ȡ������С���˷������ݣ����롢���꣩
    ap_num = length(ap);
    lat = zeros(ap_num, 1);
    lon = zeros(ap_num, 1);
    x = zeros(ap_num, 1);
    y = zeros(ap_num, 1);
    dist = zeros(ap_num, 1);
    lam = 0;
    
    for i = 1:ap_num
        lat(i) = ap(i).lat;
        lon(i) = ap(i).lon;
        [x(i), y(i), lam] = latlon_to_xy(lat(i), lon(i));
        dist(i) = ap(i).dist;
    end
    
    if ap_num > 2
        %���ٴ���3���ο���ʱ,ʹ����С���˷�
        %������������
        matrix_a = zeros(ap_num - 1, 2);
        matrix_b = zeros(ap_num - 1, 1);
        tmp = x(1)^2 + y(1)^2 - dist(1)^2;
        
        for i = 2:ap_num
            matrix_a(i, 1) = x(i) - x(1);
            matrix_a(i, 2) = y(i) - y(1);
            matrix_b(i) = (x(i)^2 + y(i)^2 - dist(i)^2 - tmp) * 0.5;
        end
        
        xy_dst = inv(matrix_a' * matrix_a) * matrix_a' * matrix_b; 
        [pos_res.lat, pos_res.lon] = xy_to_latlon(xy_dst(1), xy_dst(2), lam);
    elseif (ap_num > 0) && (ap_num <= 2) 
        %�вο���,������3����,ʹ������
        pos_res.lat = mean(lat);
        pos_res.lon = mean(lon);
    else
        %�����ڲο���
        pos_res = [];
    end
end