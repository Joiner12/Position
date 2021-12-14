# -*- coding: utf-8 -*-
"""
Created on Tue Dec  7 22:17:58 2021

@author: W-H
"""

import math
from pylab import mpl
from scipy.stats import norm
from scipy import misc
from scipy.ndimage import gaussian_filter
from itertools import product
import pandas as pd
from geomodel import latlon_to_xy, xy_to_latlon, utm_distance
import numpy as np
from math import pow
from bledatabase import get_valid_data
import matplotlib.pyplot as plt
# %%
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

# %%
df = pd.DataFrame([[1, 2], [4, 5], [7, 8]],
                  index=['cobra', 'viper', 'sidewinder'],
                  columns=['max_speed', 'shield'])
print(df)
print(df.loc[df['shield'] > 6])
print(df.loc[df['shield'] > 6, ['max_speed']])

df1 = pd.DataFrame(columns=['fg', 'pos'])
# df1 = pd.DataFrame([[0, -43, -61, -63],
#                     [0, -43, -66, -63],
#                     [0, -43, -68, -63]])
df1.at[0, 'fg'] = [0, -43, -61, -63]
df1.at[1, 'fg'] = [0, -43, -66, -63]
df1.at[2, 'fg'] = [0, -43, -68, -63]
df1.at[:, 'pos'] = 'pos1'

# %%
ble_data = get_valid_data(
    r'../Data/BLE-FINGERPRING-BKP/0-0.txt',
    beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])

beacon0_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon0', 'RSSI']
beacon1_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon1', 'RSSI']
beacon6_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon6', 'RSSI']
beacon7_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon7', 'RSSI']
fig, ax = plt.subplots(2, 2)
ax[0, 0].plot(beacon0_rssi, marker='*', linestyle='none')

ax[0, 0].set(xlabel='serial (n)', ylabel='RSSI (dBm)',
             title='beacon0')
ax[0, 0].grid()
ax[0, 1].plot(beacon1_rssi, marker='*', linestyle='none')

ax[0, 1].set(xlabel='serial (n)', ylabel='RSSI (dBm)',
             title='beacon1')
ax[0, 1].grid()
ax[1, 0].plot(beacon6_rssi, color='red', marker='*', linestyle='none')

ax[1, 0].set(xlabel='serial (n)', ylabel='RSSI (dBm)',
             title='beacon6')
ax[1, 0].grid()
ax[1, 1].plot(beacon7_rssi, marker='*', linestyle='none')

ax[1, 1].set(xlabel='serial (n)', ylabel='RSSI (dBm)',
             title='beacon7')
ax[1, 1].grid()
plt.show()
# %%
# %%
a = [0]
b = [-43.0]
c = [-66.0, -68.0, -61.0]
d = [-63.0]
for i_1 in a:
    for i_2 in b:
        for i_3 in c:
            for i_4 in d:
                print([i_1, i_2, i_3, i_4])
print('----------------------------------------')
for k_1 in product(a, b, c, d):
    print(list(k_1))

# %%
A = np.array([1, 2, 3, 4])
B = np.array([5, 6, 7])
C = np.concatenate((A, B, B), axis=0)
print(C)

# %%
fig = plt.figure()
# plt.gray()  # show the filtered result in grayscale
ax1 = fig.add_subplot(121)  # left side
ax2 = fig.add_subplot(122)  # right side
result = gaussian_filter(list(beacon0_rssi), sigma=2)
ax1.plot(beacon0_rssi)
ax2.plot(result)
plt.show()
# %%

# Generate some data for this demonstration.
# data = norm.rvs(10.0, 2.5, size=500)
data = list(beacon0_rssi)

# Fit a normal distribution to the data:
mu, std = norm.fit(data)

# Plot the histogram.
plt.hist(data, bins=10, density=True, alpha=0.6)

# Plot the PDF.
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = norm.pdf(x, mu, std)
plt.plot(x, p,  linewidth=2)
data = list(beacon1_rssi)

# Fit a normal distribution to the data:
mu, std = norm.fit(data)

# Plot the histogram.
plt.hist(data, bins=10, density=True, alpha=0.6)

# Plot the PDF.
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = norm.pdf(x, mu, std)
plt.plot(x, p,  linewidth=2)
data = list(beacon6_rssi)

# Fit a normal distribution to the data:
mu, std = norm.fit(data)

# Plot the histogram.
plt.hist(data, bins=10, density=True, alpha=0.6)

# Plot the PDF.
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = norm.pdf(x, mu, std)
plt.plot(x, p,  linewidth=2)
data = list(beacon7_rssi)

# Fit a normal distribution to the data:
mu, std = norm.fit(data)

# Plot the histogram.
plt.hist(data, bins=10, density=True, alpha=0.6)

# Plot the PDF.
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = norm.pdf(x, mu, std)
plt.plot(x, p,  linewidth=2)
plt.show()
# %%
mpl.rcParams['font.sans-serif'] = ['STZhongsong']    # 指定默认字体：解决plot不能显示中文问题
mpl.rcParams['axes.unicode_minus'] = False           # 解决保存图像是负号'-'显示为方块的问题

fig = plt.figure()
plt.gray()  # show the filtered result in grayscale
ax1 = fig.add_subplot(121)  # left side

ax2 = fig.add_subplot(122)  # right side

ascent = misc.ascent()
result = gaussian_filter(ascent, sigma=5)
ax1.set_title('原始图像')
ax2.set_title('sigma=5,高斯模糊')
ax1.imshow(ascent)
ax2.imshow(result)
plt.show()
# %%


def normal_distribution(x, mean, sigma):
    return np.exp(-1*((x-mean)**2)/(2*(sigma**2)))/(math.sqrt(2*np.pi) * sigma)


print(normal_distribution(1, 0, 1), normal_distribution(
    0, 0, 1), normal_distribution(1, 0, 1))
b = [0.24197072451914337, 0.3989422804014327, 0.24197072451914337]
# %%
mean1, sigma1 = 0, 1
x1 = np.linspace(mean1 - 6*sigma1, mean1 + 6*sigma1, 100)

mean2, sigma2 = 0, 2
x2 = np.linspace(mean2 - 6*sigma2, mean2 + 6*sigma2, 100)

mean3, sigma3 = 5, 1
x3 = np.linspace(mean3 - 6*sigma3, mean3 + 6*sigma3, 100)

y1 = normal_distribution(x1, mean1, sigma1)
y2 = normal_distribution(x2, mean2, sigma2)
y3 = normal_distribution(x3, mean3, sigma3)

plt.plot(x1, y1, label='m=0,sig=1')
#plt.plot(x2, y2, label='m=0,sig=2')
#plt.plot(x3, y3, label='m=1,sig=1')
plt.legend()
plt.grid()
plt.show()
# %%
a = np.arange(5)
a[0] = 4

# %%
import pandas as pd


df_aa = pd.DataFrame({'zh':['zhang','li','wang','zhao'],
                      'hero':['达摩','典韦','曹操','李白'],
                      'score':['85','73','66','81']})
df_zz = pd.DataFrame({'en':['wang','zhao','Trump','Obama'],
                      'hero':['曹操','墨子','曹操','李白'],
                      'level':['青铜','白银','黄金','钻石']})
df_concat = pd.concat([df_aa,df_zz])         # 默认沿axis=0，join=‘out’的方式进行concat
df_igno_idx = pd.concat([df_aa,df_zz], ignore_index=True)
'''
# 重新设定index(效果类似于pd.concat([df1,df2]).reset_index(drop=True))
'''
df_col = pd.concat([df_aa,df_zz], axis=1)
