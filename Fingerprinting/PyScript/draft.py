# -*- coding: utf-8 -*-
"""
Created on Tue Dec  7 22:17:58 2021

@author: W-H
"""

import re
from scipy import io
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
import os

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


df_aa = pd.DataFrame({'zh': ['zhang', 'li', 'wang', 'zhao'],
                      'hero': ['达摩', '典韦', '曹操', '李白'],
                      'score': ['85', '73', '66', '81']})
df_zz = pd.DataFrame({'en': ['wang', 'zhao', 'Trump', 'Obama'],
                      'hero': ['曹操', '墨子', '曹操', '李白'],
                      'level': ['青铜', '白银', '黄金', '钻石']})
df_concat = pd.concat([df_aa, df_zz])         # 默认沿axis=0，join=‘out’的方式进行concat
df_igno_idx = pd.concat([df_aa, df_zz], ignore_index=True)
'''
# 重新设定index(效果类似于pd.concat([df1,df2]).reset_index(drop=True))
'''
df_col = pd.concat([df_aa, df_zz], axis=1)
# %%


a = np.mat('1,2,3;4,5,6')

b = np.array([[1, 1, 1], [2, 2, 2]])

io.savemat('a.mat', {'matrix': a})

io.savemat('b.mat', {'array': b})
# %%


def test_args(*args, **kwargs):
    print(args, type(args))
    if len(args):
        for k in args:
            print(k)
    print(kwargs, type(kwargs))
    if len(kwargs):
        if 'wa' in kwargs.keys():
            print(kwargs['wa'])
        for k_val, k_key in zip(kwargs.values(), kwargs.keys()):
            print(k_val, k_key)


# %%
test_args(1, 2, wa=1, ka=2)
# %%
scores = np.random.rand(50, 1)
k = np.argmax(scores)  # 选择score最大的k
# 绘制超参数k与score的关系曲线
plt.plot(range(scores.shape[0]), scores, '-o', linewidth=2.0)
plt.plot(k, scores[k], color='red', marker='o')
plt.text(k, scores[k], 'k:'+str(k), fontsize=15)
plt.xlabel("k")
plt.ylabel("score")
plt.grid(True)
plt.title("不同K值拟合效果")
plt.show()
# %%
beacon_latlon_1 = [30.5478754, 104.0585674]
beacon_latlon_0 = [30.547880364315, 104.058728300713]
beacon_latlon_6 = [30.548014837274, 104.058567183453]
beacon_latlon_7 = [30.548018797743, 104.058730768827]
dist_1 = utm_distance(beacon_latlon_1[0], beacon_latlon_1[1],
                      beacon_latlon_0[0], beacon_latlon_0[1])
print(dist_1)

# %%
test_file = r'../Data/BLE-FINGERPRING/7-6.txt'
file_name = os.path.splitext(os.path.split(test_file)[-1])[0]
a = re.findall(r'\d{1,}', file_name)

# %%

# Fixing random state for reproducibility
np.random.seed(19680801)


N = 50
x = np.random.rand(N)
y = np.random.rand(N)
colors = np.random.rand(N)
area = (30 * np.random.rand(N))**2  # 0 to 15 point radii

plt.scatter(x, y, s=area, c=colors, alpha=0.5)
plt.show()
# %%
a1 = np.array([[1, 2, 3], [4, 5, 6]])
b1 = np.array([1, 2, 3])
a2 = np.array([1, 2, 3])
b2 = np.array([1, 2, 3])
a1 * b1  # 对应元素相乘
a1 @ b1  # 　矩阵相乘
a2 * b2  # 　对应元素相乘
a2 @ b2  # 　矩阵相乘
np.multiply(a1, b1)  # 对应元素相乘
np.multiply(a2, b2)  # 对应元素相乘
# 矩阵相乘
np.dot(a1, b1)
np.dot(a2, b2)
# 矩阵相乘
np.matmul(a1, b1)
np.matmul(a2, b2)

a = np.mat('1,2,3;4,5,6')
# %%
for j in range(1, 5, 1):
    print(j)
s = 1
#%% 
from tqdm import tqdm
import time
for i in tqdm(range(10000)):
    time.sleep(0.01)
