# -*- coding: utf-8 -*-
"""
Created on Tue Dec  7 22:17:58 2021

@author: W-H
"""

from geomodel import latlon_to_xy, xy_to_latlon, utm_distance
import numpy as np
from math import pow
degs = np.pi*30/180
print(np.sin(degs))
print(np.cos(degs))
print(np.tan(degs))
print(np.sqrt(4.1))
print(pow(3, 2))
ret = latlon_to_xy(30.4547, 120.4455)
print(ret)
dfs = utm_distance(30.4547, 120.4455, 30.4547, 120.4455)
print(dfs)
[lat, lon] = xy_to_latlon(ret[0], ret[1], ret[2])
print(ret)
