# -*- coding: utf-8 -*-
"""
Created on Wed Dec  8 16:26:56 2021

@author: W-H
"""

import pandas as pd
import os
from itertools import product
import re


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
            if not k_3 in ble_rssis:
                ble_fingerprints.at[len(ble_rssis), 'RSSI_FG'] = k_3
                ble_fingerprints.at[len(ble_rssis), 'POS'] = pos

    return ble_fingerprints


def extract_fingerprinting_from_dirs(*args, **kwargs):
    ble_fingerprints_all = pd.DataFrame(columns=['RSSI_FG', 'POS'])
    """ 从指纹原始数据文件夹中提取所有的指纹数据,并输出为特定格式保存
    -----
    参数
    None
    -----
    输出
    None
    说明
        原始指纹数据保存再../Data/BLE-FINGERPRING/中,文件名为x-y.txt,
        其中x表示相对于水平轴的偏移量，y表示相对于垂直轴偏移量。具体位置
        及坐标定义参考../Doc/BLE-Fingerprinting.drawio
    """
    #
    src_folder = '../Data/BLE-FINGERPRING/'
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
    for data_file in src_data_file:
        ble_data = get_valid_data(data_file,
                                  beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])
        ble_fingerprints = generate_ble_fingerprintings_v1(ble_data, pos=pos)
        print(data_file)
        print(ble_fingerprints_all)
        ble_fingerprints_all = pd.concat(
            [ble_fingerprints_all, ble_fingerprints], ignore_index=True)
    ble_fingerprints_all.to_csv(r'../Data/BLE_FINGERPRTING.csv')
    print('----finished----')


if __name__ == "__main__":
    if False:
        ble_data = get_valid_data(
            r'../Data/BLE-FINGERPRING/0-0.txt',
            beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])
        ble_fingerprints = generate_ble_fingerprintings_v1(ble_data)
    extract_fingerprinting_from_dirs()
