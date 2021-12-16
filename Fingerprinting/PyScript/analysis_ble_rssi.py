# -*- coding: utf-8 -*-
"""
Created on Thu Dec 16 15:30:18 2021

@author: W-H
"""
import matplotlib.pyplot as plt
from bledatabase import get_valid_data
from scipy.ndimage import gaussian_filter
import numpy as np
from scipy.stats import norm
import os
# %%
data_path = r'D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Data\BLE-FINGERPRING'
files = os.listdir(data_path)
for file in files:
    ble_data = get_valid_data(
        os.path.join(data_path, file),
        beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])
    # ble_data = get_valid_data(
    #     r'../Data/BLE-FINGERPRING/5-2.txt',
    #     beacon_filter=['Beacon0', 'Beacon1', 'Beacon6', 'Beacon7'])
    pre_name = os.path.splitext(file)[0]
    beacon0_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon0', 'RSSI']
    beacon1_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon1', 'RSSI']
    beacon6_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon6', 'RSSI']
    beacon7_rssi = ble_data.loc[ble_data['NAME'] == 'Beacon7', 'RSSI']
    fig1 = plt.figure(figsize=[6.4*2, 4.8*2])
    ax0 = fig1.add_subplot(221)
    ax1 = fig1.add_subplot(222)
    ax2 = fig1.add_subplot(223)
    ax3 = fig1.add_subplot(224)
    ax0.plot(beacon0_rssi, marker='*', linestyle='none')

    ax0.set(xlabel='serial (n)', ylabel='RSSI (dBm)',
            title='beacon0')
    ax0.grid()
    ax1.plot(beacon1_rssi, marker='*', linestyle='none')

    ax1.set(xlabel='serial (n)', ylabel='RSSI (dBm)',
            title='beacon1')
    ax1.grid()
    ax2.plot(beacon6_rssi, color='red', marker='*', linestyle='none')

    ax2.set(xlabel='serial (n)', ylabel='RSSI (dBm)',
            title='beacon6')
    ax2.grid()
    ax3.plot(beacon7_rssi, marker='*', linestyle='none')

    ax3.set(xlabel='serial (n)', ylabel='RSSI (dBm)',
            title='beacon7')
    ax3.grid()
    # plt.show()
    fig1.savefig(os.path.join(
        r'D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Doc\BLE-RSSI-CHAR', 'RSSI-'+pre_name+'.png'))
    # Generate some data for this demonstration.
    # data = norm.rvs(10.0, 2.5, size=500)
    data0 = list(beacon0_rssi)
    mu0, std0 = norm.fit(data0)
    data1 = list(beacon1_rssi)
    mu1, std1 = norm.fit(data1)
    data6 = list(beacon6_rssi)
    mu6, std6 = norm.fit(data6)
    data7 = list(beacon7_rssi)
    mu7, std7 = norm.fit(data7)

    fig2 = plt.figure(figsize=[6.4*2, 4.8*2])
    ax0 = fig2.add_subplot(221)
    ax1 = fig2.add_subplot(222)
    ax6 = fig2.add_subplot(223)
    ax7 = fig2.add_subplot(224)
    # Plot the histogram.
    ax0.hist(data0, bins=10, density=True,
             alpha=0.6, label='RSSI distribution')
    xmin, xmax = ax0.get_xlim()
    print(ax0.get_xlim())
    ax0.plot(np.linspace(xmin, xmax, 100), norm.pdf(
        np.linspace(xmin, xmax, 100), mu0, std0),  linewidth=2, label='Gaussian distribution')
    ax0.set(xlabel='RSSI', ylabel='probability',
            title='beacon0')
    ax1.hist(data1, bins=10, density=True,
             alpha=0.6, label='RSSI distribution')
    xmin, xmax = ax1.get_xlim()
    ax1.plot(np.linspace(xmin, xmax, 100), norm.pdf(
        np.linspace(xmin, xmax, 100), mu1, std1),  linewidth=2, label='Gaussian distribution')
    ax1.set(xlabel='RSSI', ylabel='probability',
            title='beacon1')
    # Plot the histogram.
    ax6.hist(data6, bins=10, density=True,
             alpha=0.6, label='RSSI distribution')
    xmin, xmax = ax6.get_xlim()
    ax6.plot(np.linspace(xmin, xmax, 100), norm.pdf(
        np.linspace(xmin, xmax, 100), mu6, std6),  linewidth=2, label='Gaussian distribution')
    # Plot the histogram.
    ax6.set(xlabel='RSSI', ylabel='probability',
            title='beacon6')
    ax7.hist(data7, bins=10, density=True,
             alpha=0.6, label='RSSI distribution')
    xmin, xmax = ax7.get_xlim()
    ax7.plot(np.linspace(xmin, xmax, 100), norm.pdf(
        np.linspace(xmin, xmax, 100), mu7, std7),  linewidth=2, label='Gaussian distribution')
    ax7.set(xlabel='RSSI', ylabel='probability',
            title='beacon7')
    fig2.savefig(os.path.join(
        r'D:\Code\BlueTooth\pos_bluetooth_matlab\Fingerprinting\Doc\BLE-RSSI-CHAR', 'RSSI-FIT'+pre_name+'.png'))
    # plt.show()

# %%%
fig = plt.figure()
# plt.gray()  # show the filtered result in grayscale
ax1 = fig.add_subplot(111)  # left side
result = gaussian_filter(list(beacon0_rssi), sigma=2)
ax1.plot(list(beacon0_rssi), label='origin')
ax1.plot(result, label='gaussian filter')
ax1.legend()
plt.show()


# %%%
# Generate some data for this demonstration.
# data = norm.rvs(10.0, 2.5, size=500)
data0 = list(beacon0_rssi)
mu0, std0 = norm.fit(data0)
data1 = list(beacon1_rssi)
mu1, std1 = norm.fit(data1)
data6 = list(beacon6_rssi)
mu6, std6 = norm.fit(data6)
data7 = list(beacon7_rssi)
mu7, std7 = norm.fit(data7)

fig1 = plt.figure()
ax0 = fig1.add_subplot(221)
ax1 = fig1.add_subplot(222)
ax6 = fig1.add_subplot(223)
ax7 = fig1.add_subplot(224)
# Plot the histogram.
ax0.hist(data0, bins=10, density=True, alpha=0.6)
xmin, xmax = ax0.get_xlim()
print(ax0.get_xlim())
ax0.plot(np.linspace(xmin, xmax, 100), norm.pdf(
    np.linspace(xmin, xmax, 100), mu0, std0),  linewidth=2)
# # # xmin, xmax = plt.xlim()
# # # x = np.linspace(xmin, xmax, 100)
# # # p = norm.pdf(x, mu, std)
# # # plt.plot(x, p,  linewidth=2)
# Plot the histogram.
ax1.hist(data1, bins=10, density=True, alpha=0.6)
xmin, xmax = ax1.get_xlim()
ax1.plot(np.linspace(xmin, xmax, 100), norm.pdf(
    np.linspace(xmin, xmax, 100), mu1, std1),  linewidth=2)
# Plot the histogram.
ax6.hist(data6, bins=10, density=True, alpha=0.6)
xmin, xmax = ax6.get_xlim()
ax6.plot(np.linspace(xmin, xmax, 100), norm.pdf(
    np.linspace(xmin, xmax, 100), mu6, std6),  linewidth=2)
# Plot the histogram.
ax7.hist(data7, bins=10, density=True, alpha=0.6)
xmin, xmax = ax7.get_xlim()
ax7.plot(np.linspace(xmin, xmax, 100), norm.pdf(
    np.linspace(xmin, xmax, 100), mu7, std7),  linewidth=2)
plt.show()