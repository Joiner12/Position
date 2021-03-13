function config = sys_config()
%功能：系统参数配置，设置各个构件所需的参数
%定义：config = sys_config()
%参数： 
%
%输出：
%    config：配置的参数

    same_ap_judge_type = 'addr';

    %% 整合相同的ap数据
    %相同ap的判断方式
    config.integrate_same_ap_param.same_ap_judge_type = same_ap_judge_type;

    %% rssi拟合
    config.rssi_fit_type = 'scope_mean';               %拟合方式
    config.rssi_fit_param.scope_mean.rssi_range = 10;  %允许的rssi范围最大值
    config.rssi_fit_param.scope_mean.ratio_thr = 0.75; %不可过滤的比例阈值(0~1)

    %% rssi滤波
    config.rssi_filter_param.moving_average_len = 5;   %加权平滑滤波长度
    config.rssi_filter_param.gauss_filter_len = 20;    %高斯滤波长度
    config.rssi_filter_param.gauss_probability = 0.6;  %高斯滤波校正阈值
    config.rssi_filter_param.ap_buffer_valid_frame_num = 10;          %缓存ap的有效上限
    config.rssi_filter_param.same_ap_judge_type = same_ap_judge_type; %相同ap的判断方式
    
    %% dbscan聚类法的ap选择器
    config.dbscan_selector_param.radius_calc.radius_max = 5000; %核心点邻域半径最大值
    config.dbscan_selector_param.dbscan.min_points = 0;         %核心点邻域半径内点数最小值
    
    %% 计算离各个ap的距离
    config.dist_calc_type = 'logarithmic';  %距离计算的模式
    
    %经典距离对数模型：信号传播参考距离d0(d0=1m)后产生的路径损耗,即d0处rssi
%     config.dist_calc_param.logarithmic.rssi_reference = -10.61; 
    %经典距离对数模型：路径损耗系数,一般取2~3之间
%     config.dist_calc_param.logarithmic.loss_coef = -1.327; 
    config.dist_calc_param.logarithmic.loss_coef = -1.886; 
    
    %距离高斯模型：高斯模型参数a
    config.dist_calc_param.gauss.a = 177.5; 
    %距离高斯模型：高斯模型参数b
    config.dist_calc_param.gauss.b = -103;     
    %距离高斯模型：高斯模型参数b
    config.dist_calc_param.gauss.c = 24.28;  
    
    %高斯对数模型：高斯模型计算的rssi阈值
    config.dist_calc_param.gausslog.rssi_thr = -100;  
    
    %% 距离三角补偿
    config.dist_triangle_compensate_meter = 2; %三角补偿的距离(单位：米)
    
    %% NewtonGaussLS 高斯牛顿迭代最小二乘算法（加权质心结果为初始点）
    config.newtongaussls_param.iterative_num_max = 10;
    
    %% 范围滤波
    config.scope_filter_param.lat_max = 60;   %纬度最大值
    config.scope_filter_param.lat_min = 10;   %纬度最小值
    config.scope_filter_param.lon_max = 200;  %经度最大值
    config.scope_filter_param.lon_min = 100;  %经度最小值
    
    %% 跳点平滑滤波
    config.jump_smooth_filter_param.fit_dist_thr_max = 30;   %坐标需拟合的最大距离门限(米)
    config.jump_smooth_filter_param.fit_dist_thr_min = 10;   %坐标需拟合的最小距离门限(米)
    config.jump_smooth_filter_param.jump_num = 0;            %连续跳点的次数
    config.jump_smooth_filter_param.jump_num_max = 20;       %允许的连续跳点的次数上限
    config.jump_smooth_filter_param.smooth_len = 5;          %平滑长度
    
    %% 通用参数
    %历史数据有效的帧数上限
    config.history_valid_frame_num = config.jump_smooth_filter_param.jump_num_max;      
end