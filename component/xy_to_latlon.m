function [lat, lon] = xy_to_latlon(x, y, lam0)
    %功能：横轴墨卡托投影，将地图平面直角坐标转换为经纬度(UTM to BL)
    %定义：[lat, lon] = xy_to_latlon(x, y, lam0)
    %参数：
    %    x(UTME)：平面直角坐标x(东向)
    %    y(UTMN)：平面直角坐标y(北向)
    %    lam0：当前点所在时区
    %输出：
    %    lat：纬度
    %    lon：经度

    %自然常数
    earth_long_axis = 6378137.0; %地球长轴
    earth_short_axis = 6356752.314; %地球短轴
    utm_scale_factor = 0.9996; %横轴墨卡托到UTM的比例系数
    north_factor = 500000.0; %北半球比例因子

    n = (earth_long_axis - earth_short_axis) ...
        / (earth_long_axis + earth_short_axis);
    x = x - north_factor;
    x = x / utm_scale_factor;
    y = y / utm_scale_factor;

    alpha_ = ((earth_long_axis + earth_short_axis) / 2) ...
        * (1 + 1/4 * n^2 + 1/64 * n^4);
    y_ = y / alpha_;
    beta_ = (3.0 * n / 2.0) + (-27.0 * n^3/32.0) + (269.0 * n^5/512.0);
    gamma_ = (21.0 * n^2/16.0) + (-55.0 * n^4/32.0);
    delta_ = (151.0 * n^3/96.0) + (-417.0 * n^5/128.0);
    epsilon_ = (1097.0 * n^4/512.0);
    phif = y_ + (beta_ * sin(2.0 * y_)) + (gamma_ * sin(4.0 * y_)) ...
        + (delta_ * sin(6.0 * y_)) + (epsilon_ * sin(8.0 * y_));

    ep2 = (earth_long_axis^2 - earth_short_axis^2) / earth_short_axis^2;
    cf = cos (phif);
    nuf2 = ep2 * cf^2;
    nf = earth_long_axis^2 / sqrt(earth_long_axis^2 * cos(phif)^2 ...
        + earth_short_axis^2 * sin(phif)^2);
    tf = tan (phif);

    x1frac = 1 / (nf * cf);
    x2frac = tf / (2 * nf^2);
    x3frac = 1 / (6 * nf^3 * cf);
    x4frac = tf / (24 * nf^4);
    x5frac = 1 / (120 * nf^5 * cf);
    x6frac = tf / (720 * nf^6);
    x7frac = 1 / (5040 * nf^7 * cf);

    x2poly = -1.0 - nuf2;
    x3poly = -1.0 - 2 * tf^2 - nuf2;
    x4poly = 5.0 + 3.0 * tf^2 + 6.0 * nuf2 - 6.0 * tf^2 * nuf2 ...
        - 3.0 * (nuf2 * nuf2) - 9.0 * tf^2 * (nuf2 * nuf2);
    x5poly = 5.0 + 28.0 * tf^2 + 24.0 * tf^4 + 6.0 * nuf2 + 8.0 * tf^2 * nuf2;
    x6poly = -61.0 - 90.0 * tf^2 - 45.0 * tf^4 - 107.0 * nuf2 + 162.0 * tf^2 * nuf2;
    x7poly = -61.0 - 662.0 * tf^2 - 1320.0 * tf^4 - 720.0 * tf^6;

    lat = phif + x2frac * x2poly * x^2 + x4frac * x4poly * x^4 ...
        + x6frac * x6poly * x^6;
    lon = lam0 + x1frac * x + x3frac * x3poly * x^3 ...
        + x5frac * x5poly * x^5 + x7frac * x7poly * x^7;

    lat = lat * 180 / pi;
    lon = lon * 180 / pi;
end
