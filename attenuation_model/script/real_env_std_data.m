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

%% Extract standard data
clc; disp('extract standard data');
joints_len = length(joint_lines);

for k = 1:joints_len
    file_selector = joint_lines(k).header;
    ap_filter = joint_lines(k).tail;
    data_file = strcat('../data/7x7标准数据测试/', strrep(file_selector, 'L', ''));
    data_file = strcat(data_file, 'm-00cm.txt');
    rssi_temp = get_rssi_info(data_file, ap_filter);
    joint_lines(k).RSSI = rssi_temp;
    joint_lines(k).rssi_mean_val = mean(rssi_temp);
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

%% figure-show rssi features
clc;
cur_ope = std_ope_9;
figure_name = 'ope_9_rssi';
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
