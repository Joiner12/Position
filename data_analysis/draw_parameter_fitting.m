function draw_parameter_fitting(distance,rssi,fig_info,varargin)
% 函数功能:
%     绘制对数距离路径损耗模型及分析结果
% 函数参数:
%     dist:距离(array)
%     rssi:距离对应rssi(cell)
%     fig_info:图像信息(char)
%     varargin:保留参数
% 函数输出:
%     None

%% 输入参数检查
if (~isnumeric(distance) || ~iscell(rssi) ...
        || ~(ischar(fig_info)))
    error("数据类型错误");
end
disp('绘制参数拟合分析图')
%% 初始化变量
% rssi = ap_rssi{i};
% dist = ap_dist{i};
len = length(distance);

rssi_mean = zeros(1, len);
rssi_max = zeros(1, len);
rssi_min = zeros(1, len);

% 计算各距离中各帧rssi的均值及最大最小值
for j = 1:len
    rssi_mean(j) = mean(rssi{j});
    rssi_max(j) = max(rssi{j});
    rssi_min(j) = min(rssi{j});
end

%% 计算各个距离的参数结果
rssi_reference = rssi_mean(1);
loss_coef = zeros(1, len);
for j = 2:len
    loss_coef(j) = abs(rssi_mean(j) - rssi_reference) / ...
        (10 * log10(distance(j)));
end

if len >= 2
    loss_coef(1) = loss_coef(2);
else
    loss_coef(1) = 0;
end

[log_dist_max,log_dist_min ...
    ,log_dist_mean,log_dist_max_mean ...
    ,log_dist_min_mean,log_dist_mean_mean] = deal(zeros(1, 11));
loss_coef_mean = mean(loss_coef);

for j = 1:len
    log_dist_min(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
        (10 * loss_coef(j)));
    log_dist_max(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
        (10 * loss_coef(j)));
    log_dist_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
        (10 * loss_coef(j)));
    log_dist_min_mean(j) = 10^(abs(rssi_max(j) - rssi_reference) / ...
        (10 * loss_coef_mean));
    log_dist_max_mean(j) = 10^(abs(rssi_min(j) - rssi_reference) / ...
        (10 * loss_coef_mean));
    log_dist_mean_mean(j) = 10^(abs(rssi_mean(j) - rssi_reference) / ...
        (10 * loss_coef_mean));
end

try
    close(char(fig_info));
catch
    %disp('car')
end

f1 = figure('name',char(fig_info));
subplot(211)
plot(distance, loss_coef, 'LineWidth',1, ...
    'Color',[0.93,0.69,0.13], ...
    'Marker','^','MarkerEdgeColor',[0.50,0.50,0.50],...
    'MarkerFaceColor',[0.00,0.45,0.74]);
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', '环境参数/?');
set(get(gca, 'Title'), 'String', strcat(char(fig_info),'-拟合结果分析'));
grid  minor

subplot(212)
plot(distance, log_dist_max,'LineWidth',1,'Marker','^');
hold on;
plot(distance, log_dist_min,'LineWidth',1,'Marker','o');
hold on;
plot(distance, log_dist_mean,'LineWidth',1,'Marker','+');
hold on;
plot(distance, log_dist_max_mean,'LineWidth',1,'Marker','*');
hold on;
plot(distance, log_dist_min_mean,'LineWidth',1,'Marker','s');
hold on;
plot(distance, log_dist_mean_mean,'LineWidth',1,'Marker','d');
ld = {'各自环境变量转换距离最大值', '各自环境变量转换距离最小值', ...
    '各自环境变量转换距离均值', '环境变量均值转换距离最大值', ...
    '环境变量均值转换距离最小值', '环境变量均值转换距离均值'};
L2 = legend(ld,'NumColumns',2,'FontWeight', 'bold');
L2.Box = 'off';
set(get(gca, 'XLabel'), 'String', '距离/m');
set(get(gca, 'YLabel'), 'String', 'rssi转换后距离/m');
grid  minor
end