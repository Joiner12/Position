# -*- coding: utf-8 -*-
"""
Created on Tue Dec 14 17:04:17 2021

@author: W-H
"""
from sklearn.model_selection import GridSearchCV
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split
import numpy as np
from scipy import io
import matplotlib.pyplot as plt


def data_preprocessing(data_file=r'../Data/ble_data_base.mat', *args, **kwargs):
    """读取mat格式中保存的蓝牙指纹数据并处理为rssi和lable标签返回
    -----
    参数
    data_file:str
        数据文件路径，默认../Data/ble_data_base.mat
    -----
    x_data:array
        RSSI指纹特征向量
    y_data:array
        RSSI指纹特征向量对应的位置标签(向量)
    """
    #
    ble_fingerprinting_data = io.loadmat(data_file)
    #
    ble_fingerprinting_data = ble_fingerprinting_data['data']
    # rssi特征向量
    x_data = ble_fingerprinting_data[:, 0:4].astype(np.float)
    # 位置标签(向量)
    y_data_temp = ble_fingerprinting_data[:, 4]
    y_data = np.zeros([len(y_data_temp), 2])
    for i in range(len(y_data)):
        y_data[i] = y_data_temp[i].astype(np.float)
    return x_data, y_data


def prediction_err(predictions, labels, *args, **kwargs):
    """计算KNN定位误差(数组欧式距离)
    -----
    参数
    predictions:array
        预测结果
    labels:array
        标注结果
    -----
    输出
    err:float
        欧拉距离

    """
    #
    err = np.sqrt(np.sum((predictions - labels)**2))
    return err


def ble_fingerprinting_find_best_n_neighbors(data_file=r'../Data/ble_data_base.mat', *args, **kwargs):
    """根据蓝牙指纹数据寻找KNN算法的K值
    -----
    参数
    data_file:str
        数据文件路径，默认../Data/ble_data_base.mat
    -----
    输出
    k:float
        knn算法最佳k值
    """
    #
    k = 3  # 初始化k为3
    x_data, y_data = data_preprocessing(data_file)
    x_train, x_test, y_train, y_test = train_test_split(
        x_data, y_data, test_size=0.8, random_state=1)
    parameters = {"n_neighbors": range(1, 50)}
    gridsearch = GridSearchCV(KNeighborsRegressor(), parameters)
    gridsearch.fit(x_train, y_train)
    scores = gridsearch.cv_results_['mean_test_score']
    k = np.argmax(scores)  # 选择score最大的k
    if 'show_figure' in kwargs.keys() and kwargs['show_figure']:
        # 绘制超参数k与score的关系曲线
        plt.plot(range(1, scores.shape[0] + 1), scores, '-o', linewidth=2.0)
        plt.plot(k+1, scores[k], color='red', marker='o')
        plt.text(k+2, scores[k]*1.01, 'k:'+str(k), fontsize=15)
        plt.xlabel("k")
        plt.ylabel("score")
        plt.grid(True)
        plt.title("不同K值拟合效果")
        plt.show()
    return k


def ble_fingerprinting_knn(ble_data_point, true_lable=None, data_file=r'../Data/ble_data_base.mat',
                           n_neigherbors=9, weights='distance', *args, **kwargs):
    """knn匹配蓝牙指纹
    -----
    参数
    ble_data_point:array
        待匹配蓝牙指纹
    data_file:str
        蓝牙指纹离线数据库mat文件
    n_neigherbors:float
        KNN临近点数
    weights:str
        knn权重方法设置,['uniform','distance','...']
        'uniform'表示加权平均
        'distance'表示欧拉距离
    -----
    输出
    prediction:array
        指纹库匹配结果
    """
    #
    x_data, y_data = data_preprocessing(data_file)
    # todo:验证sklearn库
    if False:
        knn_model = KNeighborsRegressor(
            n_neighbors=n_neigherbors, weights='uniform', metric='euclidean')
        knn_model.fit(x_data, y_data)
        knn_model.predict(ble_data_point)
    distances = np.linalg.norm(x_data - ble_data_point, axis=1)
    nearest_neighbor_ids = distances.argsort()[:n_neigherbors]
    nearest_neighbor_rings = y_data[nearest_neighbor_ids]
    # wknn
    if weights == 'uniform':  # 权重系数默认为1/k(uniform)
        weights_cof = np.ones([1, n_neigherbors])
        weights_cof = weights_cof/weights_cof.size
        # prediction = nearest_neighbor_rings.mean(axis=0)
    elif weights == 'other':
        pass
    else:  # 欧拉距离
        weights_cof = 1/distances[nearest_neighbor_ids]
    prediction = (weights_cof@nearest_neighbor_rings)/weights_cof.sum()
    #
    #
    show_figure_flag = False
    try:
        show_figure_flag = kwargs['show_figure']
    except:
        pass
    if show_figure_flag:
        fig_1 = plt.figure()
        ax = fig_1.subplots()
        # k-neighbors位置
        for i in range(n_neigherbors):
            ax.scatter(nearest_neighbor_rings[i, 0],
                       nearest_neighbor_rings[i, 1])
            ax.text(nearest_neighbor_rings[i, 0],
                    nearest_neighbor_rings[i, 1], str(i))
        # 匹配结果
        ax.plot(prediction[0], prediction[1], marker='v')
        ax.text(prediction[0], prediction[1], 'prediction pos')
        # 真实位置
        if not true_lable is None:
            ax.plot(true_lable[0], true_lable[1], 'r*')
            ax.text(true_lable[0], true_lable[1], 'true_pos')
        plt.show()
    return prediction


if __name__ == "__main__":
    test_point = np.array([-53., 0., -70., -68.])
    y_pos = ble_fingerprinting_knn(test_point, [13, 0],
                                   data_file=r'../Data/ble_data_base_least.mat',
                                   weights='uniform', n_neigherbors=3, show_figure=True)
