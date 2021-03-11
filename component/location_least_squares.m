function pos_res = location_least_squares(ap)
%功能：最小二乘法
%定义：pos_res = location_least_squares(ap)
%参数： 
%    ap：用于计算经纬度的参考点信息
%输出：
%    pos_res：计算的位置结果，数据为结构体，包含元素如下：
%             pos_res.lat：纬度
%             pos_res.lon：经度

    %提取用于最小二乘法的数据（距离、坐标）
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
        %至少存在3个参考点时,使用最小二乘法
        %构件特征矩阵
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
        %有参考点,但不足3个点,使用质心
        pos_res.lat = mean(lat);
        pos_res.lon = mean(lon);
    else
        %不存在参考点
        pos_res = [];
    end
end