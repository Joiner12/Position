clc;
% Copy_of_blu_data_analyse_dynamic();
curve_fitting_info = struct([]);
[curve_fitting_info_distance,curve_fitting_info_rssi, ...
    curve_fitting_pd_mu] = deal(zeros(0));

for i=1:1:length(different_ap.rssi)
    a = different_ap.rssi{1,i};
    fig_info = sprintf('Fig-distance %s RSSI', num2str(i));
    [draw_out,pd_mu] = draw_base_distance_rssi(a,fig_info,'do not show');
    curve_fitting_info_distance(i) = i;
    curve_fitting_info_rssi(i) = draw_out;
    curve_fitting_pd_mu(i) = pd_mu;
    curve_fitting_info(i).dist = i;
    curve_fitting_info(i).mean_frame_rssi = draw_out;
end
disp('data handle finished')
%%
save('curve_fitting_info.mat', ...
    'curve_fitting_info_distance', ...
    'curve_fitting_info', ...
    'curve_fitting_info_rssi', ...
    'curve_fitting_pd_mu');

%% 
clc;
model_a = {};
model_a.A = -61.48;
model_a.n = 1.3;
% distance = calculate_distance_based_on_rssi(model_parameter,rssi,varargin)
calc_dist = calculate_distance_based_on_rssi(model_a,curve_fitting_info_rssi);
% rssi = calculate_rssi_based_on_distance(model_parameter,distance,varargin)
calc_rssi = calculate_rssi_based_on_distance(model_a,curve_fitting_info_distance);
draw_rssi_correspondence_distance(curve_fitting_info_distance,calc_rssi,'app');
draw_rssi_correspondence_distance(calc_dist,curve_fitting_info_rssi,'app1');

%%
draw_rssi_correspondence_distance(curve_fitting_info_distance,curve_fitting_info_rssi,'12')
