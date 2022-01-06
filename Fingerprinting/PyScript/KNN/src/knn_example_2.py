# -*- coding: utf-8 -*-
"""
Created on Thu Jan  6 09:16:02 2022

@author: W-H
"""

# 手写数字(0~9)识别

import numpy as np
import matplotlib.pyplot as plt
import os
from sklearn.model_selection import GridSearchCV
from sklearn.neighbors import KNeighborsRegressor


def show_number_matrix(file_path='../data/testDigits/9_11.txt',
                       show_figure=False,
                       *args,
                       **kwargs):
    """ 数据分析,将存储在文档中的图像矩阵显示出来

        参数:
            file_path:str
                文件路径
        输出:
            data_mat:numpy.ndarray
    """
    # 按行读入二维数组
    # data_mat = np.empty()
    mat_shape = [0, 0]  # [row,col]
    with open(file_path, encoding='utf-8', mode='r') as f:
        all_line = f.readlines()
        mat_shape[0] = len(all_line)
        mat_shape[1] = len(all_line[0].replace('\n', ''))
    data_mat = np.zeros(mat_shape)
    with open(file_path, encoding='utf-8', mode='r') as f:
        all_line = f.readlines()
        for k in range(mat_shape[0]):
            line = all_line[k]
            line = line.replace('\n', '')
            line = [int(x) for x in line]
            data_mat[k, :] = line
    if show_figure:
        # plt.close("all")
        fig = plt.figure()
        ax1 = fig.add_subplot()
        ax1.imshow(data_mat)
        fig.show()
    return data_mat


def read_matrix_from_files(
        file_paths=[
            '../data/testDigits/9_11.txt', '../data/testDigits/5_11.txt'
        ]):
    X_train = np.zeros([32, 32, len(file_paths)])
    for k in range(len(file_paths)):
        temp = show_number_matrix(file_paths[k])
        X_train[:, :, k] = temp
    return X_train


def get_image_matrix(src_dir=r'../data/trainingDigits'):
    """ 从文件夹中读取预处理完成的图像数据
    将文件夹中的所有数据文件提出出来,并根据文件名提出对应的标签
    比如图像数据文件0_11.txt对应的标签为0.

    参数:
        src_dir:str
            源数据文件夹
    
    返回:
        X_data:numpy.ndarray
            特征数据
        Y_data:numpy.ndarray
            特征数据对应的标签
    """
    #
    files = os.listdir(src_dir)
    file_count = len(files)
    if file_count == 0:
        return None
    files_input = [src_dir + '/' + x for x in files]
    X_data = read_matrix_from_files(files_input)
    Y_data = np.zeros(file_count)
    for k in range(file_count):
        temp = os.path.splitext(files[k])
        temp = temp[0]
        Y_data[k] = int(temp[0])
    return X_data, Y_data


class knn_using_sklearn():

    def __init__(self):
        pass

    # todo
    def __test(self):
        X_train, Y_train = get_image_matrix()
        X_test, Y_test = get_image_matrix(src_dir=r'../data/testDigits')
        parameters = {"n_neighbors": range(1, 50)}
        gridsearch = GridSearchCV(KNeighborsRegressor(), parameters)
        gridsearch.fit(X_train, Y_train)


# parameters = {"n_neighbors": range(1, 50)}
# gridsearch = GridSearchCV(KNeighborsRegressor(), parameters)
# gridsearch.fit(X_train, y_train)

if __name__ == "__main__":
    print('一直就在你的耳边')
