# -*- coding: utf-8 -*-
"""
Created on Thu Dec  9 22:22:11 2021

@author: W-H
"""
import matplotlib.pyplot as plt
import numpy as np
from scipy.stats import multivariate_normal
from mpl_toolkits.mplot3d import Axes3D

from pylab import mpl
mpl.rcParams['font.sans-serif'] = ['STZhongsong']    # 指定默认字体：解决plot不能显示中文问题
mpl.rcParams['axes.unicode_minus'] = False           # 解决保存图像是负号'-'显示为方块的问题


def gauss_kernel(r, sigma, *args, **kwargs):
    """ 生成一维高斯滤波高斯核
    ---
    参数
    r:float
        核大小，通常为基数
    sigma: float
        标准差
    ---
    输出
    gauss_weight:array
        高斯核
    """
    gauss_weight = np.zeros(2*r+1)
    for i in range(1, 2*(r+1), 1):
        gauss_weight[i-1] = np.exp(-1*pow((i-r), 2) /
                                   (2*pow(sigma, 2))) / (sigma*np.sqrt(2*np.pi))
    return gauss_weight


def gaussian_filtering_1(data, kernel_cof, r):
    """ 一维高斯滤波
    ---
    参数
    data: array
        原始数据
    kernel_cof: array
        高斯核
    r: float
        核大小，通常为基数
    ---
    输出
    data_f: array
        滤波后数据
    说明
    高斯滤波是对原始数据进行核卷积运算，滤波中边界不进行处理
    data = [1,2,3,4,5]
    kernel_cof = [a1,a0,a1]
    data_f[0] = 1 # 保留原始数据
    data_f[1] = a1*data[1-1] + a0*data[1] + a1*data[1+1]
    .
    .
    .
    data[4] = 5
    """
    #
    data_y = np.zeros(data.size)
    data_len = data.size
    for k in range(data_len):
        if k < r or k > data_len-r-1:
            data_y[k] = data[k]
        else:
            temp = np.dot(data[k-r:k+r+1], kernel_cof)
            data_y[k] = temp
    return data_y


def test_1():
    # 生成测试数据
    data = np.random.rand(100)
    r = 2
    sigma = 5
    gauss_cof = gauss_kernel(r, sigma)
    data_y1 = gaussian_filtering_1(data, gauss_cof, r)
    r = 2
    sigma = 20
    gauss_cof = gauss_kernel(r, sigma)
    data_y2 = gaussian_filtering_1(data, gauss_cof, r)
    plt.plot(data, 'o-', alpha=0.8)
    plt.plot(data_y1, 'o-', alpha=0.8)
    plt.plot(data_y2, 'o-', alpha=0.8)
    plt.xlabel('采样周期T')
    plt.ylabel('y')
    plt.grid(axis='x', color='0.95')
    plt.legend(['原始信号', 'sigma:5,r:2高斯滤波', 'sigma:20,r:2高斯滤波'])
    plt.show()


def test_2():
    from scipy import misc
    import matplotlib.pyplot as plt
    from scipy.ndimage import gaussian_filter
    fig = plt.figure()
    plt.gray()  # show the filtered result in grayscale
    ax1 = fig.add_subplot(121)  # left side
    ax2 = fig.add_subplot(122)  # right side
    ascent = misc.ascent()
    result = gaussian_filter(ascent, sigma=5)
    ax1.imshow(ascent)
    ax2.imshow(result)
    plt.show()


def draw_gauss():
    M = 200
    data, Gaussian = Gaussian_Distribution(N=2, M=M, sigma=0.1)
    # 生成二维网格平面
    X, Y = np.meshgrid(np.linspace(-1, 1, M), np.linspace(-1, 1, M))
    # 二维坐标数据
    d = np.dstack([X, Y])
    # 计算二维联合高斯概率
    Z = Gaussian.pdf(d).reshape(M, M)

    '''二元高斯概率分布图'''
    fig = plt.figure(figsize=(6, 4))
    ax = Axes3D(fig)
    ax.plot_surface(X, Y, Z, rstride=1, cstride=1, cmap='seismic', alpha=0.8)
    plt.axis('off')
    plt.show()


def Gaussian_Distribution(N=2, M=1000, m=0, sigma=1):
    '''
    Parameters
    ----------
    N 维度
    M 样本数
    m 样本均值
    sigma: 样本方差

    Returns
    -------
    data  shape(M, N), M 个 N 维服从高斯分布的样本
    Gaussian  高斯分布概率密度函数
    '''
    mean = np.zeros(N) + m  # 均值矩阵，每个维度的均值都为 m
    cov = np.eye(N) * sigma  # 协方差矩阵，每个维度的方差都为 sigma

    # 产生 N 维高斯分布数据
    data = np.random.multivariate_normal(mean, cov, M)
    # N 维数据高斯分布概率密度函数
    Gaussian = multivariate_normal(mean=mean, cov=cov)

    return data, Gaussian


if __name__ == "__main__":
    draw_gauss()
