function verify_midian_filter_and_model()
    % file_name = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\ch39-1m.txt';
    file_name = ['D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\', ...
                'ch39-18m', '.txt'];
    rssi_time_ch39_1 = get_std_rssi_data_with_time_stamp('filepath', file_name);
    scope_size = 21;
    distance_f = zeros(0); % 滤波距离

    for k1 = 1:length(rssi_time_ch39_1)

        if ~isempty(rssi_time_ch39_1{k1, 2})
            rssi_time_ch39_1{k1, 2} = mean(rssi_time_ch39_1{k1, 2});
        else
            rssi_time_ch39_1{k1, 2} = 0;
        end

    end

    for k2 = 1:length(rssi_time_ch39_1)

        if k2 <= scope_size
            rssi_array = cell2mat(rssi_time_ch39_1(1:k2, 2));
            rssi = mean(rssi_array(rssi_array ~= 0));
        else
            rssi_array = cell2mat(rssi_time_ch39_1(k2 - scope_size:k2, 2));
            rssi_array = rssi_array(rssi_array ~= 0);
            rssi = sort(rssi_array);
            rssi = rssi(round(scope_size / 2));
        end

        % a = -0.01163;
        % b = -1.707;
        % c = -44.94;
        % dist = rssi_to_distance_quadratic_polynomial(a, b, c, rssi);
        A = -9.13;
        b = 3.792;
        dist = rssi_to_distance_logarithmic(A, b, rssi);
        distance_f(k2) = dist;
        rssi_time_ch39_1{k2, 3} = dist;
    end

    x_data = cell2mat(rssi_time_ch39_1(:, 1));
    y2_data = cell2mat(rssi_time_ch39_1(:, 2));
    y3_data = cell2mat(rssi_time_ch39_1(:, 3));
    tcf('naln');
    figure('name', 'naln', 'color', 'w');
    subplot(211)
    plot(x_data, y2_data)
    subplot(212)
    plot(x_data, y3_data)

end
