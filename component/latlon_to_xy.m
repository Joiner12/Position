function [x, y, lam0] = latlon_to_xy(lat, lon)
%功能：横轴墨卡托投影，将地图经纬度转换为平面直角坐标(BL to UTM)
%定义：[x, y, lam0] = latlon_to_xy(lat, lon)
%参数： 
%    lat：纬度
%    lon：经度
%输出：
%    x(UTME)：平面直角坐标x(东向)
%    y(UTMN)：平面直角坐标y(北向)
%    lam0：当前点所在时区

    %自然常数
    earth_long_axis = 6378137.0;    %地球长轴
    earth_short_axis = 6356752.314; %地球短轴
    utm_scale_factor = 0.9996;      %横轴墨卡托到UTM的比例系数
    north_factor = 500000.0;        %北半球比例因子
    Zonenum = fix(lon / 6) + 31;
    lam0 = (Zonenum-1) * 6 - 180 + 3;
    lam0 = lam0 * pi / 180;
    phi = lat * pi / 180; 
    lam = lon * pi / 180;

    n = (earth_long_axis - earth_short_axis)...
        / (earth_long_axis + earth_short_axis);
    alpha = ((earth_long_axis + earth_short_axis) / 2.0)...
            * (1.0 + n^2 / 4.0 + n^4 / 64.0);
    beta = (-3.0 * n / 2.0) + (9.0 * n^3 / 16.0) + (-3.0 * n^5 / 32.0);
    gamma = (15.0 * n^2 / 16.0) + (-15.0 * n^4 / 32.0);
    delta = (-35.0 * n^3 / 48.0) + (105.0 * n^5 / 256.0);
    epsilon = (315.0 * n^4 / 512.0);
    bphi = alpha * (phi + (beta * sin(2.0 * phi))...
           + (gamma * sin(4.0 * phi))...
           + (delta * sin(6.0 * phi))...
           + (epsilon * sin(8.0 * phi)));

    ep2 = (earth_long_axis^2 - earth_short_axis^2) / earth_short_axis^2;
    nu2 = ep2 * cos(phi)^2; 
    n = earth_long_axis^2 / sqrt(earth_long_axis^2 * cos(phi)^2 ...
        + earth_short_axis^2 * sin(phi)^2);
    t = tan (phi);
    t2 = t * t;
    l = lam - lam0;

    l3coef = 1 - t2 + nu2;
    l4coef = 5 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2);
    l5coef = 5 - 18 * t2 + (t2 * t2) + 14 * nu2 - 58 * t2 * nu2;
    l6coef = 61 - 58 * t2 + (t2 * t2) + 270 * nu2 - 320 * t2 * nu2;
    l7coef = 61 - 479 * t2 + 179 * (t2 * t2) - (t2 * t2 * t2);
    l8coef = 1385 - 3111 * t2 + 543 * (t2 * t2) - (t2 * t2 * t2);

    x = n * cos (phi) * l + (n / 6.0 * cos(phi)^3 * l3coef * l^3)...
        + (n / 120.0 * cos(phi)^5 * l5coef * l^5)...
        + (n / 5040.0 * cos(phi)^7 * l7coef * l^7);

    y = bphi + (t / 2.0 * n * cos(phi)^2 * l^2)...
             + (t / 24.0 * n * cos(phi)^4 * l4coef * l^4)...
             + (t / 720.0 * n * cos(phi)^6 * l6coef * l^6)...
             + (t / 40320.0 * n * cos(phi)^8 * l8coef * l^8);

    x = x * utm_scale_factor + north_factor;
    y = y * utm_scale_factor;
    if (y < 0.0)
        y = y + 10000000.0;
    end
end