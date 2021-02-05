function radius = prev_dbscan_radius_calc(ap, param)
%功能：计算DBSCAN聚类的邻域半径
%定义：radius = prev_dbscan_radius_calc(ap, param)
%参数： 
%    ap：ap数据（本算法使用每个ap中的经纬度信息）
%    param：函数参数,具体如下
%           param.radius_max：邻域半径最大值
%输出：
%    radius：计算得到的DBSCAN聚类的邻域半径

    ap_num = length(ap);
    dist_buffer_num = 0;
    dist_buffer = [];
    radius_max = param.radius_max;

    %计算个点间距离，保存小于radius_max的距离
    for i = 1:ap_num
        for j = (i + 1):ap_num
            dist = utm_distance(ap(i).lat, ap(i).lon, ap(j).lat, ap(j).lon);
            
            if dist < radius_max
                dist_buffer_num = dist_buffer_num + 1;
                dist_buffer(dist_buffer_num) = dist;
            end
        end
    end
    
    %计算邻域半径
    if isempty(dist_buffer) 
        %各点间距离都大于等于radius_max，邻域半径取radius_max
        radius = radius_max; 
    else
        radius = mean(dist_buffer) + 100;
    end
end 
    