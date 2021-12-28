%% 模拟现有定位算法，分析其动静态条件下的RSSI统计特征变化情况。
%{
    数据源：D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\Beacon6-4m.txt
    数据源：D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\Beacon6-10m.txt
%}
% 帧间隔
clc;
file_4m = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\Beacon\Beacon6-4m.txt';
file_10m = 'C:\Users\W-H\Desktop\Beacon6-10m.txt';
frame_gap = 10;
[data, frame_num_total] = blu_data_file_parsing(file_10m);
mean_values = zeros(0);
std_values = zeros(0);
std_4m = 8.47;
std_10m = 2.48;
% main loop
for k = frame_gap:1:frame_num_total
    rssis_temp = zeros(0);

    for j = k - frame_gap + 1:k
        cur_frame = data{j};

        if ~isempty(cur_frame)

            for j_1 = 1:length(cur_frame.ap_msg)
                rssis_temp(length(rssis_temp) + 1) = cur_frame.ap_msg(j_1).rssi;
            end

        end

    end

    mean_values(length(mean_values) + 1) = mean(rssis_temp);
    std_values(length(std_values) + 1) = std(rssis_temp);

end

show_figure(std_values, std_4m, std_10m, frame_gap);

function show_figure(data, std_value_1, std_value_2, frame_gap)
    fprintf('show a figure\n');
    tcf('stdfig');
    figure('name', 'stdfig', 'color', 'w');
    hold on
    plot(data, 'LineWidth', 1.5);
    plot([1, length(data)], [std_value_1, std_value_1], 'LineWidth', 1.5);
    plot([1, length(data)], [std_value_2, std_value_2], 'LineWidth', 1.5);
    % plot()
    legend('std gap ', 'std all data upper', 'std all data lower')
    set(get(gca, 'XLabel'), 'String', 'serial/n');
    set(get(gca, 'YLabel'), 'String', 'RSSI/dBm');
    title(sprintf('local statistical character & global statistical character(frame gap:%d)', frame_gap));
    hold off
    lower_cof = length(data(data <= std_value_2)) / length(data);
    fprintf('error ratio:%% %0.2f\n', lower_cof*100);
end
