# -*- coding: utf-8 -*-
"""
Created on Tue Dec 14 15:23:22 2021

@author: W-H
"""

import seaborn as sns
from math import sqrt
from sklearn.metrics import mean_squared_error
from sklearn.neighbors import KNeighborsRegressor
from sklearn.model_selection import train_test_split
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
url = (
    "https://archive.ics.uci.edu/ml/machine-learning-databases"
    "/abalone/abalone.data")
abalone = pd.read_csv(url, header=None)
abalone.columns = ["Sex",
                   "Length",
                   "Diameter",
                   "Height",
                   "Whole weight",
                   "Shucked weight",
                   "Viscera weight",
                   "Shell weight",
                   "Rings"]
abalone = abalone.drop("Sex", axis=1)
# abalone["Rings"].hist(bins=15)
# plt.show()
# %%
X = abalone.drop("Rings", axis=1)
X = X.values
y = abalone["Rings"]
y = y.values
new_data_point = np.array(
    [0.569552, 0.446407, 0.154437, 1.016849, 0.439051, 0.222526, 0.291208])
distances = np.linalg.norm(X - new_data_point, axis=1)
k = 3
nearest_neighbor_ids = distances.argsort()[:k]
nearest_neighbor_rings = y[nearest_neighbor_ids]
prediction = nearest_neighbor_rings.mean()

# %%
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=12345)
knn_model = KNeighborsRegressor(n_neighbors=3)
knn_model.fit(X_train, y_train)
train_preds = knn_model.predict(X_train)
mse = mean_squared_error(y_train, train_preds)
rmse = sqrt(mse)
# %%
test_preds = knn_model.predict(X_test)
mse = mean_squared_error(y_test, test_preds)
rmse = sqrt(mse)
rmse
cmap = sns.cubehelix_palette(as_cmap=True)
f, ax = plt.subplots()
points = ax.scatter(X_test[:, 0], X_test[:, 1], c=test_preds, s=50, cmap=cmap)
f.colorbar(points)
plt.show()
