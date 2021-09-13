%%
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\cur_frame.mat');
%%
clc;
ap_selector = init_ap_selector(10);
[trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector);

%% ����apselector��Ϣѡ��λ��
%{
ap selector ѡ�����ݣ�
1.ap��Ծ�ȣ�������������ЧRSSIֵ�ĸ�����
2.ap rssi ͳ�����ܣ����أ���Ծ�� > ��ֵ > ����
%}

clc;
clear;
load cur_ap.mat
load rssi_s.mat
load ap_selector.mat

%%

trilat_table = ap_selector(2:end, :);
trilat_table.CHARAC_ACT = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[rssi�ź��ȶ���]
trilat_table.CHARAC_MEAN = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[RSSI��ֵ����]
trilat_table.CHARAC_VAR = zeros(size(trilat_table, 1), 1); % apѡ������ֵ[RSSI��������]
trilat_table.SELECT_WEIGHT = zeros(size(trilat_table, 1), 1); % ap���Ȩ��
% trilat_table.CALCDIST = zeros(size(trilat_table.RECVRSSI)); % �ڵ��źŽ���RSSI����
% trilat_table.MEANVAL = zeros(size(trilat_table, 1), 1); % RSSI��ֵ
% trilat_table.VARVAL = zeros(size(trilat_table, 1), 1); % RSSI����

%%
% rssi_statictis = zeros()
rssi_s = trilat_table.RECVRSSI;

act_rssi = zeros(0);
meanval_rssi = zeros(0);
var_rssi = zeros(0);

for i = 1:1:size(rssi_s, 1)
    cur_rssi = rssi_s(i, :);
    cur_rssi = cur_rssi(cur_rssi ~= 0);

    if ~isempty(cur_rssi)
        act_rssi(i, 1) = length(cur_rssi);
        meanval_rssi(i, 1) = mean(cur_rssi);
        var_rssi(i, 1) = var(cur_rssi);
    end

end

% ������ & ����ʹ��ȥ�ظ�
[~, sort_act_rssi] = maxk(act_rssi, 5);
[~, sort_meanval_rssi] = maxk(meanval_rssi, 5);
[~, sort_var_rssi] = mink(var_rssi, 5);

% ����ֵ
for j = 1:1:length(sort_act_rssi)
    trilat_table.CHARAC_ACT(sort_act_rssi(j)) = length(sort_act_rssi) + 1 - j;
    trilat_table.CHARAC_MEAN(sort_meanval_rssi(j)) = length(sort_meanval_rssi) + 1 - j;
    trilat_table.CHARAC_VAR(sort_var_rssi(j)) = length(sort_var_rssi) + 1 - j;
end

% ��Ԫ
charac_weight = [0.6, 0.3, 0.1]; % ����ֵȨ��
charc_temp = [trilat_table.CHARAC_ACT, trilat_table.CHARAC_MEAN, trilat_table.CHARAC_VAR];
trilat_table.SELECT_WEIGHT = charc_temp * charac_weight';

[~, index_temp] = maxk(trilat_table.SELECT_WEIGHT, 3);
selected_ap_name = trilat_table.NAME(index_temp);

%%
% ƴ��ap���
trilateration_ap = struct();
valid_ap_cnt = 1;

for j = 1:1:length(selected_ap_name)
    table_index = find(strcmp(trilat_table.NAME, selected_ap_name(j)));
    rssi_temp = trilat_table.RECVRSSI(table_index, :);

    if ~isempty(find(rssi_temp))
        trilateration_ap(valid_ap_cnt).name = trilat_table.NAME(table_index);
        trilateration_ap(valid_ap_cnt).mac = trilat_table.MAC(table_index);
        trilateration_ap(valid_ap_cnt).lat = trilat_table.LAT(table_index);
        trilateration_ap(valid_ap_cnt).lon = trilat_table.LON(table_index);
        trilateration_ap(valid_ap_cnt).recv_rssi = trilat_table.RSSI(table_index);
        trilateration_ap(valid_ap_cnt).rssi_reference = trilat_table.RSSI_REF(table_index);
        % ѡ���Ծ����������ap��RSSI�ľ�ֵ��Ϊ��λѡ�����
        % trilateration_ap(valid_ap_cnt).rssi = trilat_table.rssi(table_index);
        rssi_temp = trilat_table.RECVRSSI(table_index);
        rssi_temp = rssi_temp(rssi_temp ~= 0);
        trilateration_ap(valid_ap_cnt).rssi = mean(rssi_temp);
        trilateration_ap(valid_ap_cnt).rssi_wma = trilat_table.RSSI(table_index);
        trilateration_ap(valid_ap_cnt).rssi_gf = trilat_table.RSSI(table_index);
        trilateration_ap(valid_ap_cnt).rssi_kf = trilat_table.RSSI(table_index);
        trilateration_ap(valid_ap_cnt).dist = 0; % with a hammer dist
        valid_ap_cnt = valid_ap_cnt + 1;
    end

end

%%
clc;
load('ap_selector_1.mat');
pre_trilateration_ap = trilateration_ap;
trilateration_ap_af = secondary_selector(pre_trilateration_ap);
