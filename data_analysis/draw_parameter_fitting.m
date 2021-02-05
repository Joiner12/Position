function draw_parameter_fitting(distance,rssi,fig_info,varargin)
% ��������:
%     ���ƶ�������·�����ģ�ͼ��������
% ��������:
%     dist:����(array)
%     rssi:�����Ӧrssi(cell)
%     fig_info:ͼ����Ϣ(char)
%     varargin:��������
% �������:
%     None

%% ����������
if (~isnumeric(distance) || ~iscell(rssi) ...
        || ~(ischar(fig_info)))
    error("�������ʹ���");
end
disp('���Ʋ�����Ϸ���ͼ')
%% ��ʼ������
% rssi = ap_rssi{i};
% dist = ap_dist{i};
len = length(distance);

rssi_mean = zeros(1, len);
rssi_max = zeros(1, len);
rssi_min = zeros(1, len);

% ����������и�֡rssi�ľ�ֵ�������Сֵ
for j = 1:len
    rssi_mean(j) = mean(rssi{j});
    rssi_max(j) = max(rssi{j});
    rssi_min(j) = min(rssi{j});
end

%% �����������Ĳ������
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
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', '��������/?');
set(get(gca, 'Title'), 'String', strcat(char(fig_info),'-��Ͻ������'));
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
ld = {'���Ի�������ת���������ֵ', '���Ի�������ת��������Сֵ', ...
    '���Ի�������ת�������ֵ', '����������ֵת���������ֵ', ...
    '����������ֵת��������Сֵ', '����������ֵת�������ֵ'};
L2 = legend(ld,'NumColumns',2,'FontWeight', 'bold');
L2.Box = 'off';
set(get(gca, 'XLabel'), 'String', '����/m');
set(get(gca, 'YLabel'), 'String', 'rssiת�������/m');
grid  minor
end