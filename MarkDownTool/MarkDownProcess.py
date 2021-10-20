# -*- coding: utf-8 -*-
"""
Created on Tue Oct 19 09:58:43 2021

@author: W-H
"""

import dominate
from dominate.tags import *
from datetime import datetime
import os
import re
srcpicFolder = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1'
targetHtmlFile = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.html'


def generatepage():
    pics = list()
    dirs = os.listdir(srcpicFolder)
    for k in dirs:
        b = re.findall(r'location-temp\d{1,}.png', k)
        if not b is None:
            print(b[0])
            pics.append(b[0])

    if len(pics) == 0:
        return
    mainpage = dominate.document(title="🛴Process Handle")
    with mainpage.head:
        meta(charset="UTF-8")
        style("""
        .analyseBox {
                width: 1500px;
                height: 850px;
                display: flex;
                flex-wrap: wrap;
                justify-content: space-between;
                margin: 0 auto;
            }

            .analyseItem {
                width: 40%;
                height: 100%;
                position: relative;
                text-align: center;
                margin-bottom: 2px;
            }

            .analyseItem>img {
                width: 100%;
                height: 100%;
            }

            .analyseItem>p {
                position: absolute;
                top: 2px;
                left: 0;
                right: 0;
                margin: auto;
                width: fit-content;
                white-space: nowrap;
                transform: translateY(40px);
            }""")

    # title & update info
    with mainpage.body:
        h1('定位过程分析', style="font-size:45px;text-align: center;")
        p('update: '+datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
          style="text-align: center;")
    # pictures
    partDiv = div(cls="analyseBox")
    mainpage.body += partDiv
    with partDiv:
        for k in range(len(pics)):
            with div(cls="analyseItem"):
                src = r"location-temp"+str(k+1)+r".png"
                src = os.path.join(srcpicFolder, src)
                p('location:'+str(k+1), style="font-size:30px;")
                img(src=src)
    if True:
        with open(targetHtmlFile, 'w', encoding='utf-8') as f:
            f.write(mainpage.render())

if __name__ == "__main__":
    generatepage()
