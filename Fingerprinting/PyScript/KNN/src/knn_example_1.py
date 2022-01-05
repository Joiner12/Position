# -*- coding: utf-8 -*-
"""
Created on Tue Jan  4 16:54:21 2022

@author: W-H
"""
import numpy as np
import matplotlib.pyplot as plt


def file2matrix(data_file=r'../data/datingTestSet2.txt', *args, **kwargs):
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


def normalization(dataset, method_selection='min_max', *args, **kwargs):
    """归一化特征值，消除特征之间量级不同导致的影响

    参数:
        dataset:np.array
            数据集
        method_selection:str
            归一化方法,包括:min_max、z_score、nonlinear_*
    返回:
        normed_dataset:np.array
            归一化后的数据集

    MIN-MAX:
        Y = (X-Xmin)/(Xmax-Xmin)
        其中的 min 和 max 分别是数据集中的最小特征值和最大特征值。该函数可以自动将数字特征值转化为0到1的区间。
    Z-SCORE:
        均值μ,方差σ
        Y = (X-μ)/σ
    NONLINEAR-*:
        非线性化归一化方法，常见的有sigmoid、反正切、反余切

    """
    #
    normalization_method = method_selection
    normDataSet = np.zeros(np.shape(dataset))
    # MIN-MAX 归一
    if normalization_method == 'min_max':
        # 计算每种属性的最大值、最小值、范围
        if len(kwargs) and 'min_value' in kwargs.keys():
            minVals = kwargs['min_value']
        else:
            minVals = dataset.min(0)
        if len(kwargs) and 'max_value' in kwargs.keys():
            maxVals = kwargs['max_value']
        else:
            maxVals = dataset.max(0)

        # 极差
        ranges = maxVals - minVals

        m = dataset.shape[0]
        # 生成与最小值之差组成的矩阵
        normDataSet = dataset - np.tile(minVals, m)
        # 将最小值之差除以范围组成矩阵
        normDataSet = normDataSet / np.tile(ranges, m)  # element wise divide

    # Z-SCORE 归一化
    elif normalization_method == 'z_score':
        if len(kwargs) and 'miu' in kwargs.keys():
            miu = kwargs['miu']
        else:
            miu = np.mean(dataset)
        if len(kwargs) and 'sigma' in kwargs.keys():
            sigma = kwargs['sigma']
        else:
            sigma = np.std(dataset)
        normDataSet = (dataset - miu) / sigma
    else:
        pass

    return normDataSet


def show_origin_data(data_mat, data_labels):
    """数据可视化
    数据可视化原始数据及特征
    从data_file文件中读取原始数据,保存为numpy格式

    参数:
        data_mat:np.array
        特征数据矩阵
        data_labels:np.array
        特征数据矩阵对应的类别
    返回:
        None
    
    """
    font = {
        'family': 'serif',
        'color': 'darkred',
        'weight': 'normal',
        'size': 16
    }
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(data_mat[:, 0], data_mat[:, 1], 15.0 * np.array(data_labels),
               15.0 * np.array(data_labels))
    ax.set_title('Data visualization', fontdict=font)
    ax.set(xlabel='part 1', ylabel='part 2')
    plt.show()


def classify_knn(test_data,
                 dataset_origin,
                 dataset_labels,
                 test_data_labels=None,
                 n_neigherbors=9,
                 *args,
                 **kwargs):
    """knn匹配算法

    参数
    test_data:array
        待匹配特征数据
    test_data_labels:array
        待匹配数据标签
    dataset_origin:array
        特征数据集
    dataset_labels:array
        特征标签数据集
    n_neigherbors:float
        KNN临近点数

    输出
    prediction:array
        匹配结果
    """
    #
    row_count = 1 if len(np.shape(test_data)) == 1 else np.shape(test_data)[0]
    prediction = np.zeros(row_count)  # 预测结果初始化
    # 归一化数据
    x_data = np.zeros(np.shape(dataset_origin))
    y_data = np.zeros(np.shape(dataset_labels))

    for j in range(np.shape(dataset_origin)[-1]):
        x_data[:, j] = normalization(dataset_origin[:, j])
    y_data = dataset_labels
    #
    test_x_data = np.zeros(np.shape(test_data))
    for j1 in range(np.shape(test_x_data)[-1]):
        test_x_data[:,
                    j1] = normalization(test_data[:, j1],
                                        min_value=dataset_origin[:, j1].min(),
                                        max_value=dataset_origin[:, j1].max())
    if test_data_labels is None:
        pass
    # KNN kernel
    for k in range(row_count):
        # 1.KNN-计算新数据与样本数据集中每条数据的距离
        distances = np.linalg.norm(test_x_data - x_data, axis=1)
        # 2.KNN-对求得的所有距离进行排序（从小到大，越小表示越相似）
        nearest_neighbor_ids = distances.argsort()[:n_neigherbors]
        # 3.KNN-取前n_neigherbors个样本数据对应的分类标签
        nearest_neighbor_rings = y_data[nearest_neighbor_ids]
        # 4.KNN-n_neigherbors个数据中出现次数最多的分类标签作为新数据的分类
        vals, counts = np.unique(nearest_neighbor_rings, return_counts=True)
        prediction[k] = vals[np.argmax(counts)]

    return prediction


def knn_demo_0():
    """
    测试knn
    """
    # 1.准备数据:导入数据集
    data_mat, data_labels = file2matrix()
    # 选取数据集中一条特征数据及标签
    # 10933,0.000000,0.107475	2
    test_data = np.array((10933, 0.000000, 0.107475)).reshape([1, 3])
    # 2.分析数据:可视化部分数据
    show_origin_data(data_mat, data_labels)
    # 3.测试算法:使用选中的数据测试算法
    prediction = classify_knn(test_data,
                              data_mat,
                              data_labels,
                              n_neigherbors=9)
    # 4.算法结果表示
    result_list = ['not at all', 'in small doses', 'in large doses']

    print('percentage of time spent playing video games:%%%.2f' %
          (test_data[0, 1]))
    print('frequent flier miles earned per year:%.2f' % (test_data[0, 0]))
    print('liters of ice cream consumed per year:%.2f' % (test_data[0, 2]))
    print('You will probably like this person:%s' %
          (result_list[int(prediction[0] - 1)]))


if __name__ == "__main__":
    knn_demo_0()
