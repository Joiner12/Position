function pos_res = location_gauss_newton_least_squares_wma(ap, param)
%功能：高斯牛顿迭代最小二乘算法（加权质心结果为初始点）
%定义：pos_res = location_gauss_newton_least_squares_wma(ap, param)
%参数： 
%    ap：待滤波的ap数据
%    param：函数参数,具体如下
%           param.iterative_num_max：迭代次数上限
%输出：
%    pos_res：计算的位置结果，数据为结构体，包含元素如下：
%             pos_res.lat：纬度
%             pos_res.lon：经度

    %% 提取ap数据
    ap_num = length(ap);
    rssi_kf = zeros(ap_num, 1);
    dist = zeros(ap_num, 1);
    x = zeros(ap_num, 1);
    y = zeros(ap_num, 1);
    lom = zeros(ap_num, 1);
    iterative_num_max = param.iterative_num_max;
   
    for i = 1:ap_num
        rssi_kf(i) = ap(i).rssi_kf;
        dist(i) = ap(i).dist;
        [x(i), y(i), lom(i)] = latlon_to_xy(ap(i).lat, ap(i).lon);
    end
    
    if ap_num > 1
        %% 初始化迭代
        %计算加权质心
        tmp = 1 ./ rssi_kf.^2;
        weight = sum(tmp);
        centroid_x = sum(x .* tmp) / weight;
        centroid_y = sum(y .* tmp) / weight;
        
        %以加权质心为初始点
        init_pos.x = centroid_x;
        init_pos.y = centroid_y;
        centre_pos = init_pos;

        %计算测量的平均距离
        measure_mean_dist = mean(dist); 

        %计算各点距离质心的平均距离
        centre_mean_dist = mean(sqrt((x - centroid_x).^2 + (y - centroid_y).^2));

        %计算距离差
        delta_dist = abs(measure_mean_dist - centre_mean_dist);

        %根据距离差计算迭代门限
        iterative_thr = 10^(floor(log10(delta_dist)));

        %权系数计算 
        weigth_coef = diag(10.^floor((rssi_kf + 20) ./ 10)...
                      .* (1111 / 111 - iterative_thr / 111));

        %% 开始迭代
        for iteration = 1:iterative_num_max
            matrix_a = zeros(ap_num, 2);
            matrix_b = zeros(ap_num, 1);
            to_init_pos_dist = zeros(ap_num, 1);

            %计算各点到初始点的距离
            to_init_pos_dist(:, 1) = sqrt((x - init_pos.x).^2 + (y - init_pos.y).^2);

            matrix_a(:, 1) = -(x - init_pos.x) ./ to_init_pos_dist;
            matrix_a(:, 2) = -(y - init_pos.y) ./ to_init_pos_dist;
            matrix_b(:, 1) = dist - to_init_pos_dist;

            delta_xy = inv(matrix_a' * weigth_coef * matrix_a) ...
                       * matrix_a' * weigth_coef * matrix_b;

            type3_w.x = init_pos.x + delta_xy(1);
            type3_w.y = init_pos.y + delta_xy(2);

            error = sum(matrix_b);

            if abs(error) < iterative_thr
                %误差小于门限停止迭代
                break;
            elseif abs(error) > iterative_thr * 10
                %误差大于10倍门限，认为发散，使用质心位置
                type3_w = centre_pos;
            else
                %正常迭代
                init_pos = type3_w;
            end
        end

        %当前算法不支持跨时域
        [pos_res.lat, pos_res.lon] = xy_to_latlon(type3_w.x, type3_w.y, lom(end));
    elseif ap_num == 0
        [pos_res.lat, pos_res.lon] = xy_to_latlon(x(1), y(1), lom(1));
    else
        pos_res = [];
    end
end