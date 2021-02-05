function dist = utm_distance(lat1, lon1, lat2, lon2)
%功能：计算两个经纬度点（度格式）的UTM坐标的距离
%定义：dist = utm_distance(lat1, lon1, lat2, lon2)
%参数： 
%    lat1：第一个点的纬度
%    lon1：第一个点的经度
%    lat2：第一个点的纬度
%    lon2：第一个点的经度
%输出：
%    dist：两个点间的UTM坐标的距离(单位：m)

    [x1, y1, lam1] = latlon_to_xy(lat1, lon1);
    [x2, y2, lam2] = latlon_to_xy(lat2, lon2);
    dist_x = x1 - x2;
    dist_y = y1 - y2;
    dist = (dist_x^2 + dist_y^2)^0.5;
end