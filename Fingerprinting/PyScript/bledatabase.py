# -*- coding: utf-8 -*-
"""
Created on Wed Dec  8 16:26:56 2021

@author: W-H
"""

import pandas as pd
import numpy as np
import os
from itertools import product
import re
from scipy import io


def get_valid_data(file_path: str, beacon_filter=[], * args, **kwargs):
    """ 从原始数据中提取有效数据帧
    参数
    ----
    file_path:str
        文件路径
    ----
    返回
    data_pd:DataFrame
        数据帧
    """
    if not os.path.isfile(file_path):
        print("Error: 没有找到文件或读取文件失败")
    data_pd = pd.DataFrame(
        columns=['HEAD', 'NAME', 'MAC', 'RSSI', 'LAT', 'LON', 'FRAMENUM'])
    #
    with open(file_path, encoding='utf-8', mode='r') as f:
        all_lines = f.readlines()
        valid_frame_num = 0  # 有效数据帧数
        valid_data_line_num = 0  # 有效数据条数
        pre_line = ''  # 上一条数据行
        pre_pre_line = ''  # 上两条数据行
        #
        for line in all_lines:
            #
            if 'HEAD' in pre_pre_line and '----' in pre_line and '$APMSG' in line:
                valid_frame_num += 1
            pre_pre_line = pre_line
            pre_line = line
            #
            if '$APMSG' in line:
                line_splited = line.split()
                #
                if not line_splited[1] in beacon_filter:
                    continue
                #
                data_pd.at[valid_data_line_num,
                           'HEAD'] = line_splited[0]  # HEAD
                data_pd.at[valid_data_line_num,
                           'NAME'] = line_splited[1]  # NAME

                data_pd.at[valid_data_line_num, 'MAC'] = line_splited[2]  # MAC
                data_pd.at[valid_data_line_num, 'RSSI'] = float(
                    line_splited[3])  # RSSI
                data_pd.at[valid_data_line_num, 'LAT'] = float(
                    line_splited[4])  # LAT
                data_pd.at[valid_data_line_num, 'LON'] = float(
                    line_splited[5])  # LON
                data_pd.at[valid_data_line_num,
                           'FRAMENUM'] = valid_frame_num  # FRAMENUM
                valid_data_line_num += 1
    return data_pd


def generate_ble_fingerprintings_v1(ble_data, pos: float = [0, 0], *args, **kwargs):
    """ 生成蓝牙指纹数据(最大指纹库)
    ---------
    说明:
        1.每一帧数据生成多条指纹，全部组合
        2.单帧有多条beancon数据取
        比如,单帧数据如下:
          HEAD         NAME                MAC        RSSI      LAT                  LON            
        ------ -------------------- ----------------- ---- -------------------- --------------------
        $APMSG Beacon6              3d:79:8c:3f:23:ac -66  30.5480148           104.0585672         
        $APMSG Beacon6              3d:79:8c:3f:23:ac -68  30.5480148           104.0585672         
        $APMSG Beacon6              3d:79:8c:3f:23:ac -61  30.5480148           104.0585672         
        $APMSG Beacon7              c0:74:8c:3f:23:ac -63  30.5480188           104.0587308         
        $APMSG Beacon1              c5:74:8c:3f:23:ac -43  30.5478754           104.0585674         
        指纹结果:
        F = [beacon0,beacon1,beacon6,beacon7]

        F1 = [0,-43,-61,-63] 
        F2 = [0,-43,-66,-63]
        F3 = [0,-43,-68,-63]

    ----
    参数
    ----
    ble_data:DataFrame
        提取后的蓝牙数据
    pos:float
        [x,y]|[lat,lon]
    ----
    返回
    ble_fingerprints:DataFrame
        单点对应的指纹数据
    """
    # 所有锚节点(NAME)
    ble_fingerprints = pd.DataFrame(columns=['RSSI_FG', 'POS'])
    beacons = []
    for k in ble_data.loc[:, 'NAME']:
        if not k in beacons:
            beacons.append(k)
    beacons.sort()
    # 单帧数据处理
    frame_num = ble_data.loc[:, 'FRAMENUM'].max()
    for frame in range(1, frame_num, 1):
        # 初始化beacon rssi字典
        beacons_rssi = dict()
        for name in beacons:
            beacons_rssi[name] = []
        cur_frame = ble_data.loc[ble_data['FRAMENUM'] == frame]
        # 遍历当前数据帧，填充数据
        cur_frame_index = cur_frame.index
        for k in cur_frame_index:
            cur_rssi = cur_frame.at[k, 'RSSI']
            if not cur_rssi in beacons_rssi[cur_frame.at[k, 'NAME']]:
                beacons_rssi[cur_frame.at[k, 'NAME']].append(cur_rssi)
        # 检查beacon rssi字典中的rssi数组是否为空
        for k_1, v_1 in zip(beacons_rssi.keys(), beacons_rssi.values()):
            if len(v_1) == 0:
                beacons_rssi[k_1] = [0]
        # 所有可能的指纹组合
        possible_fingerprinting = product(list(beacons_rssi.values())[0],
                                          list(beacons_rssi.values())[1],
                                          list(beacons_rssi.values())[2],
                                          list(beacons_rssi.values())[3])
        # 保存到指纹数据库中
        for k_3 in possible_fingerprinting:
            ble_rssis = ble_fingerprints['RSSI_FG']
            # 非重复且有效RSSI(不全为0)
            if not k_3 in ble_rssis and np.any(np.array(k_3)):
                ble_fingerprints.at[len(ble_rssis), 'RSSI_FG'] = np.array(k_3)
                ble_fingerprints.at[len(ble_rssis), 'POS'] = np.array(pos)

    return ble_fingerprints


def generate_ble_fingerprintings_v2(ble_data, pos: float = [0, 0], *args, **kwargs):
    """ 生成蓝牙指纹数据(最小指纹库)
    ---------
    说明:
        1.每个测试点生成一条指纹数据
        2.不同信标对应的rssi取均值
        比如,测试数据如下:
        HEAD         NAME                MAC        RSSI      LAT                  LON            
        ------ -------------------- ----------------- ---- -------------------- --------------------
        $APMSG Beacon1              c5:74:8c:3f:23:ac -53  30.5478754           104.0585674         
        $APMSG Beacon1              c5:74:8c:3f:23:ac -49  30.5478754           104.0585674         
        $APMSG Beacon7              c0:74:8c:3f:23:ac -70  30.5480188           104.0587308         
        $APMSG Beacon6              3d:79:8c:3f:23:ac -58  30.5480148           104.0585672         
        $APMSG Beacon1              c5:74:8c:3f:23:ac -47  30.5478754           104.0585674         
        $APMSG Beacon1              c5:74:8c:3f:23:ac -50  30.5478754           104.0585674         
        $APMSG Beacon0              c3:74:8c:3f:23:ac -61  30.5478767           104.0587312         

        HEAD         NAME                MAC        RSSI      LAT                  LON            
        ------ -------------------- ----------------- ---- -------------------- --------------------
        $APMSG Beacon1              c5:74:8c:3f:23:ac -59  30.5478754           104.0585674         

        HEAD         NAME                MAC        RSSI      LAT                  LON            
        ------ -------------------- ----------------- ---- -------------------- --------------------
        $APMSG Beacon0              c3:74:8c:3f:23:ac -61  30.5478767           104.0587312         
        $APMSG Beacon6              3d:79:8c:3f:23:ac -63  30.5480148           104.0585672         

        HEAD         NAME                MAC        RSSI      LAT                  LON            
        ------ -------------------- ----------------- ---- -------------------- --------------------
        $APMSG Beacon0              c3:74:8c:3f:23:ac -62  30.5478767           104.0587312         
        $APMSG Beacon6              3d:79:8c:3f:23:ac -56  30.5480148           104.0585672         
        $APMSG Beacon1              c5:74:8c:3f:23:ac -58  30.5478754           104.0585674         
        $APMSG Beacon0              c3:74:8c:3f:23:ac -57  30.5478767           104.0587312         
        指纹结果:
        beacon0所有RSSI数组 r1=[-61,-63,-57]
        beacon1所有RSSI数组 r2=[-58,-59,-50,-47,-49,-53]
        beacon6所有RSSI数组 r3=[-58,-63,-56]
        beacon7所有RSSI数组 r4=[-70,]
        F = [beacon0,beacon1,beacon6,beacon7]
        F = [mean(r1),mean(r2),mean(r3),mean(r4)]
    ----
    参数
    ----
    ble_data:DataFrame
        提取后的蓝牙数据
    pos:float
        [x,y]|[lat,lon]
    ----
    返回
    ble_fingerprints:DataFrame
        单点对应的指纹数据
    """
    # 所有锚节点(NAME)
    ble_fingerprints = pd.DataFrame(columns=['RSSI_FG', 'POS'])
    beacons = []
    for k in ble_data.loc[:, 'NAME']:
        if not k in beacons:
            beacons.append(k)
    beacons.sort()  # beacon命名统一sort能实现对字符串排序
    #
    # 初始化beacon rssi字典
    beacons_rssi = dict()
    for name in beacons:
        rssi_temp = ble_data[ble_data['NAME'] == name]
        rssi_temp = rssi_temp['RSSI'].mean()
        beacons_rssi[name] = rssi_temp
    # 不同beacon对应的RSSI均值拼接成指纹
    # 例如[Beacon0,Beacon1,Beacon6,Beacon7] = [-64,-56,-63,-59]

    ble_rssis = ble_fingerprints['RSSI_FG']
    # 有效RSSI(不全为0)
    if np.any(np.array(beacons_rssi.values())):
        # 将存储在dict中的rssi转换为array
        fingerprinting_rssi_temp = np.array([x for x in beacons_rssi.values()])
        ble_fingerprints.at[len(ble_rssis),
                            'RSSI_FG'] = fingerprinting_rssi_temp
        ble_fingerprints.at[len(ble_rssis), 'POS'] = np.array(pos)

    return ble_fingerprints


def extract_fingerprinting_from_dirs(src_folder='../Data/BLE-FINGERPRING/', extract_mean=0, * args, **kwargs):
    ble_fingerprints_all = pd.DataFrame(columns=['RSSI_FG', 'POS'])
    """ 从指纹原始数据文件夹中提取所有的指纹数据,并输出为特定格式保存
    -----
    参数
    src_folder:str
        源数据文件夹路径
    extract_mean:int
        指纹提取方式选择,默认0表示使用V1,1表示使用V2
    -----
    输出
    ble_fingerprints_all:DataFrame
        蓝牙指纹数据
    说明
        原始指纹数据保存再../Data/BLE-FINGERPRING/中,文件名为x-y.txt,
        其中x表示相对于水平轴的偏移量，y表示相对于垂直轴偏移量。具体位置
        及坐标定义参考../Doc/BLE-Fingerprinting.drawio
    """
    #
    dirs = os.listdir(src_folder)
    src_data_file = list()
    pos_s = list()
    for k in dirs:
        # 判断是否满足文件命名格式
        if re.search(r'\d{1,}-\d{1,}.txt', k) is None:
            continue
        pos = re.findall(r'^-\d{1,}|\d{1,}', k)
        pos = [int(i) for i in pos]
        #
        pos_s.append(pos)
        src_data_file.append(os.path.join(src_folder, k))
        #
        print(pos, os.path.join(src_folder, k))
    #
    # 提取所有指纹数据
    for (pos, data_file) in zip(pos_s, src_data_file):
        ble_data = get_valid_data(data_file,
                                  beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])
        # 指纹提取方式设置
        if extract_mean == 0:
            ble_fingerprints = generate_ble_fingerprintings_v1(
                ble_data, pos=pos)
            print(data_file)
            ble_fingerprints_all = pd.concat(
                [ble_fingerprints_all, ble_fingerprints], ignore_index=True)
        if extract_mean == 1:
            ble_fingerprints = generate_ble_fingerprintings_v2(
                ble_data, pos=pos)
            print(data_file)
            ble_fingerprints_all = pd.concat(
                [ble_fingerprints_all, ble_fingerprints], ignore_index=True)
    # return ble_fingerprints_all
    ble_fingerprints_all.to_csv(r'../Data/BLE_FINGERPRTING.txt')
    print('extract ble rssi fingerprintings from %s,stored in %s' %
          (src_folder, r'../Data/BLE_FINGERPRTING.txt'))


def read_ble_fingerprinting_from_file(datafile=r'../Data/BLE_FINGERPRTING.txt', *args, **kwargs):
    """从datafile文件中读取指纹数据
    -----
    参数
    datafile:str
        数据文件文件路径
    -----
    返回
    ble_fingerprinting:DataFrame
        ble指纹数据
    """
    ble_fingerprinting = pd.DataFrame(
        columns=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7', 'POS'])
    # beacon's name = [Beacon0,Beacons1,Beacons6,Beacons7]
    data_temp = pd.read_csv(datafile, usecols=['RSSI_FG', 'POS'])
    for i_index, j_index in zip(data_temp['RSSI_FG'], data_temp['POS']):
        rssi_temp = np.array([float(val)
                             for val in re.findall(r'[-\d|\d]{1,}\.', i_index)])
        pos_temp = np.array([float(val)
                            for val in re.findall(r'[-\d|\d]{1,}', j_index)])
        data_temp_index = len(ble_fingerprinting)
        ble_fingerprinting.at[data_temp_index, 'Beacon0'] = rssi_temp[0]
        ble_fingerprinting.at[data_temp_index, 'Beacon1'] = rssi_temp[1]
        ble_fingerprinting.at[data_temp_index, 'Beacon6'] = rssi_temp[2]
        ble_fingerprinting.at[data_temp_index, 'Beacon7'] = rssi_temp[3]
        ble_fingerprinting.at[data_temp_index, 'POS'] = pos_temp
    print('load data from %s succeed.' % (datafile))
    return ble_fingerprinting


def save_ble_fingerprint_to_mat(ble_data, matfile=r'../Data/ble_data_base.mat', *args, **kwargs):
    """保存蓝牙指纹数据到mat文件
    -----
    参数
    ble_data:DataFrame
        待保存数据
    matfile:str
        mat文件路径
    -----
    返回
    None
    """
    ind = list(ble_data.index)
    col = list(ble_data.columns)
    io.savemat(matfile, {'data': ble_data.values, 'index': ind, 'cols': col})
    print('save to mat file %s' % (matfile))


def extract_ble_fingerprinting_run():
    """运行指纹提取
    -----
    参数
    None
    -----
    返回
    None
    """
    # 1.从指定文件夹提取指纹并保存到文件中
    extract_fingerprinting_from_dirs()
    # 2.从文件中提取指纹数据
    data_temp = read_ble_fingerprinting_from_file()
    # 3.将文件中提取的指纹数据保留为mat格式方便调用
    save_ble_fingerprint_to_mat(data_temp)


if __name__ == "__main__":
    extract_fingerprinting_from_dirs(extract_mean=1)
    data_temp = read_ble_fingerprinting_from_file()
    save_ble_fingerprint_to_mat(data_temp)
