# -*- coding: utf-8 -*-
__date__ = "Dec 16 11:25:04 2021"
__author__ = "W-H"

"""蓝牙指纹定位主函数

说明:
该模块调用指纹数据库并对离线测试数据以数据帧为单位进行解析，
分析定位效果。
流程:
offline_data_location():
1.模拟实际测试数据采集过程
2.调用bleknn模块中的指纹匹配方法
3.匹配../Data/中的指纹库
4.可视化定位过程
"""

from bledatabase import get_valid_data
import numpy as np
from bleknn import ble_fingerprinting_knn, prediction_err
import os
import re
import matplotlib.pyplot as plt
import pandas as pd
from math import ceil


def init_dict(key_name, *args, **kwargs):
    """根据字典关键词,构建并初始化字典
    参数
    ----------
    dict_to_init:dict
        待初始化字典
    key_name:[str]
        字典关键字

    返回值
    -------
    dict_init:dict
        初始化完成之后的字典

    """
    dict_inited = dict()
    for name in key_name:
        dict_inited[name] = []
    return dict_inited


def generate_roc_data(x, N=21, * args, **kwargs):
    """根据输入获取roc统计特征值
    参数
    ----------
    x:array_like
        原始数据
    N:float
        分段系数
    返回值
    -------
    y_roc:array_like
    x_roc:array_like
        roc数组
    说明
        ...
    """
    #
    x_roc = np.linspace(0, ceil(max(x)), N)
    y_roc = np.zeros(N)
    # debug line
    for k in range(len(x_roc)):
        thresholds = x_roc[k]
        temp_x = list()
        for j in x:
            if j <= thresholds:
                temp_x.append(j)
        y_roc[k] = len(temp_x)/len(x)
    return x_roc, y_roc


def offline_data_location():
    """离线数据指纹定位
    参数
    ----------
    None

    返回值
    -------
    None

    说明
    1.对测试的单点离线数据进行定位效果验证;
    2.以数据帧为处理单位;
    3.数据帧大小定义为n,n值根据蓝牙扫描和发射频率调整;
    4.收集指定数据帧内的不同信标RSSI值,并整合为一条指纹[Beacon0_RSSI,Beacon1_RSSI,Beacon6_RSSI,Beacon7_RSSI];
    5.所有数据帧整合方式采用均值方式;
    """
    # 指纹数据库
    ble_fingerprinting_base = r'../Data/ble_data_base_least.mat'
    # 读取离线测试数据
    test_file = r'../Data/BLE-FINGERPRING/7-6.txt'
    beacon_filter = ['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7']
    ble_data = get_valid_data(file_path=test_file,
                              beacon_filter=beacon_filter)
    frame_num = ble_data['FRAMENUM'].max()
    # 帧间隔
    frame_gap = 10
    # 过程数据,存储不同beacon发射的RSSI(Array)
    process_data = init_dict(beacon_filter)
    # 模拟每次运行定位误差
    location_err = list()
    prediction_all = pd.DataFrame(columns=['pos_x', 'pos_y'])
    # 当前指纹
    cur_fingerprinting = list()
    # 主循环
    for frame_index in range(0, frame_num, 1):
        data_slice = ble_data[(ble_data['FRAMENUM'] >= frame_index)
                              & (ble_data['FRAMENUM'] < frame_index+frame_gap)]
        for beacon_name in beacon_filter:
            fingerprinting_temp = \
                data_slice[data_slice['NAME'] == beacon_name]['RSSI'].tolist()
            if len(fingerprinting_temp) == 0:
                process_data[beacon_name] = [0]
            else:
                process_data[beacon_name] = fingerprinting_temp
        # 当前指纹结果
        cur_fingerprinting = np.array([np.mean(x)
                                      for x in process_data.values()])
        true_lable = [0, 0]
        # 根据数据文件名字设定真实位置标签
        if True:
            file_name = os.path.splitext(os.path.split(test_file)[-1])[0]
            true_lable = re.findall(r'\d{1,}', file_name)
            true_lable = [float(x) for x in true_lable]
        # knn 指纹匹配
        # def ble_fingerprinting_knn(ble_data_point, true_lable=None, data_file=r'../Data/ble_data_base.mat',
        #                            n_neigherbors=9, *args, **kwargs):
        prediction = ble_fingerprinting_knn(
            cur_fingerprinting, true_lable, ble_fingerprinting_base, 3, show_figure=False)  # 指纹查找结果

        # 定位误差
        err = prediction_err(prediction,
                             np.array(true_lable).reshape(prediction.shape))
        print('Location Error Euclidean Distance: %.2f' % (err))
        location_err.append(err)
        # 定位结果
        index_temp = len(prediction_all)  # 索引值
        prediction_all.at[index_temp, 'pos_x'] = \
            prediction.tolist()[0]
        prediction_all.at[index_temp, 'pos_y'] = \
            prediction.tolist()[1]
        # 定位结果统计误差
        error_roc_x, error_roc_y = generate_roc_data(location_err)
        # 重置过程数据
        process_data = init_dict(beacon_filter)

        # 重置指纹数据
        cur_fingerprinting = list(tuple(prediction))
        # print(process_data)

    # 绘制图形
    fig = plt.figure(num=1)
    axs = fig.subplots(3, 1)
    # 定位过程误差
    axs[0].plot(np.linspace(1, len(location_err),
                            len(location_err)), location_err, marker='*')
    axs[0].set(xlabel='Serial/n', ylabel='Error/m',
               title='Fingerprintings Location Error\n'+'Frame Length:'+str(frame_gap))
    # # 最大误差
    # axs[0].plot([0, len(location_err)], [max(location_err), max(location_err)])
    # # 最小误差
    # axs[0].plot([0, len(location_err)], [
    #     min(location_err), min(location_err)])
    #
    # 定位结果分布
    area = 10*np.array(location_err)**2
    colors = location_err/max(location_err)
    axs[1].scatter(prediction_all['pos_x'],
                   prediction_all['pos_y'], s=area, c=colors, alpha=0.5)
    axs[1].set(xlabel='grid-x/m', ylabel='grid-y/m')
    # 真实位置
    axs[1].text(true_lable[0], true_lable[1], 'true pos')
    axs[1].plot(true_lable[0], true_lable[1], marker='^')
    # 定位统计误差图
    axs[2].plot(error_roc_x, error_roc_y, marker='o')
    axs[2].set(xlabel='error/m', ylabel='prolibility/(%)')
    # error_roc_x, error_roc_y = generate_roc_data(err)


if __name__ == "__main__":
    offline_data_location()
