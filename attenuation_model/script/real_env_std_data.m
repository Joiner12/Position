%% 实际测试对数模型点位
%{
测试说明：
1.测试台(ap)高度约:140cm;
2.定位点(anchor)高度约:230cm;
3.真实距离换算需要考虑高度差;
%}
% 以ope1为参考坐标[0,0]
clc; disp('mark real env test points');
beacon = hlk_beacon_location();
x = zeros(0);
y = zeros(0);
name = cell(0);
lat = zeros(0);
lon = zeros(0);

for k = 1:1:length(beacon)
    x(k) = beacon(k).x;
    y(k) = beacon(k).y;
    lat(k) = beacon(k).lat;
    lon(k) = beacon(k).lon;
    name{k} = beacon(k).name;
end

ope_0 = [x(1) - min(x), y(1) - min(y)];
ope_1 = [x(2) - min(x), y(2) - min(y)];
ope_6 = [x(3) - min(x), y(3) - min(y)];
ope_7 = [x(4) - min(x), y(4) - min(y)];
ope_8 = [x(5) - min(x), y(5) - min(y)];
ope_9 = [x(6) - min(x), y(6) - min(y)];

anchor_height = 2.3; % m
ap_height = 1.4; % m
mid_dist = 3.8; % m
L0 = [0.1, mid_dist];
L1 = [1, mid_dist];
L2 = [2, mid_dist];
L3 = [3, mid_dist];
L4 = [4, mid_dist];
L5 = [5, mid_dist];
L6 = [6, mid_dist];
L7 = [7, mid_dist];
L8 = [8, mid_dist];
L9 = [9, mid_dist];
L10 = [10, mid_dist];
L12 = [12, mid_dist];
L13 = [13, mid_dist];
L14 = [14, mid_dist];
L_names = cell(0);
anchor_points = [L0; L1; L2; L3; L4; L5; L6; L7; L8; L9; L10; L12; L13; L14];
ap_points = [ope_0; ope_1; ope_6; ope_7; ope_8; ope_9];
ap_points_s = struct();
anchor_points_s = struct();
counter = 0;

for k = 0:length(anchor_points)

    if isequal(k, 11)
        continue;
    end

    counter = counter + 1;
    L_names{counter} = strcat('L', num2str(k));
    anchor_points_s(counter).name = strcat('L', num2str(k));
    anchor_points_s(counter).xy = anchor_points(counter, :);
end

for k = 1:6
    ap_points_s(k).name = name{k};
    ap_points_s(k).xy = ap_points(k, :);

end

joint_lines = struct(); % 连接线
joint_lines_t = table(); % 连接线表

for i = 1:length(anchor_points_s)

    for j = 1:length(ap_points_s)
        ap_p_s_len = length(ap_points_s);
        joint_lines((i - 1) * ap_p_s_len + j).header = anchor_points_s(i).name;
        joint_lines((i - 1) * ap_p_s_len + j).tail = ap_points_s(j).name;
        joint_lines((i - 1) * ap_p_s_len + j).x1y1 = ap_points_s(j).xy;
        joint_lines((i - 1) * ap_p_s_len + j).x2y2 = anchor_points_s(i).xy;
        %
        joint_lines((i - 1) * ap_p_s_len + j).len = norm(norm(ap_points_s(j).xy - anchor_points_s(i).xy), 0.9);
        joint_lines((i - 1) * ap_p_s_len + j).label = num2str(joint_lines((i - 1) * ap_p_s_len + j).len, '%.2f');
    end

end

%% Extract standard data
clc; disp('extract standard data');
joints_len = length(joint_lines);

for k = 1:joints_len
    file_selector = joint_lines(k).header;
    ap_filter = joint_lines(k).tail;
    data_file = strcat('../data/7x7标准数据测试-1/', strrep(file_selector, 'L', ''));
    data_file = strcat(data_file, 'm-00cm.txt');
    rssi_temp = get_rssi_info(data_file, ap_filter);
    joint_lines(k).RSSI = rssi_temp;
    joint_lines(k).rssi_mean_val = mean(rssi_temp);
    joint_lines(k).rssi_std_val = std(rssi_temp);
    joint_lines(k).rssi_median_val = median(rssi_temp);
    disp([data_file, ap_filter]);
end

joint_lines_t = struct2table(joint_lines);
%% data post processing - distance:rssi by anchor name
clc; disp('data post processing');
std_ope_0 = joint_lines_t(joint_lines_t.tail == "ope_0", :);
std_ope_1 = joint_lines_t(joint_lines_t.tail == "ope_1", :);
std_ope_6 = joint_lines_t(joint_lines_t.tail == "ope_6", :);
std_ope_7 = joint_lines_t(joint_lines_t.tail == "ope_7", :);
std_ope_8 = joint_lines_t(joint_lines_t.tail == "ope_8", :);
std_ope_9 = joint_lines_t(joint_lines_t.tail == "ope_9", :);
% resort data by real distance
std_ope_0_r_t = resort_table(std_ope_0);
std_ope_1_r_t = resort_table(std_ope_1);
std_ope_6_r_t = resort_table(std_ope_6);
std_ope_7_r_t = resort_table(std_ope_7);
std_ope_8_r_t = resort_table(std_ope_8);
std_ope_9_r_t = resort_table(std_ope_9);

%% 标准RSSI-DIST数据
clc; disp('标准数据');
std_ope_0_r = resort_dist_rssi(std_ope_0);
std_ope_1_r = resort_dist_rssi(std_ope_1);
std_ope_6_r = resort_dist_rssi(std_ope_6);
std_ope_7_r = resort_dist_rssi(std_ope_7);
std_ope_8_r = resort_dist_rssi(std_ope_8);
std_ope_9_r = resort_dist_rssi(std_ope_9);

%% 将所有bs dist-rssi合成一组数据,作为一个模型进行处理
% table_cat = table()
dist_all = [...
            reshape(std_ope_0_r.dist, [length(std_ope_0_r.dist), 1]); ...
            reshape(std_ope_1_r.dist, [length(std_ope_1_r.dist), 1]); ...
            reshape(std_ope_6_r.dist, [length(std_ope_6_r.dist), 1]); ...
            reshape(std_ope_7_r.dist, [length(std_ope_7_r.dist), 1]); ...
            reshape(std_ope_8_r.dist, [length(std_ope_8_r.dist), 1]); ...
            reshape(std_ope_9_r.dist, [length(std_ope_9_r.dist), 1]); ...
            ];
rssi_all = [...
            reshape(std_ope_0_r.rssi, [length(std_ope_0_r.rssi), 1]); ...
            reshape(std_ope_1_r.rssi, [length(std_ope_1_r.rssi), 1]); ...
            reshape(std_ope_6_r.rssi, [length(std_ope_6_r.rssi), 1]); ...
            reshape(std_ope_7_r.rssi, [length(std_ope_7_r.rssi), 1]); ...
            reshape(std_ope_8_r.rssi, [length(std_ope_8_r.rssi), 1]); ...
            reshape(std_ope_9_r.rssi, [length(std_ope_9_r.rssi), 1]); ...
            ];
dist_rssi_all_t = table();
dist_rssi_all_t.rssi_mean_val = rssi_all;
dist_rssi_all_t.len = dist_all;
dist_rssi_all_t_r = resort_dist_rssi(dist_rssi_all_t);

%% 获取单个anchor node rssi 统计信息
std_ope_0_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_0_r_t);
std_ope_1_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_1_r_t);
std_ope_6_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_6_r_t);
std_ope_7_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_7_r_t);
std_ope_8_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_8_r_t);
std_ope_9_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_9_r_t);
%% figure #1 绘制access node 和 anchor nodes测试示意图
if false
    tcf('hs-2');
    figure('name', 'hs-2', 'color', 'w');
    hold on
    plot(x - min(x), y - min(y), '*')
    text(x - min(x), y - min(y), name)
    scatter(anchor_points(:, 1), anchor_points(:, 2), ...
        [], linspace(10, 100, length(anchor_points)), 'filled');
    text(anchor_points(:, 1), anchor_points(:, 2), L_names);

    for j = 1:length(joint_lines)
        line([joint_lines(j).x1y1(1), joint_lines(j).x2y2(1)], ...
            [joint_lines(j).x1y1(2), joint_lines(j).x2y2(2)], 'color', rand(1, 3));
        text(mean([joint_lines(j).x1y1(1), joint_lines(j).x2y2(1)]), ...
            mean([joint_lines(j).x1y1(2), joint_lines(j).x2y2(2)]), joint_lines(j).label);
    end

    grid minor
    box on
end

%% figure #2 show rssi features
if false
    clc;
    cur_ope = std_ope_0;
    figure_name = 'ope_0_rssi';
    tcf(figure_name);
    f1 = figure('name', figure_name, 'color', 'white', 'Position', [302, 217, 1216, 683]);
    line_marker = ['o', '+', '*', 'x', 's', 'd', '<', '>', 'p', 'h'];

    for k = 1:size(cur_ope, 1)
        subplot(4, 4, k)
        plot(cell2mat(cur_ope.RSSI(k)), 'color', [43, 207, 49] ./ 255, ...
            'Marker', line_marker(randi([1, 10])), 'LineStyle', '-');
        title(cur_ope.header(k))
    end

    subplot(4, 4, size(f1.Children, 1) + 1);
    plot(cur_ope.rssi_mean_val)
    title('trend')
    subplot(4, 4, size(f1.Children, 1) + 1);
    temp = regexp(figure_name, '\d', 'match');
    text(0, 1, ['ope', temp{1}], ...
        'FontSize', 20, 'Color', 'red');
    xlim([0, 2])
    ylim([0, 2])
end

%% 真实环境下不同信标RSSI-DIST对比图
if false
    tcf('std-dist-1'); figure('name', 'std-dist-1', 'color', 'white');
    hold on
    plot(std_ope_0_r.dist, std_ope_0_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    plot(std_ope_1_r.dist, std_ope_1_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    plot(std_ope_6_r.dist, std_ope_6_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    plot(std_ope_7_r.dist, std_ope_7_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    plot(std_ope_8_r.dist, std_ope_8_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    plot(std_ope_9_r.dist, std_ope_9_r.rssi, 'Marker', line_marker(randi([1, 10])), 'LineWidth', 1.6)
    legend('0', '1', '6', '7', '8', '9')
    title('真实环境下不同信标RSSI-DIST对比图')
    xlabel('dist/m')
    ylabel('rssi/dbm')
    box on
end

%% spcrv
if false
    tcf('std-dist-2'); figure('name', 'std-dist-2', 'color', 'white');
    x_1 = std_ope_9_r.dist';
    y_1 = std_ope_9_r.rssi';
    values = spcrv([[x_1(1) x_1 x_1(end)]; [y_1(1) y_1 y_1(end)]], 3);
    plot(values(1, :), values(2, :), 'g');
    hold on
    plot(x_1, y_1, 'LineStyle', 'None', 'Marker', '*')
end

%% spcrv
if false
    tcf('std-dist-3'); figure('name', 'std-dist-3', 'color', 'white');
    x_1 = (dist_rssi_all_t_r.dist)';
    y_1 = (dist_rssi_all_t_r.rssi)';
    values = spcrv([[x_1(1) x_1 x_1(end)]; [y_1(1) y_1 y_1(end)]], 2);
    plot(values(1, :), values(2, :), 'r');
    hold on
    plot(x_1, y_1, 'LineStyle', 'None', 'Marker', '*')
end

%% 分析ope_x统计特征
if true
    tcf('rssi-statistic'); figure('name', 'rssi-statistic', 'color', 'white')
    temp = std_ope_0_r_t_s.rssi_statistics;
    %legs = {std_ope_0_r_t_s.label(7, :), std_ope_0_r_t_s.label(12, :)};
    legs = {'7','12'};
    index_s = [7, 12];
    subplot(311)
    hold on

    for k = 1:2
        %  median_vals: [1×590 double]k
        plot(temp(index_s(k)).mean_vals);
    end

    title('mean')
    legend(legs)

    subplot(312)
    hold on
    % for k = 1:size(std_ope_0_r_t_s, 1)
    for k = 1:2
        %  median_vals: [1×590 double]
        plot(temp(index_s(k)).std_vals);
    end

    title('std')
    legend(legs)

    subplot(313)
    hold on

    for k = 1:2
        plot(temp(index_s(k)).median_vals);
    end

    title('median')
    legend(legs)
end

%%
function dist_rssi = resort_dist_rssi(org_data)
    dist_rssi = table();
    mean_val_temp = org_data.rssi_mean_val;
    len_temp = org_data.len;
    len_temp_s = sort(len_temp);

    for k = 1:length(len_temp_s)
        dist_rssi.dist(k) = len_temp_s(k);
        dist_rssi.rssi(k) = mean_val_temp(len_temp == len_temp_s(k));
    end

end

%% 根据距离重新排序table
function table_out = resort_table(table_in)
    table_out = table_in;
    len_temp = table_in.len;
    len_temp = sort(len_temp);

    for k = 1:length(len_temp)
        index = find(table_in.len == len_temp(k));
        table_out(k, :) = table_in(index, :);
    end

end

%% 单个anchor node 统计特征变化情况
function std_ope_X_r_t_s = get_single_anchor_node_rssi_statistics(std_ope_X_r_t)
    std_ope_X_r_t_s = std_ope_X_r_t;

    for j = 1:size(std_ope_X_r_t.RSSI, 1)
        ope_X_rssi = std_ope_X_r_t.RSSI(j, :);
        ope_X_rssi = cell2mat(ope_X_rssi);
        ope_X_rssi_statistics = struct(...
            'scope', 10, 'mean_vals', [], ...
            'std_vals', [], 'median_vals', []);

        for k = 1:length(ope_X_rssi)

            if k < ope_X_rssi_statistics.scope
                rssi_temp = ope_X_rssi(1:k);
            else
                rssi_temp = ope_X_rssi(k - ope_X_rssi_statistics.scope + 1:k);
            end

            ope_X_rssi_statistics.mean_vals = [ope_X_rssi_statistics.mean_vals, mean(rssi_temp)];
            ope_X_rssi_statistics.std_vals = [ope_X_rssi_statistics.std_vals, std(rssi_temp)];
            ope_X_rssi_statistics.median_vals = [ope_X_rssi_statistics.median_vals, median(rssi_temp)];
        end

        std_ope_X_r_t_s.rssi_statistics(j, :) = ope_X_rssi_statistics;
    end

end
