function config = sys_config()
    %功能：系统参数配置，设置各个构件所需的参数
    %定义：config = sys_config()
    %参数：
    %
    %输出：
    %    config：配置的参数
    config = struct();
    same_ap_judge_type = 'addr';

    %% 整合相同的ap数据
    %相同ap的判断方式
    config.integrate_same_ap_param.same_ap_judge_type = same_ap_judge_type;

    %% rssi拟合
    config.rssi_fit_type = 'scope_mean'; %拟合方式
    config.rssi_fit_param.scope_mean.rssi_range = 10; %允许的rssi范围最大值
    config.rssi_fit_param.scope_mean.ratio_thr = 0.75; %不可过滤的比例阈值(0~1)

    %% rssi滤波
    config.rssi_filter_param.moving_average_len = 5; %加权平滑滤波长度
    config.rssi_filter_param.gauss_filter_len = 20; %高斯滤波长度
    config.rssi_filter_param.gauss_probability = 0.6; %高斯滤波校正阈值
    config.rssi_filter_param.ap_buffer_valid_frame_num = 10; %缓存ap的有效上限
    config.rssi_filter_param.same_ap_judge_type = same_ap_judge_type; %相同ap的判断方式

    %% dbscan聚类法的ap选择器
    config.dbscan_selector_param.radius_calc.radius_max = 5000; %核心点邻域半径最大值
    config.dbscan_selector_param.dbscan.min_points = 0; %核心点邻域半径内点数最小值

    %% 计算离各个ap的距离
    %     config.dist_calc_type = 'logarithmic';  %距离计算的模式
    config.dist_calc_type = 'redefined_model'; %距离计算的模式

    %经典距离对数模型：信号传播参考距离d0(d0=1m)后产生的路径损耗,即d0处rssi
    %     config.dist_calc_param.logarithmic.rssi_reference = -10.61;
    %经典距离对数模型：路径损耗系数
    %     config.dist_calc_param.logarithmic.loss_coef = -1.327;
    config.dist_calc_param.logarithmic.loss_coef = -3;

    %距离高斯模型：高斯模型参数a
    config.dist_calc_param.gauss.a = 177.5;
    %距离高斯模型：高斯模型参数b
    config.dist_calc_param.gauss.b = -103;
    %距离高斯模型：高斯模型参数b
    config.dist_calc_param.gauss.c = 24.28;

    %高斯对数模型：高斯模型计算的rssi阈值
    config.dist_calc_param.gausslog.rssi_thr = -100;

    %% 分段计算各个ap的距离
    %环境参数分段rssi阈值
    config.subsection_dist_calc_param.rssi_thr = -65;
    %近距离环境参数
    config.subsection_dist_calc_param.close_range_loss_coef = -2.5;
    %远距离环境参数
    config.subsection_dist_calc_param.remote_loss_coef = -3;

    %% 距离三角补偿
    config.dist_triangle_compensate_meter = 2; %三角补偿的距离(单位：米)

    %% NewtonGaussLS 高斯牛顿迭代最小二乘算法（加权质心结果为初始点）
    config.newtongaussls_param.iterative_num_max = 10;

    %% 范围滤波
    if true
        % 蓝牙信标范围内的点作为滤波范围
        lat_tencent = [30.54785; 30.54785; 30.54804; 30.54804]; % data_import\tencent_lib_environment.m
        lon_tencent = [104.05855; 104.05892; 104.05892; 104.05855]; % data_import\tencent_lib_environment.m
        config.scope_filter_param.lat_max = max(lat_tencent); %纬度最大值
        config.scope_filter_param.lat_min = min(lat_tencent); %纬度最小值
        config.scope_filter_param.lon_max = max(lon_tencent); %经度最大值
        config.scope_filter_param.lon_min = min(lon_tencent); %经度最小值
    else
        config.scope_filter_param.lat_max = 60; %纬度最大值
        config.scope_filter_param.lat_min = 10; %纬度最小值
        config.scope_filter_param.lon_max = 200; %经度最大值
        config.scope_filter_param.lon_min = 100; %经度最小值
    end

    %% 跳点平滑滤波
    config.jump_smooth_filter_param.fit_dist_thr_max = 30; %坐标需拟合的最大距离门限(米)
    config.jump_smooth_filter_param.fit_dist_thr_min = 10; %坐标需拟合的最小距离门限(米)
    config.jump_smooth_filter_param.jump_num = 0; %连续跳点的次数
    config.jump_smooth_filter_param.jump_num_max = 20; %允许的连续跳点的次数上限
    config.jump_smooth_filter_param.smooth_len = 5; %平滑长度

    %% 通用参数
    %历史数据有效的帧数上限
    config.history_valid_frame_num = config.jump_smooth_filter_param.jump_num_max;

    %% 调试参数

    %% 调试过程信息-markdown
    % 写markdown文件标志
    config.write_markdown_flag = true;
    % markdown图片存贮位置
    config.save_procession_figure = true & config.write_markdown_flag;
    config.markdown_pic_path = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1';
    config.markdown_file_1 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md';
    config.markdown_file_2 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\动静态定位结果分析.md';
    config.markdown_file_3 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.html';
    %% 当前定位真实位置
    %{
    {
        "true_pos_name":P1,
        "lat":30,
        "lon":120
        }
    %}
    % 测试点数据1 update on:2021-10-08 11:44
    test_point_1_name = {"P0", "P1", "P2", "P3", "P4", "P5", "P6", "P7", ...
                        "P8", "P9", "P10", "P11", "P12", "P13", "P14", ...
                        "P15", "P16", "P17", "P18", "P19", "P20", "P21", ...
                        "P22", "P23", "P24", "P25"};

    test_point_1_lat = [30.54791184, 30.54790401, 30.54793101, ...
                        30.54789493, 30.54794679, 30.547878695800, ...
                        30.54791369, 30.54794521, 30.54792266, ...
                        30.54790463, 30.54787639, 30.54788535, ...
                        30.54788554, 30.54789482, 30.54789501, ...
                        30.54791173, 30.54791192, 30.54793089, ...
                        30.54793108, 30.54793991, 30.5479401, ...
                        30.54788523, 30.5478947, 30.54791161, ...
                        30.54793078, 30.5479398];
    test_point_1_lon = [104.0586157, 104.0585719, 104.0586155, ...
                        104.0586159, 104.0586154, 104.058616, ...
                        104.0586505, 104.0586886, 104.0587094, ...
                        104.0587095, 104.0586947, 104.0586003, ...
                        104.0586264, 104.0586002, 104.0586263, ...
                        104.0586001, 104.0586261, 104.0585999, ...
                        104.0586259, 104.0585998, 104.0586258, ...
                        104.0585847, 104.0585846, 104.0585844, ...
                        104.0585842, 104.0585842];
    true_pos_index = 1;
    config.cur_true_pos = struct('name', test_point_1_name{true_pos_index}, ...
        'lat', test_point_1_lat(true_pos_index), 'lon', test_point_1_lon(true_pos_index));

    %% 定位误差结果统计
    % 静态统计误差图片路径
    config.save_position_error_statistics_pic = false;
    config.position_error_statistics_pic = ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-P0-2.png';
    % 原始数据文件路径
    % config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6_3米\', ...
        %                             'P6-added_lat_lon.txt'];
    config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_100ms_6_3米_9月测试报告\', ...
                                'P0-added_lat_lon.txt'];
end
