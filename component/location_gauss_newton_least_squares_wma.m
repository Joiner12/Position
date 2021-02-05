function pos_res = location_gauss_newton_least_squares_wma(ap, param)
%���ܣ���˹ţ�ٵ�����С�����㷨����Ȩ���Ľ��Ϊ��ʼ�㣩
%���壺pos_res = location_gauss_newton_least_squares_wma(ap, param)
%������ 
%    ap�����˲���ap����
%    param����������,��������
%           param.iterative_num_max��������������
%�����
%    pos_res�������λ�ý��������Ϊ�ṹ�壬����Ԫ�����£�
%             pos_res.lat��γ��
%             pos_res.lon������

    %% ��ȡap����
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
        %% ��ʼ������
        %�����Ȩ����
        tmp = 1 ./ rssi_kf.^2;
        weight = sum(tmp);
        centroid_x = sum(x .* tmp) / weight;
        centroid_y = sum(y .* tmp) / weight;
        
        %�Լ�Ȩ����Ϊ��ʼ��
        init_pos.x = centroid_x;
        init_pos.y = centroid_y;
        centre_pos = init_pos;

        %���������ƽ������
        measure_mean_dist = mean(dist); 

        %�������������ĵ�ƽ������
        centre_mean_dist = mean(sqrt((x - centroid_x).^2 + (y - centroid_y).^2));

        %��������
        delta_dist = abs(measure_mean_dist - centre_mean_dist);

        %���ݾ��������������
        iterative_thr = 10^(floor(log10(delta_dist)));

        %Ȩϵ������ 
        weigth_coef = diag(10.^floor((rssi_kf + 20) ./ 10)...
                      .* (1111 / 111 - iterative_thr / 111));

        %% ��ʼ����
        for iteration = 1:iterative_num_max
            matrix_a = zeros(ap_num, 2);
            matrix_b = zeros(ap_num, 1);
            to_init_pos_dist = zeros(ap_num, 1);

            %������㵽��ʼ��ľ���
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
                %���С������ֹͣ����
                break;
            elseif abs(error) > iterative_thr * 10
                %������10�����ޣ���Ϊ��ɢ��ʹ������λ��
                type3_w = centre_pos;
            else
                %��������
                init_pos = type3_w;
            end
        end

        %��ǰ�㷨��֧�ֿ�ʱ��
        [pos_res.lat, pos_res.lon] = xy_to_latlon(type3_w.x, type3_w.y, lom(end));
    elseif ap_num == 0
        [pos_res.lat, pos_res.lon] = xy_to_latlon(x(1), y(1), lom(1));
    else
        pos_res = [];
    end
end