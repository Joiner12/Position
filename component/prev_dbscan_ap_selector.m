function ap_select = prev_dbscan_ap_selector(cur_ap,...
                                             prev_ap,...
                                             param)
%功能：DBSCAN聚类法的ap选择器
%定义：ap_select = prev_dbscan_ap_selector(cur_ap,...
%                                          prev_ap,...
%                                          param)
%参数： 
%    cur_ap：当前待处理的ap数据（本算法使用每个ap中的经纬度信息）
%    prev_ap：上一帧ap数据（输入为空时表示没有上一帧数据）
%    param：选择器参数,具体如下
%           param.radius_calc.radius_max：核心点邻域半径最大值
%           param.dbscan.min_points：核心点邻域半径内点数最小值
%输出：
%    ap_select：选择出的ap

    ap_select = [];
    if isempty(cur_ap)
        return;
    end

    radius_calc_param = param.radius_calc;
    dbscan_param = param.dbscan;
    
    %% 计算DBSCAN聚类的邻域半径
    radius = prev_dbscan_radius_calc(cur_ap, radius_calc_param);

    %% DBSCAN聚类
    dbscan_param.radius = radius;
    cluster_res = prev_dbscan(cur_ap, dbscan_param);
    
    %% 依据聚类结果，整理聚类后的各个类的ap数据（噪声点各自单独为一类）
    ap_class_num = 0;
    
    %整理非噪声点（聚类结果不为0的点）所在的各个类所包含的ap
    class_name = unique(cluster_res);
    not_noise_class_name = class_name(class_name ~= 0);
    for i = 1:length(not_noise_class_name)
        ap_class_num = ap_class_num + 1;
        ap_class(ap_class_num).ap_idx = find(cluster_res == not_noise_class_name(i));
    end
    
    %各个噪声点(聚类结果为0的点)各自单独归为一类
    noise_class_idx = find(cluster_res == 0);
    
    for i = 1:length(noise_class_idx)
        ap_class_num = ap_class_num + 1;
        ap_class(ap_class_num).ap_idx = noise_class_idx(i);
    end
    
    %计算各类中ap的ap个数、经度平均值、纬度平均值、rssi平均值(同时记录ap个数及
    %rssi均值最大的类，用于后续选择)
    max_ap_num = 0;
    max_ap_class = [];
    max_rssi_mean = -10000;
    max_rssi_mean_ap_class = [];
    for i = 1:ap_class_num
        ap_idx = ap_class(i).ap_idx;
        ap_num = length(ap_idx);
        lat(1:ap_num) = cur_ap(ap_idx).lat;
        lon(1:ap_num) = cur_ap(ap_idx).lon;
        rssi(1:ap_num) = cur_ap(ap_idx).rssi;
        
        lat_mean = mean(lat);
        lon_mean = mean(lon);
        rssi_mean = mean(rssi);
        
        ap_class(i).ap_num = ap_num;
        ap_class(i).lat_mean = lat_mean;
        ap_class(i).lon_mean = lon_mean;
        ap_class(i).rssi_mean = rssi_mean;
        
        if max_ap_num < ap_num
            max_ap_num = ap_num;
            max_ap_class = ap_class(i);
        end
        
        if max_rssi_mean < rssi_mean
            max_rssi_mean = rssi_mean;
            max_rssi_mean_ap_class = ap_class(i);
        end 
    end
    
    %% 获取最优的一类AP,获取方法：
      % 1）如果有ap类族包含的ap个数大于1，就先择包含的ap个数最多的一类
      % 2）如果所有的ap类族都只包含1个ap:
      %    如果有历史数据，则选择其质心离上一次质心最近的一组
      %    如果没有历史数据，则选择rssi均值最大的一组
    if max_ap_num > 1 
        %存在ap个数大于一的类，选择包含的ap个数最多的一组
        ap_select = cur_ap(max_ap_class.ap_idx);
    else
        %所有的ap类族都只包含1个ap
        if isempty(prev_ap)
            %没有历史数据，选择rssi均值最大的一组
            ap_select = cur_ap(max_rssi_mean_ap_class.ap_idx);
        else
            %有历史数据，选择其质心离上一次质心最近的一组
            dist = zeros(1, ap_class_num);

            prev_lat = zeros(length(prev_ap), 1);
            prev_lon = zeros(length(prev_ap), 1);
            prev_lat(:) = prev_ap(:).lat;
            prev_lon(:) = prev_ap(:).lon;
            pre_lat_center = mean(prev_lat);
            pre_lon_center = mean(prev_lon);
              
            for i = 1:ap_class_num
                dist(i) = utm_distance(pre_lat_center, pre_lon_center,...
                               ap_class(i).lat_mean, ap_class(i).lon_mean);
            end
                
            [dist_min, dist_min_idx] = min(dist);
                
            ap_select = cur_ap(ap_class(dist_min_idx).ap_idx);
        end
    end
end