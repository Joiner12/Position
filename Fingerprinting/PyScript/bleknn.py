# -*- coding: utf-8 -*-
"""
Created on Tue Dec 14 17:04:17 2021

@author: W-H
"""
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import mean_squared_error
from sklearn.neighbors import KNeighborsRegressor
from bledatabase import read_ble_fingerprinting_from_file
from sklearn.model_selection import train_test_split
import numpy as np
from scipy import io


def ble_fingerprinting_find_best_k(ble_fingerprinting_data, *args, **kwargs):
    """根据蓝牙指纹数据寻找KNN算法的K值
    -----
    参数
    ble_fingerprinting_data: DataFrame
        蓝牙指纹数据
    -----
    输出
    k:float
        knn算法k
    """
    #
    k = 3  # 初始化k为3
    x_data = (ble_fingerprinting_data.drop('POS', axis=1)).values
    y_data = np.array(ble_fingerprinting_data['POS'])
    x_train, x_test, y_train, y_test = train_test_split(
        x_data, y_data, test_size=0.5, random_state=12345)
    parameters = {"n_neighbors": range(1, 50)}
    gridsearch = GridSearchCV(KNeighborsRegressor(), parameters)
    gridsearch.fit(x_train, y_train)
    k = gridsearch.best_params_
    return k


def test():
    ble_fingerprinting_data = read_ble_fingerprinting_from_file()
    k = ble_fingerprinting_find_best_k(ble_fingerprinting_data)
    print(k)
    # ble_fingerprinting_find_best_k(ble_fingerprinting_data)


def ble_fingerprinting_knn(*args, **kwargs):
    # load data from *.mat file
    ble_fingerprinting_data = io.loadmat(r'../Data/ble_data_base.mat')

    ble_fingerprinting_data = ble_fingerprinting_data['data']
    # rssi matrix
    x_data = ble_fingerprinting_data[:, 0:4].astype(np.float)
    # pos grid
    y_data_temp = ble_fingerprinting_data[:, 4]
    y_data = np.zeros([len(y_data_temp), 2])
    for i in range(len(y_data)):
        y_data[i] = y_data_temp[i].astype(np.float)
    #
    x_train, x_test, y_train, y_test = train_test_split(
        x_data, y_data, test_size=0.5, random_state=12345)
    knn_model = KNeighborsRegressor(
        n_neighbors=3, weights='uniform', metric='euclidean')
    knn_model.fit(x_train, y_train)
    knn_model.predict(x_test)


if __name__ == "__main__":
    ble_fingerprinting_knn()
