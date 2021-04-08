function distance = calc_distance_based_on_rssi_piecewise(ap,varargin)
% 功能:
%       根据AP信息查询分段拟合模型获取RSSI对应的距离信息
% 定义:
%       distance = calc_distance_based_on_rssi_piecewise(ap,rssi,varargin)
% 输入:
%       ap:ap数据，依据各个ap数据的rssi计算对应的距离
%       varargin:保留参数


%% 先验拟合数据结果
%{
    struct{
    char name[];
    double param_less_rssi[2]; // piecewise < const double A
    double param_more_rssi[2]; // piecewise >= const double A
    double piecewise_rssi; //
}
%}
AP_1 =  struct('Name','onepos_HLK_1',...
    'param_less_rssi',[-31.03,2.424],...
    'param_more_rssi',[-46.44,0.3551],...
    'piecewise_rssi', -49.08);

AP_2 =  struct('Name','onepos_HLK_2',...
    'param_less_rssi',[-24.65,3.018],...
    'param_more_rssi',[ -44.25 ,0.8552],...
    'piecewise_rssi', -52);

AP_3 =  struct('Name','onepos_HLK_3',...
    'param_less_rssi',[-26.35,2.86],...
    'param_more_rssi',[-44.78,0.75],...
    'piecewise_rssi', -51.33);

AP_4 =  struct('Name','onepos_HLK_4',...
    'param_less_rssi',[-36.49,2.16],...
    'param_more_rssi',[-46.49,0.80],...
    'piecewise_rssi', -52.32);

AP_5 =  struct('Name','onepos_HLK_5',...
    'param_less_rssi',[-30.28,2.78],...
    'param_more_rssi',[-44.01,1.02],...
    'piecewise_rssi', -51.93);

AP_6 =  struct('Name','onepos_HLK_6',...
    'param_less_rssi',[-6.33,5.36],...
    'param_more_rssi',[-45.45,1.71],...
    'piecewise_rssi', -63.70);

AP_7 =  struct('Name','onepos_HLK_7',...
    'param_less_rssi',[-8.61,5.11],...
    'param_more_rssi',[-44.91,1.61],...
    'piecewise_rssi', -61.56);

AP_8 =  struct('Name','onepos_HLK_8',...
    'param_less_rssi',[35.78,8.315],...
    'param_more_rssi',[-42.33,1.09],...
    'piecewise_rssi', -54.13);

%% 偏置拟合结果
AP_1_offset =  struct('Name','onepos_HLK_1',...
    'param_less_rssi',[-21.28,4.17],...
    'param_more_rssi',[-44.16,2.47],...
    'piecewise_rssi', -77.55);

AP_2_offset =  struct('Name','onepos_HLK_2',...
    'param_less_rssi',[-27.89,3.55],...
    'param_more_rssi',[-48.24,1.70],...
    'piecewise_rssi',-66.98);

AP_3_offset =  struct('Name','onepos_HLK_3',...
    'param_less_rssi',[-8.62,5.16],...
    'param_more_rssi',[-40.17,2.61],...
    'piecewise_rssi', -72.55);

AP_4_offset =  struct('Name','onepos_HLK_4',...
    'param_less_rssi',[-51.36,1.47],...
    'param_more_rssi',[-47.02,1.67],...
    'piecewise_rssi', -83.33);

AP_5_offset =  struct('Name','onepos_HLK_5',...
    'param_less_rssi',[-9.70,5.25],...
    'param_more_rssi',[-46.42,1.97],...
    'piecewise_rssi', -68.51);

AP_6_offset =  struct('Name','onepos_HLK_6',...
    'param_less_rssi',[57.80,11.22],...
    'param_more_rssi',[-45.53,2.14],...
    'piecewise_rssi', -69.92);

AP_7_offset =  struct('Name','onepos_HLK_7',...
    'param_less_rssi',[24.84,8.39],...
    'param_more_rssi',[-48.56,1.82],...
    'piecewise_rssi', -68.94);

AP_8_offset =  struct('Name','onepos_HLK_8',...
    'param_less_rssi',[-8.04,5.20],...
    'param_more_rssi',[-49.17,1.35],...
    'piecewise_rssi', -63.58);

%% calculation
if false
    ap_params = {AP_1,AP_2,AP_3,AP_4,...
        AP_5,AP_6,AP_7,AP_8};
else
    ap_params = {AP_1_offset,AP_2_offset,AP_3_offset,AP_4_offset,...
        AP_5_offset,AP_6_offset,AP_7_offset,AP_8_offset};
end

ap_name = ap.name;
ap_rssi = ap.rssi;
cur_param = struct();

% 查表
for i = 1:1:length(ap_params)
    ap_temp = ap_params{i};
    if strcmp(ap_name,ap_temp.Name)
        cur_param = ap_temp;
        break;
    end
end

dist = calculate_distance_based_on_rssi_piecewise(...
    cur_param.param_less_rssi,cur_param.param_more_rssi,...
    ap_rssi,cur_param.piecewise_rssi);
distance = dist;
end