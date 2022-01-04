## 蓝牙+IMU定位文献整理

1.[A BLE RSSI ranking based indoor positioning system for generic smartphones | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7943542)

- 不同的蓝牙接收设备，相同条件下接收到的RSSI值会有差异，许多现有的 RSSI 方法在进行指纹识别时会关联原始 RSSI 值，这会降低定位精度。 为了应对这一挑战，一种很有前途的技术似乎是使用（Kendall Tau Correlation Coefficient）KTCC 对 RSSI 进行排序。Weighted K-Nearest Neighbor  Classification Algorithm.(WKNN)
- 人体对2.4G信号遮挡很强；
- WKNN的k值取3；
- low-energy low-cast 10HZ蓝牙发送频率；

3.[Sensors | Free Full-Text | BLE Fingerprint Indoor Localization Algorithm Based on Eight-Neighborhood Template Matching | HTML (mdpi.com)](https://www.mdpi.com/1424-8220/19/22/4859/htm)

<img src="https://www.mdpi.com/sensors/sensors-19-04859/article_deploy/html/images/sensors-19-04859-g001.png">

- knn和wknn原理介绍；
- 蓝牙RSSI受环境影响大，会出现KNN相似度高但是距离远的匹配结果；
- 提出了8临近点相似度修正算法，同时引入了RSSI对数模型测距判断远近；



4.[3-D BLE Indoor Localization Based on Denoising Autoencoder | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7959171)

- 采用深度学习模型（去噪自编码-denosing autoencoder ），从含噪声RSSI观测值中提取的指纹模式；
- <img src="https://ieeexplore.ieee.org/mediastore_new/IEEE/content/media/6287639/7859429/7959171/yang1-2720164-large.gif">



5.[Mobile Localization-Based Service Based on RSSI Fingerprinting Method by BLE Technology | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8576227)

- fuzzy logical-模糊逻辑
- 区域划分概念：在本文中，RSS 的波动被考虑到不同的水平（例如，远、中、近）。 因此，我们可以根据其级别来估算信标发射器与其接收器之间的距离。 由于两个或多个信标可以属于同一级别，因此我们可以关注相交区域以缩小估计范围。 通过 RSS 的交叉级别，一个区域被划分为多个区域。 
- 离线阶段：用接收到的信息构建辐射图。 然后，通过辐射图的方式用离线数据定义模糊集。 在线阶段，为了得到模糊集合的对应标签，将接收到的RSS代入模糊隶属度函数。 通过指纹识别，将数据库中的标签和模糊规则库进行比较以确定位置。 

6.[Trilateration With BLE RSSI Accounting for Pathloss Due to Human Obstacles | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8911816)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211110161642.png">

- 提出了一种在线定位算法，该算法动态估计每个广播通道的路径损耗系数。 识别人体遮挡，校准RSSI的值，并将校准后的每个信道RSSI值作为指纹识别的输入；
- 没有说明蓝牙信道怎样实现区分的；

7.[Indoor Localization with lightweight RSS Fingerprint using BLE iBeacon on iOS platform | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8905160)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211110162700.png">

- 为了降低计算成本并保证计算的准确性，提出使用包含最近信标ID及RSSI、设备方位角信息的轻量级特征向量来训练机器学习算法。 
- 使用手机内置磁力计获取手机朝向；
- 

8.[Analysis of RSSI Fingerprinting in LoRa Networks | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8766468)

- LoRa: Long Range Radio

9.[Energies | Free Full-Text | Developing a BLE Beacon-Based Location System Using Location Fingerprint Positioning for Smart Home Power Management (mdpi.com)](https://www.mdpi.com/1996-1073/11/12/3464)

<img src="https://www.mdpi.com/energies/energies-11-03464/article_deploy/html/images/energies-11-03464-g006.png">

- 三边定位+局部指纹

11.[Electronics | Free Full-Text | A Comparison Analysis of BLE-Based Algorithms for Localization in Industrial Environments (mdpi.com)](https://www.mdpi.com/2079-9292/9/1/44)

- 指纹算法的鲁棒性优于三边测量，对环境变化具有良好适应性。 
- 三种指纹算法：k-最近邻、支持向量机或多层感知器 。由于定位结果误差基本一致，且k-NN 部署简单，超参数数量少是首选算法。

12.[Sensors | Free Full-Text | Optimized CNNs to Indoor Localization through BLE Sensors Using Improved PSO (mdpi.com)](https://www.mdpi.com/1424-8220/21/6/1995)

<img src="https://www.mdpi.com/sensors/sensors-21-01995/article_deploy/html/images/sensors-21-01995-g002.png">

- 提出基于卷积神经网络 (CNN) 的定位模型，该模型基于由来自 x 轴和 y 轴的RSSI组成的 2D 图像。
- 采用了神经进化方法改进CNN，具体为通过增强的粒子群优化 (PSO) 来动态优化和创建网络中的多个层。 对于CNN的优化，将PSO得到的全局最优解直接赋予CNN每一层的权重。 此外， PSO 中使用动态惯性权重，而不是恒定惯性权重，以保持 CNN 层的长度与RSSI 信号相对应。 
- 

14.[Low-cost BLE based Indoor Localization using RSSI Fingerprinting and Machine Learning | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/9419388)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211111101050.png">

- 增加了指纹数据以克服RSSI波动大的缺点。
-  指纹导出的数据包含 7 列。这些是时间戳 信号，网格的 X 坐标，网格的 Y 坐标，最后是 4 个锚节点的 RSSI 值。对于每个网格，每个锚节点的 RSSI 值被观察 60 次。为每个网格形成了一个称为标签的新特征，作为对数据进行分类的目标变量。鉴于该系统是每个节点观察到的数据较少，不足以让算法对数据进行学习和分类。因此提出了一种数据增强技术。首先为参考数据集定义了一个特定的重复次数 N。然后将这个重复次数N与 python 函数样本一起使用，从每个节点随机选择 N 个数据点，并再次替换它。对每个网格的每个节点重复此操作。在我们的用例中，重复次数设置为 200，这将数据集增加了三倍。 
- 分类算法对比：Random Forest(随机森林)、XGBoost、 Decision Trees(决策树)、KNN(k-临近)、SVC(支持向量机)，随机森林分类器的准确率高达 96% 、最低误差为 0.04。 

15.[Phone Application for Indoor Localization Based on Ble Signal Fingerprint | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8328729)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211111102852.png">

- 系统地进行了手机上的BLE指纹定位算法实现；
- 提出了使用径向基函数（RBF ）该函数没是有任何调整参数的简单 RBF 函数。



16.[An Iterative Weighted KNN (IW-KNN) Based Indoor Localization Method in Bluetooth Low Energy (BLE) Environment | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7816923/)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211111104411.png">

- 提出了一种迭代加权 KNN (IW-KNN) 室内RSSI（Receive Signal Strength indicator）指纹定位方法。
- 获取了大量 RSSI 数据以建立指纹数据库。
- IW-KNN 有三种主要的改进点： 首先结合欧氏距离和余弦相似度来衡量两个RSSI向量的相似度，可以同时取长度和向量的方向作为参考。 其次，与传统的 KNN（K Nearest Neighbors）不同，KNN（K Nearest Neighbors）通过邻居的多数来估计位置，权重因子应用于邻居以进行定位。 第三，IW-KNN 在每次迭代时选择不同的 iBeacon 获得 RSSI，并在多次迭代后计算平均位置作为最终结果。 
- 对比传统KNN、Similarity Improvement KNN、Weighted KNN、IW-KNN等几种室内定位方法。

17.[Sensors | Free Full-Text | Indoor Positioning Based on Bluetooth Low-Energy Beacons Adopting Graph Optimization (mdpi.com)](https://www.mdpi.com/1424-8220/18/11/3736)

<img src="https://www.mdpi.com/sensors/sensors-18-03736/article_deploy/html/images/sensors-18-03736-g001.png" style="width:60%;">

- 提出了一种基于图优化的估计信标位置和指纹参考地图的方法，这种方法结合了基于距离和基于指纹。
-  通过行人航位推算（PDR）方法生成相邻位姿的约束。 此外，采用BLE指纹生成姿态之间的约束（具有相似指纹），采用RSSI生成姿态和信标位置之间的距离约束（根据预定义的路径损耗模型）。



18.[Smartphone-Based Indoor Positioning Using BLE iBeacon and Reliable Lightweight Fingerprint Map | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/9075151)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211111144018.png">

- PDR中初始点位置对后期结果影响很大，文中提出了用三边定位的方法估计初始位置；
- 提出了一种轻量级的指纹方法。 该方法解决了两个问题：（1）纠正由于PDR初始位置误差和轨道漂移引起的误差，（2）减少数据量、参考点数量和收集数据时间。 
- 分析了不同朝向对接收RSSI的影响；

19.[Sensors | Free Full-Text | Model-Based Localization and Tracking Using Bluetooth Low-Energy Beacons (mdpi.com)](https://www.mdpi.com/1424-8220/17/11/2484)

- 提出了一种基于 Wasserstein 距离的最佳传输观察模型。
- 将基于 Wasserstein 距离插值的观察模型与用于跟踪的顺序蒙特卡罗 (SMC) 方法相结合。

20.[Sensors | Free Full-Text | Fuzzy Logic Type-2 Based Wireless Indoor Localization System for Navigation of Visually Impaired People in Buildings (mdpi.com)](https://www.mdpi.com/1424-8220/19/9/2114)

- 提出了使用fuzzy  logic type -2（犹豫模糊集）的指纹匹配算法算法。

21.[Beacon based indoor positioning system using weighted centroid localization approach | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7536951)

-  加权质心三边定位

22.[Sensors | Free Full-Text | An Improved BLE Indoor Localization with Kalman-Based Fusion: An Experimental Study (mdpi.com)](https://www.mdpi.com/1424-8220/17/5/951)

<img src="https://www.mdpi.com/sensors/sensors-17-00951/article_deploy/html/images/sensors-17-00951-g009.png">

- 三边定位+PDR；
- 三边定位和PDR定位结果采用kalman融合；

23.[InLoc: An end-to-end robust indoor localization and routing solution using mobile phones and BLE beacons | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7743592)

-  矢量地图预处理 
- IMU+BLE

24.[Sensors | Free Full-Text | Fast Signals of Opportunity Fingerprint Database Maintenance with Autonomous Unmanned Ground Vehicle for Indoor Positioning (mdpi.com)](https://www.mdpi.com/1424-8220/18/10/3419)

- BLE RSSI fingerprint
- SLAM
- A* 路径规划

25.[Improving Indoor Localization Using Bluetooth Low Energy Beacons (hindawi.com)](https://www.hindawi.com/journals/misy/2016/2083094/)

- 蓝牙指纹+wifi 指纹；
- 蓝牙指纹使用WKNN(weighed k-Nearest Neighbors)。



26.[Bluetooth Based Indoor Positioning Using Machine Learning Algorithms | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8552138)

<img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211124204842.png">

- 服务器&客户端模式（client & server）
- 论文论述了使用机器学习的思路，没有说明具体实现过程。

27.[Assessing the impact of multi-channel BLE beacons on fingerprint-based positioning | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/8115871/)

- 提出了一种在发射端按时序修改蓝牙信道的方法；
- ..

28.[Sensors | Free Full-Text | An IBeacon-Based Location System for Smart Home Control (mdpi.com)](https://www.mdpi.com/1424-8220/18/6/1897)

<img src="https://www.mdpi.com/sensors/sensors-18-01897/article_deploy/html/images/sensors-18-01897-g001.png">

- 本文提出了基于RSSI随机特征的指纹匹配概念和基于地磁传感的姿态识别模型，结合行人航位推算(PDR)技术，更好地解决时变问题，提高定位精度。 
- 应用威布尔函数来描述蓝牙信号强度分布，并通过最大概率准则确定最佳位置。 

29.[GRNN and KF framework based real time target tracking using PSOC BLE and smartphone - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1570870518305195)

- 提出了 使用Generalized Regression Neural Network处理RSSI和距离之间的对应关系，该研究表明，在处理 RSSI 与移动目标位置之间的高度非线性关系时，GRNN 优于三边测量技术。
- 提出了两种基于 GRNN 的算法，即 GRNN + KF 和 GRNN + UKF，用于有效跟踪单个运动目标。整体跟踪性能根据 RMSE 和平均定位误差进行评估。基于 GRNN + UKF 的方法更好。

31.[Gradient-Based Fingerprinting for Indoor Localization and Tracking | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7360180/)

- 针对wifi，由于无线信号强度随时间变化，RSSI指纹地图需要定期校准、跨设备的有偏 RSSI 测量以及 WiFi 路由器的传输功率控制技术进一步破坏了现有基于指纹的定位系统的保真度问题。
- 提出了梯度指纹（GIFT）算法。
- GIFT 背后的基本原理来自观察附近位置之间的差分 RSSI 比绝对 RSSI 值更稳定，更重要的是，它和传输功率和传感设备关系不大。
- 

32.[Sensors | Free Full-Text | Indoor Positioning Algorithm Based on the Improved RSSI Distance Model (mdpi.com)](https://www.mdpi.com/1424-8220/18/9/2820)

- 本文提出了一种实现RSSI动态校正的室内定位方法。
- 离线阶段使用 PSO-BPNN 训练的 RSSI-距离模型。然后，我们使用所提出的算法实时校正RSSI，并使用卡尔曼滤波器进一步平滑数据。

33.[Indoor positioning system based on BLE location fingerprinting with classification approach - ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S0307904X18302841?casa_token=WfIFmxw7CawAAAAA:088yKOs3CYfdxE8np70ptCCOPOA958LmOKpYOr67Df_v6cbAEmSKIHPToo1F2IyBzxRA6Nujjo8)

- 提出了一种基于KNN&WKNN的蓝牙指纹定位算法；
- 文献中说明，k=3 or 5时候定位精度最高；
- 文献表明knn中，Chebyshev距离比欧式距离定位效果更好；



34.[Indoor positioning of shoppers using a network of Bluetooth Low Energy beacons | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7743684)

- 三边定位算法

35.[Location Fingerprinting With Bluetooth Low Energy Beacons | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7103024/)

Location Fingerprinting With Bluetooth Low Energy Beacons

- 研究使用 BLE 无线电信号进行准确室内定位的关键参数，发射功率、信标密度、窗口大小；
- 讨论了蓝牙三信道传播的影响，但是并没提出解决方案；
- 使用贝叶斯估计器进行位置推算；



36.[Performance analysis of multiple Indoor Positioning Systems in a healthcare environment | International Journal of Health Geographics | Full Text (biomedcentral.com)](https://ij-healthgeographics.biomedcentral.com/articles/10.1186/s12942-016-0034-z)

- 测试报告

38.[(PDF) RSSI Fingerprinting Techniques for Indoor Localization Datasets (researchgate.net)](https://www.researchgate.net/publication/344274960_RSSI_Fingerprinting_Techniques_for_Indoor_Localization_Datasets)

- not fount doi

40.[Machine Learning Based Indoor Localization Using Wi-Fi RSSI Fingerprints: An Overview | IEEE Journals & Magazine | IEEE Xplore](https://ieeexplore.ieee.org/document/9531633)

- Bluetooth Based Indoor Positioning Using Machine Learning Algorithms

- 列举了室内定位(WIFI Fingerprinting)的应用场景；

- Machine Learning Model

  > <img src="https://ieeexplore.ieee.org/mediastore_new/IEEE/content/media/6287639/9312710/9531633/choe3-3111083-large.gif" style="zoom:50%">

- figureprinting step

  > <img src="https://ieeexplore.ieee.org/mediastore_new/IEEE/content/media/6287639/9312710/9531633/choe4-3111083-large.gif" style="zoom:50%">



- 建图方法
- 举例说明了数据预处理过程中使用的ML方法；
- 定位过程中的ML处理方法，KNN、SVM、DT(decision tree)、ANN.
- wifi figureprint 公开数据库。

41.[RSSI Fingerprinting Techniques for Indoor Localization Datasets | SpringerLink](https://link.springer.com/chapter/10.1007/978-3-030-49932-7_45)

- 404

42.[Low-Complexity Offline and Online Strategies for Wi-Fi Fingerprinting Indoor Positioning Systems - ScienceDirect](https://www.sciencedirect.com/science/article/pii/B9780128131893000071)

43.[Practical Fingerprinting Localization for Indoor Positioning System by Using Beacons (hindawi.com)](https://www.hindawi.com/journals/js/2017/9742170/)

- 通过指纹与加权质心定位相结合混合定位；

- 指纹定位使用的是w-knn；

- 离线阶段数据采集采集了四个方位的RSSI；

  > <img src="https://static-01.hindawi.com/articles/js/volume-2017/9742170/figures/9742170.fig.003.svgz">

- 指纹系统架构

  > <img src="https://static-01.hindawi.com/articles/js/volume-2017/9742170/figures/9742170.fig.004.svgz" style="zoom:100%">

- 用了高斯滤波器来估计训练或离线阶段的RSSI值，在线估计阶段对RSSI使用滑动均值滤波器；
- 

44.[IJGI | Free Full-Text | A RSSI/PDR-Based Probabilistic Position Selection Algorithm with NLOS Identification for Indoor Localisation (mdpi.com)](https://www.mdpi.com/2220-9964/7/6/232)

- 为了提高位置选择算法在混合视距（LOS）和非视距（NLOS）环境中的准确性和可靠性，提出了一种低复杂度的识别方法来识别变化 在NLOS和LOS之间的信道情况；

- NLOS 和LOS分辨方法：

  基于机器学习：

  最小二乘支持向量机分类器、高斯过程分类器

  基于假设检验：

  Hypothesis Testing Classifier

- 三边定位+非视距特定处理方案+轨迹推算

  > <img src="https://gitee.com/RiskyJR/pic-bed/raw/master/20211125172442.png" style="zoom:50%">



45.[Indoor person localization system through RSSI Bluetooth fingerprinting | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/6208163)

- 01 June 2012 & No DOI

47.[RSSI-Based Bluetooth Indoor Localization | IEEE Conference Publication | IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/7420939)

- 三边定位

50.[Bluetooth Low Energy Technology Applied to Indoor Positioning Systems: An Overview | SpringerLink](https://link.springer.com/chapter/10.1007/978-3-030-45093-9_11)

51.[Sensors | Free Full-Text | An Empirical Study of the Transmission Power Setting for Bluetooth-Based Indoor Localization Mechanisms (mdpi.com)](https://www.mdpi.com/1424-8220/17/6/1318)

- 论文表明使用性能良好的 BLE4.0 接收器的重要性，BLE4.0 天线用于室内定位，与使用智能手机获得的天线相比，精度显着提高。 

54.[Sensors | Free Full-Text | Fast Fingerprint Database Maintenance for Indoor Positioning Based on UGV SLAM (mdpi.com)](https://www.mdpi.com/1424-8220/15/3/5311)

55.PDR+(wifi)CSI指纹室内定位技术研究

- 信道状态信息（Channel State Information，CSI）利用正交频分复用（Orthogonal Frequency Division Multiplexing，OFDM）是信号在空间上传输中的本质描述，可以更全面的反应室内环境信息，因此将CSI 作为位置指纹特征可以更好地提高室内定位精度。
- 识别行人运动模式一般采用机器学习分类算法，支持向量机（Support Vector Machine，SVM）是机器学习中常用的分类算法，利用 SVM 对不同人体运动模式进行分类器训练，并评价分类器性能后对人体行走过程中的运动模式进行识别。
- KNN指纹匹配算法；

