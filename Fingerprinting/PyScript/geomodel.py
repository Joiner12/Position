# -*- coding: utf-8 -*-
"""
Created on Tue Dec  7 14:33:45 2021

@author: W-H
"""

# import matplotlib.pyplot as plt
import numpy as np
from math import pow

# 自然常数
earth_long_axis = 6378137.0    # 地球长轴
earth_short_axis = 6356752.314  # 地球短轴
utm_scale_factor = 0.9996      # 横轴墨卡托到UTM的比例系数
north_factor = 500000.0        # 北半球比例因子


def latlon_to_xy(lat: float, lon: float, *args, **kwargs):
    """ 横轴墨卡托投影，将地图经纬度转换为平面直角坐标(BL to UTM)
    这里是具体描述.

    参数
    ----------
    参数： 
    lat：float
        纬度
    lon：float
        经度

    返回值
    -------
    (x,y,z)
        x(UTME)：平面直角坐标x(东向)
        y(UTMN)：平面直角坐标y(北向)
        lam0：当前点所在时区
    """
    Zonenum = np.fix(lon / 6) + 31
    lam0 = (Zonenum-1) * 6 - 180 + 3
    lam0 = lam0 * np.pi / 180
    phi = lat * np.pi / 180
    lam = lon * np.pi / 180

    n = (earth_long_axis - earth_short_axis) / \
        (earth_long_axis + earth_short_axis)
    alpha = ((earth_long_axis + earth_short_axis) / 2.0) * \
        (1.0 + pow(n, 2) / 4.0 + pow(n, 4) / 64.0)
    beta = (-3.0 * n / 2.0) + (9.0 * pow(n, 3) / 16.0) + \
        (-3.0 * pow(n, 5) / 32.0)
    gamma = (15.0 * pow(n, 2) / 16.0) + (-15.0 * pow(n, 4) / 32.0)
    delta = (-35.0 * pow(n, 3) / 48.0) + (105.0 * pow(n, 5) / 256.0)
    epsilon = (315.0 * pow(n, 4) / 512.0)
    bphi = alpha * (phi + (beta * np.sin(2.0 * phi)) +
                    (gamma * np.sin(4.0 * phi)) +
                    (delta * np.sin(6.0 * phi)) +
                    (epsilon * np.sin(8.0 * phi)))

    ep2 = (pow(earth_long_axis, 2) - pow(earth_short_axis, 2)) / \
        pow(earth_short_axis, 2)
    nu2 = ep2 * pow(np.cos(phi), 2)
    n = pow(earth_long_axis, 2) / np.sqrt(pow(earth_long_axis, 2) * pow(np.cos(phi), 2)
                                          + pow(earth_short_axis, 2) * pow(np.sin(phi), 2))
    t = np.tan(phi)
    t2 = t * t
    l = lam - lam0

    l3coef = 1 - t2 + nu2
    l4coef = 5 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2)
    l5coef = 5 - 18 * t2 + (t2 * t2) + 14 * nu2 - 58 * t2 * nu2
    l6coef = 61 - 58 * t2 + (t2 * t2) + 270 * nu2 - 320 * t2 * nu2
    l7coef = 61 - 479 * t2 + 179 * (t2 * t2) - (t2 * t2 * t2)
    l8coef = 1385 - 3111 * t2 + 543 * (t2 * t2) - (t2 * t2 * t2)

    x = n * np.cos(phi) * l + (n / 6.0 * pow(np.cos(phi), 3) * l3coef * pow(l, 3)) \
        + (n / 120.0 * pow(np.cos(phi), 5) * l5coef * pow(l, 5)) \
        + (n / 5040.0 * pow(np.cos(phi), 7) * l7coef * pow(l, 7))

    y = bphi + (t / 2.0 * n * pow(np.cos(phi), 2) * pow(l, 2)) \
        + (t / 24.0 * n * pow(np.cos(phi), 4) * l4coef * pow(l, 4)) \
        + (t / 720.0 * n * pow(np.cos(phi), 6) * l6coef * pow(l, 6)) \
        + (t / 40320.0 * n * pow(np.cos(phi), 2) * l8coef * pow(l, 8))

    x = x * utm_scale_factor + north_factor
    y = y * utm_scale_factor
    if y < 0.0:
        y = y + 10000000.0
    return (x, y, lam0)


def xy_to_latlon(x: float, y: float, lam0: float, *args, **kwargs):
    """ 横轴墨卡托投影，将地图平面直角坐标转换为经纬度(UTM to BL)
        ----------
        参数： 
        x：float
            x(UTME)：平面直角坐标x(东向)
        y：float
            y(UTMN)：平面直角坐标y(北向)
        lam0: float
            当前点所在时区

        返回值
        -------
        lat: float
            latitude 纬度
        lon: float
            longitude 经度
    """

    n = (earth_long_axis - earth_short_axis) \
        / (earth_long_axis + earth_short_axis)
    x = x - north_factor
    x = x / utm_scale_factor
    y = y / utm_scale_factor

    alpha_ = ((earth_long_axis + earth_short_axis) / 2)  \
        * (1 + 1 / 4 * pow(n, 2) + 1 / 64 * pow(n, 4))
    y_ = y / alpha_
    beta_ = (3.0 * n / 2.0) + (-27.0 * pow(n, 3) / 32.0) + \
        (269.0 * pow(n, 5) / 512.0)
    gamma_ = (21.0 * pow(n, 2) / 16.0) + (-55.0 * pow(n, 4) / 32.0)
    delta_ = (151.0 * pow(n, 3) / 96.0) + (-417.0 * pow(n, 5) / 128.0)
    epsilon_ = (1097.0 * pow(n, 4) / 512.0)
    phif = y_ + (beta_ * np.sin(2.0 * y_)) + (gamma_ * np.sin(4.0 * y_)) \
              + (delta_ * np.sin(6.0 * y_)) + (epsilon_ * np.sin(8.0 * y_))

    ep2 = (pow(earth_long_axis, 2) - pow(earth_short_axis, 2)) / \
        pow(earth_short_axis, 2)
    cf = np.cos(phif)
    nuf2 = ep2 * pow(cf, 2)
    nf = pow(earth_long_axis, 2) / np.sqrt(pow(earth_long_axis, 2) * pow(np.cos(phif), 2)
                                           + pow(earth_short_axis, 2) * pow(np.sin(phif), 2))
    tf = np.tan(phif)

    x1frac = 1 / (nf * cf)
    x2frac = tf / (2 * pow(nf, 2))
    x3frac = 1 / (6 * pow(nf, 3) * cf)
    x4frac = tf / (24 * pow(nf, 4))
    x5frac = 1 / (120 * pow(nf, 5) * cf)
    x6frac = tf / (720 * pow(nf, 6))
    x7frac = 1 / (5040 * pow(nf, 7) * cf)

    x2poly = -1.0 - nuf2
    x3poly = -1.0 - 2*pow(tf, 2) - nuf2
    x4poly = 5.0 + 3.0 * pow(tf, 2) + 6.0 * nuf2 - 6.0 * pow(tf, 2) * nuf2  \
        - 3.0 * (nuf2 * nuf2) - 9.0 * pow(tf, 2) * (nuf2 * nuf2)
    x5poly = 5.0 + 28.0 * pow(tf, 2) + 24.0 * \
        pow(tf, 4) + 6.0 * nuf2 + 8.0 * pow(tf, 2) * nuf2
    x6poly = -61.0 - 90.0 * pow(tf, 2) - 45.0 * \
        pow(tf, 4) - 107.0 * nuf2 + 162.0 * pow(tf, 2) * nuf2
    x7poly = -61.0 - 662.0 * pow(tf, 2) - 1320.0 * \
        pow(tf, 4) - 720.0 * pow(tf, 6)

    lat = phif + x2frac * x2poly * pow(x, 2) + x4frac * x4poly * pow(x, 4)  \
               + x6frac * x6poly * pow(x, 6)
    lon = lam0 + x1frac * x + x3frac * x3poly * pow(x, 3)  \
               + x5frac * x5poly * pow(x, 5) + x7frac * x7poly * pow(x, 7)

    lat = lat * 180 / np.pi
    lon = lon * 180 / np.pi
    return (lat, lon)


def utm_distance(lat1: float, lon1: float, lat2: float, lon2: float, *args, **kwargs):
    """ 计算两个经纬度点（度格式）的UTM坐标的距离
        ----------
        参数： 
        lat1：float
            第一个点的纬度
        lon1：float
            第一个点的经度
        lat2：float
            第二个点的纬度
        lon2：float
            第二个点的经度

        返回值
        -------
        dist: float
            两个点间的UTM坐标的距离(单位：m)
        lon: float
            longitude 经度
    """
    [x1, y1, lam1] = latlon_to_xy(lat1, lon1)
    [x2, y2, lam2] = latlon_to_xy(lat2, lon2)
    dist_x = x1 - x2
    dist_y = y1 - y2
    dist = np.sqrt((pow(dist_x, 2) + pow(dist_y, 2)))
    return dist


if __name__ == "__main__":
    ret = latlon_to_xy(30.4547, 120.4455)
    print(ret)
