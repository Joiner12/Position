# -*- coding: utf-8 -*-
"""
Created on Tue Jan  4 16:54:21 2022

@author: W-H
"""
import numpy as np
import matplotlib
import matplotlib.pyplot as plt


def parse_data(data_file=r'../data/datingTestSet2.txt', *args, **kwargs):
    """准备数据:使用 Python 解析文本文件
    文本文件数据格式如下: 
    40920	8.326976	0.953952	3
    14488	7.153469	1.673904	2
    26052	1.441871	0.805124	1
    75136	13.147394	0.428964	1
    38344	1.669788	0.134296	1
    从data_file文件中读取原始数据,保存为numpy格式

    参数:
        data_file:str
        原始数据路径,./data/datingTestSet2.txt
    
    返回:
        data_ret:numpy.array
            返回特征数据矩阵
        class_label_vector:numpy.array
            data_ret对应的类别
    
    """
    #
    line_num = 1
    with open(data_file, 'r') as f:
        all_lines = f.readlines()
        # 获取数据总数
        line_num = len(all_lines)
    data_ret = np.zeros((line_num, 3))
    class_label_vector = np.zeros((line_num, 1))
    # 解析数据
    row_index = 0
    with open(data_file, 'r') as f:
        all_lines = f.readlines()
        for line in all_lines:
            line = line.strip()
            # 以 '\t' 切割字符串
            listFromLine = line.split('\t')
            data_ret[row_index, :] = listFromLine[0:3]
            class_label_vector[row_index, :] = listFromLine[-1]
            row_index += 1

    return data_ret, class_label_vector


def show_origin_data(dating_data_mat, dating_data_labels):
    """数据可视化
    数据可视化原始数据及特征
    从data_file文件中读取原始数据,保存为numpy格式

    参数:
        dating_data_mat:np.array
        特征数据矩阵
        dating_data_labels:np.array
        特征数据矩阵对应的类别
    返回:
        None
    
    """
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(dating_data_mat[:, 0], dating_data_mat[:, 1],
               15.0 * np.array(dating_data_labels),
               15.0 * np.array(dating_data_labels))
    plt.show()


if __name__ == "__main__":
    dating_data_mat, dating_data_labels = parse_data()
    show_origin_data(dating_data_mat, dating_data_labels)