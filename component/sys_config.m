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
    config.write_markdown_flag = false;
    % markdown图片存贮位置
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
    test_point_1_name = {"P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "P10"};

    test_point_1_lon = [104.0585719, 104.058615502714, 104.058615850824, ...
                        104.058615350415, 104.058616007473, 104.058660192224, ...
                        104.058688771294, 104.058709374097, 104.058709548135, ...
                        104.0586505];
    test_point_1_lat = [30.54790401, 30.547931006136, 30.547894930042, ...
                        30.547946789427, 30.547878695800, 30.547912297694, ...
                        30.547945353836, 30.547922664987, 30.547904626940, ...
                        30.54791369];

    % true_pos_p1 = struct('name', "P1", 'lat', test_point_1_lat(1), 'lon', test_point_1_lon(1));
    % config.true_pos1 = true_pos_p1;
    % true_pos_p2 = struct('name', "P2", 'lat', test_point_1_lat(2), 'lon', test_point_1_lon(2));
    % config.true_pos2 = true_pos_p2;
    % true_pos_p3 = struct('name', "P3", 'lat', test_point_1_lat(3), 'lon', test_point_1_lon(3));
    % config.true_pos3 = true_pos_p3;
    % true_pos_p4 = struct('name', "P4", 'lat', test_point_1_lat(4), 'lon', test_point_1_lon(4));
    % config.true_pos4 = true_pos_p4;
    % true_pos_p5 = struct('name', "P5", 'lat', test_point_1_lat(5), 'lon', test_point_1_lon(5));
    % config.true_pos5 = true_pos_p5;
    % true_pos_p6 = struct('name', "P6", 'lat', test_point_1_lat(6), 'lon', test_point_1_lon(6));
    % config.true_pos6 = true_pos_p6;
    true_pos_index = 6;
    config.cur_true_pos = struct('name', test_point_1_name{true_pos_index}, ...
        'lat', test_point_1_lat(true_pos_index), 'lon', test_point_1_lon(true_pos_index));

    %% 定位误差结果统计
    % 静态统计误差图片路径
    config.save_position_error_statistics_pic = true;
    config.position_error_statistics_pic = ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-p6-1.png';
    % 原始数据文件路径
    config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6_3米\', ...
                                'P6-added_lat_lon.txt'];
end
