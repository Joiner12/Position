%% load data
clc;
% apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
std_rssi_one_HLK_8 = get_std_dist_rssi_data('src_folder',...
    'D:\Codes\Location\attenuation_model\data\8�ڵ����\8�ڵ����'...
    ,'ap_filter',{'HLK_8'});
%% ��ȡ��̬���Ե���λ�ý��
clc;
static_one_HLK_8 = get_std_dist_rssi_data('src_folder',...
    '../data'...
    ,'ap_filter',{'HLK_8'});

%% ��Ͻ������
clc;
% AP_1 =  struct('Name','onepos_HLK_1',...
%     'param_less_rssi',[-31.03,2.424],...
%     'param_more_rssi',[-46.44,0.3551],...
%     'piecewise_rssi', -49.08);
all_apinfo = {AP_1,AP_2,AP_3,AP_4,...
    AP_5,AP_6,AP_7,AP_8};
all_static_oneHLK = {static_one_HLK_1,static_one_HLK_2,static_one_HLK_3,...
    static_one_HLK_4,static_one_HLK_5,...
    static_one_HLK_6,static_one_HLK_7,static_one_HLK_8};
for i = 1:1:length(all_apinfo)
    cur_ap = all_apinfo{i};
    cur_static_one_HLK = all_static_oneHLK{i};
    mp_l = cur_ap.param_less_rssi; % rssi >= -50��Ͻ��:A=-46.44,n=0.36
    mp_m = cur_ap.param_more_rssi;
    piecewise_rssi = cur_ap.piecewise_rssi;
    rssi_test = cur_static_one_HLK{1}.RSSI;
    distance = calculate_distance_based_on_rssi_piecewise(mp_l,mp_m,rssi_test,piecewise_rssi);
    % ����ʵ�����Ч��
    % analysis_fit_model_piecewise(Am,bm,Al,bl,piecewise_rssi,rssi,true_dist,varargin)
    analysis_fit_model_piecewise(mp_m(1),mp_m(2),...
        mp_l(1),mp_l(2),...
        piecewise_rssi,rssi_test,10)
end
%%
all_rssi_mean = cell(0);
for i=1:1:8
    var_str = strcat('m_RSSI_HLK_',num2str(i));
    eval(['[',var_str,',~,~,~]',...
        strcat('=get_global_std_statistics(std_rssi_one_HLK_',num2str(i)),');']);
    eval(['rssi_temp = ',var_str])
    %     rssi_temp =
    all_rssi_mean{i,1} = rssi_temp;
end

%% figure - 1
clc;
tcf('ss');
figure('Name','ss','Color','w')
len_temp = length(m_RSSI_HLK_1);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_1,'Marker','*',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_2);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_2 + m_RSSI_HLK_1(1)-m_RSSI_HLK_2(1),'Marker','o',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_3);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_3 + m_RSSI_HLK_1(1)-m_RSSI_HLK_3(1),'Marker','+',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_4);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_4 + m_RSSI_HLK_1(1)-m_RSSI_HLK_4(1),'Marker','x',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_5);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_5 + m_RSSI_HLK_1(1)-m_RSSI_HLK_5(1),'Marker','s',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_6);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_6 + m_RSSI_HLK_1(1)-m_RSSI_HLK_6(1),'Marker','d',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_7);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_7 + m_RSSI_HLK_1(1)-m_RSSI_HLK_7(1),'Marker','^',...
    'LineWidth',1.5);
hold on
len_temp = length(m_RSSI_HLK_8);
plot(linspace(1,len_temp,len_temp),m_RSSI_HLK_8 + m_RSSI_HLK_1(1)-m_RSSI_HLK_8(1),'Marker','v',...
    'LineWidth',1.5);
title({'HLK1~HLK8:����-RSSI�ֶ��������Խ���Ա�','RSSI = -10lg(d/d_0)+C+\Delta'})
grid minor
apfilter = {'HLK_1','HLK_2','HLK_3','HLK_4','HLK_5','HLK_6','HLK_7','HLK_8'};
legend(apfilter)
xlabel('����/m');
ylabel('rssi/dB');
grid on

%% piecewise curve fitting
clc;

% for j =1:1:length(all_rssi_mean)
for j =1:1:8
    cur_rssi = all_rssi_mean_offset{j};
    len_temp = length(cur_rssi);
    dist = linspace(1,len_temp,len_temp);
    fprintf('## AP:%.0f ��Ͻ��\n ### �ֶ�RSSI:%.1f\n',j,cur_rssi(dist(dist==4)))
    create_logarithmic_model_fit(dist,cur_rssi','piecewise_rssi',...
        cur_rssi(dist(dist==5)),'drawpic',false);
    fprintf('___________________\n');
%     tcf;
end