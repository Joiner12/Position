# -*- coding: utf-8 -*-
"""
Created on Fri Oct 15 11:10:45 2021

@author: W-H
"""

import dominate
from dominate.tags import *
from datetime import datetime
import os
import re

srcpicFolder = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img'
targetHtmlFile = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.html'

# todo:finished the block


def CheckValidPic(srcfolder, *pk, **pkw):
    fullPathPics = list()
    dirs = os.listdir(srcfolder)
    for k in dirs:
        b = re.findall(r'static-P\d{1,}-\d.png', k)
        if b:
            print(b[0])
            fullPathPics.append(os.path.join(srcpicFolder, b[0]))
    return fullPathPics


def generatepage(targetHtmlFile, *pk, **pkw):
    picName = ['P0', 'P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P11', 'P12', 'P13', 'P14',
               'P15', 'P16', 'P17', 'P18', 'P19', 'P20', 'P21', 'P22', 'P23', 'P24', 'P25']
    doc = dominate.document(title=r"static positioning ")
    doc.body['style'] = "text-align:center;"
    with doc:
        h1("静态位置定位结果", style="font-size:45px;color: #231820;font-weight: Bold;")
        p('Update time:'+datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
          style="font-size:20px;text-align:center;color:#6D7F7D")
    # <div>
    #         <img src="D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-P0-2.png" style="zoom:110%;">
    #         <p style="font-size:30px;">P0</p>
    #     </div>
    with doc.body:
        for k in picName:
            curDiv = div()
            imgFileName = r"D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-" + \
                str(k)+r"-2.png"
            curDiv.add(p(k+"定位结果", style="font-size:30px;color:black"))
            curDiv.add(img(src=imgFileName, style="zoom:120%"))

    with open(targetHtmlFile, 'w', encoding='utf-8') as f:
        f.write(doc.render())
    print('Update static positioning',
          datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


if __name__ == "__main__":
    CheckValidPic(srcpicFolder)
