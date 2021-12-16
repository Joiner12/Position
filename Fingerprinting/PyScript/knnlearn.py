# -*- coding: utf-8 -*-
"""
Created on Tue Dec 14 15:23:22 2021

@author: W-H
"""

from sklearn.naive_bayes import MultinomialNB
from sklearn import datasets
import seaborn as sns
from math import sqrt
from sklearn.metrics import mean_squared_error
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd


def knn_learn_1():
    url = (
        "https://archive.ics.uci.edu/ml/machine-learning-databases"
        "/abalone/abalone.data")
    abalone = pd.read_csv(url, header=None)
    abalone.columns = ["Sex",
                       "Length",
                       "Diameter",
                       "Height",
                       "Whole weight",
                       "Shucked weight",
                       "Viscera weight",
                       "Shell weight",
                       "Rings"]
    abalone = abalone.drop("Sex", axis=1)

    # abalone["Rings"].hist(bins=15)
    # plt.show()
    # basic knn
    X = abalone.drop("Rings", axis=1)
    X = X.values
    y = abalone["Rings"]
    y = y.values
    new_data_point = np.array(
        [0.569552, 0.446407, 0.154437, 1.016849, 0.439051, 0.222526, 0.291208])
    distances = np.linalg.norm(X - new_data_point, axis=1)
    k = 3
    nearest_neighbor_ids = distances.argsort()[:k]
    nearest_neighbor_rings = y[nearest_neighbor_ids]
    prediction = nearest_neighbor_rings.mean()

    #
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, random_state=12345)
    knn_model = KNeighborsRegressor(n_neighbors=3)
    knn_model.fit(X_train, y_train)
    train_preds = knn_model.predict(X_train)
    mse = mean_squared_error(y_train, train_preds)
    rmse = sqrt(mse)
    #
    test_preds = knn_model.predict(X_test)
    mse = mean_squared_error(y_test, test_preds)
    rmse = sqrt(mse)
    rmse
    cmap = sns.cubehelix_palette(as_cmap=True)
    f, ax = plt.subplots()
    points = ax.scatter(X_test[:, 0], X_test[:, 1],
                        c=test_preds, s=50, cmap=cmap)
    f.colorbar(points)
    plt.show()


def knn_learn_2():
    # 导入数据
    from sklearn import neighbors
    import numpy as np
    import scipy.io as scio
    offline_data = scio.loadmat(
        r'D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Simulator\offline_data_random.mat')
    online_data = scio.loadmat(
        r'D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Simulator\online_data.mat')
    offline_location, offline_rss = offline_data['offline_location'], offline_data['offline_rss']
    trace, rss = online_data['trace'][0:1000, :], online_data['rss'][0:1000, :]
    del offline_data
    del online_data

# 定位精度函数

    def accuracy(predictions, labels):
        return np.mean(np.sqrt(np.sum((predictions - labels)**2, 1)))

    # knn回归

    def knn_rssi():
        knn_reg = neighbors.KNeighborsRegressor(
            8, weights='uniform', metric='euclidean')
        knn_reg.fit(offline_rss, offline_location)
        predictions = knn_reg.predict(rss)
        acc = accuracy(predictions, trace)
        print("accuracy: ", acc/100, "m")

    def knn_classifier():
        # knn分类，需要把坐标转换成网格标号，预测后将网格标号转换为坐标
        labels = np.round(offline_location[:, 0]/100.0) * \
            100 + np.round(offline_location[:, 1]/100.0)
        from sklearn import neighbors
        knn_cls = neighbors.KNeighborsClassifier(
            n_neighbors=40, weights='uniform', metric='euclidean')
        knn_cls.fit(offline_rss, labels)
        predict_labels = knn_cls.predict(rss)
        x = np.floor(predict_labels/100.0)
        y = predict_labels - x * 100
        predictions = np.column_stack((x, y)) * 100
        acc = accuracy(predictions, trace)
        print("accuracy: ", acc/100, 'm')

    def analysis_location_algo():
        # 预处理，标准化数据(其实RSS数据还算正常，不预处理应该也无所谓，特征选择什么的也都不需要)
        from sklearn.preprocessing import StandardScaler
        standard_scaler = StandardScaler().fit(offline_rss)
        X_train = standard_scaler.transform(offline_rss)
        Y_train = offline_location
        X_test = standard_scaler.transform(rss)
        Y_test = trace

        # 交叉验证，在knn里用来选择最优的超参数k
        from sklearn.model_selection import GridSearchCV
        from sklearn import neighbors
        parameters = {'n_neighbors': range(1, 50)}
        knn_reg = neighbors.KNeighborsRegressor(
            weights='uniform', metric='euclidean')
        clf = GridSearchCV(knn_reg, parameters)
        clf.fit(offline_rss, offline_location)
        scores = clf.cv_results_['mean_test_score']

        k = np.argmax(scores)  # 选择score最大的k

        # 绘制超参数k与score的关系曲线
        import matplotlib.pyplot as plt
        # %matplotlib inline
        plt.plot(range(1, scores.shape[0] + 1), scores, '-o', linewidth=2.0)
        plt.xlabel("k")
        plt.ylabel("score")
        plt.grid(True)
        plt.show()

        # 使用最优的k做knn回归
        knn_reg = neighbors.KNeighborsRegressor(
            n_neighbors=k, weights='uniform', metric='euclidean')
        predictions = knn_reg.fit(offline_rss, offline_location).predict(rss)
        acc = accuracy(predictions, trace)
        print("accuracy: ", acc/100, "m")

    def train_data_accuracy():
        # 训练数据量与accuracy
        k = 29
        data_num = range(100, 30000, 300)
        acc = []
        for i in data_num:
            knn_reg = neighbors.KNeighborsRegressor(
                n_neighbors=k, weights='uniform', metric='euclidean')
            predictions = knn_reg.fit(
                offline_rss[:i, :], offline_location[:i, :]).predict(rss)
            acc.append(accuracy(predictions, trace) / 100)
        # 绘制训练数据量与accuracy的曲线
        import matplotlib.pyplot as plt
        # %matplotlib inline
        plt.plot(data_num, acc, '-o', linewidth=2.0)
        plt.xlabel("data number")
        plt.ylabel("accuracy (m)")
        plt.grid(True)
        plt.show()


if __name__ == "__main__":
    knn_learn_2()
