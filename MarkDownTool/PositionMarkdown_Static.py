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
targetHtmlFile = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\静态点定位结果.html'

# todo:finished the block


def CheckValidPic(srcfolder, *pk, **pkw):
    fullPathPics = list()
    picnums = list()
    dirs = os.listdir(srcfolder)
    for k in dirs:
        b = re.findall(r'static-P\d{1,}-2.png', k)
        if b:
            c = re.findall(r'-P(\d{1,})', b[0])
            picnums.append(int(c[0]))
    picnums.sort()
    for j in picnums:
        picname = 'static-P'+str(j)+'-2.png'
        fullPathPics.append(os.path.join(srcpicFolder, picname))
    return fullPathPics


def generatepage(targetHtmlFile, PicFiles, *pk, **pkw):
    # D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-P36-2L.png
    # D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-P0-2.png
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
        for imgFileName in PicFiles:
            b = re.findall(r'static-(P\d{1,})-2.png', imgFileName)
            curDiv = div()
            curDiv.add(p(b[0]+"定位结果", style="font-size:30px;color:black"))
            curDiv.add(img(src=imgFileName, style="zoom:120%"))

    with open(targetHtmlFile, 'w', encoding='utf-8') as f:
        f.write(doc.render())
    print(doc.render())
    print('Update static positioning',
          datetime.now().strftime('%Y-%m-%d %H:%M:%S'))


if __name__ == "__main__":
    fullPathPics = CheckValidPic(srcpicFolder)
    if fullPathPics:
        generatepage(targetHtmlFile, fullPathPics)
