function ap_select = prev_dbscan_ap_selector(cur_ap,...
                                             prev_ap,...
                                             param)
%���ܣ�DBSCAN���෨��apѡ����
%���壺ap_select = prev_dbscan_ap_selector(cur_ap,...
%                                          prev_ap,...
%                                          param)
%������ 
%    cur_ap����ǰ�������ap���ݣ����㷨ʹ��ÿ��ap�еľ�γ����Ϣ��
%    prev_ap����һ֡ap���ݣ�����Ϊ��ʱ��ʾû����һ֡���ݣ�
%    param��ѡ��������,��������
%           param.radius_calc.radius_max�����ĵ�����뾶���ֵ
%           param.dbscan.min_points�����ĵ�����뾶�ڵ�����Сֵ
%�����
%    ap_select��ѡ�����ap

    ap_select = [];
    if isempty(cur_ap)
        return;
    end

    radius_calc_param = param.radius_calc;
    dbscan_param = param.dbscan;
    
    %% ����DBSCAN���������뾶
    radius = prev_dbscan_radius_calc(cur_ap, radius_calc_param);

    %% DBSCAN����
    dbscan_param.radius = radius;
    cluster_res = prev_dbscan(cur_ap, dbscan_param);
    
    %% ���ݾ���������������ĸ������ap���ݣ���������Ե���Ϊһ�ࣩ
    ap_class_num = 0;
    
    %����������㣨��������Ϊ0�ĵ㣩���ڵĸ�������������ap
    class_name = unique(cluster_res);
    not_noise_class_name = class_name(class_name ~= 0);
    for i = 1:length(not_noise_class_name)
        ap_class_num = ap_class_num + 1;
        ap_class(ap_class_num).ap_idx = find(cluster_res == not_noise_class_name(i));
    end
    
    %����������(������Ϊ0�ĵ�)���Ե�����Ϊһ��
    noise_class_idx = find(cluster_res == 0);
    
    for i = 1:length(noise_class_idx)
        ap_class_num = ap_class_num + 1;
        ap_class(ap_class_num).ap_idx = noise_class_idx(i);
    end
    
    %���������ap��ap����������ƽ��ֵ��γ��ƽ��ֵ��rssiƽ��ֵ(ͬʱ��¼ap������
    %rssi��ֵ�����࣬���ں���ѡ��)
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
    
    %% ��ȡ���ŵ�һ��AP,��ȡ������
      % 1�������ap���������ap��������1�������������ap��������һ��
      % 2��������е�ap���嶼ֻ����1��ap:
      %    �������ʷ���ݣ���ѡ������������һ�����������һ��
      %    ���û����ʷ���ݣ���ѡ��rssi��ֵ����һ��
    if max_ap_num > 1 
        %����ap��������һ���࣬ѡ�������ap��������һ��
        ap_select = cur_ap(max_ap_class.ap_idx);
    else
        %���е�ap���嶼ֻ����1��ap
        if isempty(prev_ap)
            %û����ʷ���ݣ�ѡ��rssi��ֵ����һ��
            ap_select = cur_ap(max_rssi_mean_ap_class.ap_idx);
        else
            %����ʷ���ݣ�ѡ������������һ�����������һ��
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