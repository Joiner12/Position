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
# import pandas as pd
import numpy as np


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
    # 读取离线测试数据
    test_file = r'../Data/BLE-FINGERPRING/7-6.txt'
    beacon_filter = ['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7']
    ble_data = get_valid_data(file_path=test_file,
                              beacon_filter=beacon_filter)
    frame_num = ble_data['FRAMENUM'].max()
    # 帧间隔
    frame_gap = 4
    # 过程数据,存储不同beacon发射的RSSI(Array)
    process_data = init_dict(beacon_filter)
    # 当前指纹
    cur_fingerprinting = list()
    # 主循环
    for frame_index in range(0, frame_num, 1):
        data_slice = ble_data[(ble_data['FRAMENUM'] >= frame_index)
                              & (ble_data['FRAMENUM'] < frame_index+frame_gap)]
        for beacon_name in beacon_filter:
            process_data[beacon_name] = data_slice[
                data_slice['NAME'] == beacon_name]['RSSI'].tolist()
        cur_fingerprinting = np.array([np.mean(x)
                                      for x in process_data.values()])
        # 重置过程数据
        process_data = init_dict(beacon_filter)
        # todo:knn 指纹匹配
        # 重置指纹数据
        cur_fingerprinting = list()
        print(process_data)


if __name__ == "__main__":
    offline_data_location()
