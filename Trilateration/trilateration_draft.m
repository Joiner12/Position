clc;

if false
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\Trilateration\deve.mat')
else
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\Trilateration\deve_1.mat')
end

%% transfer loacation
% reference location [lat,lon]
lat_pillar = [30.547955238; 30.547965822; 30.547965822; 30.547955238];
lon_pillar = [104.058653621; 104.058653621; 104.05866709; 104.05866709];
ref_loc_ll = [lat_pillar(1), lon_pillar(1)];
[ref_loc_x, ref_loc_y, ~] = latlon_to_xy(ref_loc_ll(1), ref_loc_ll(2));

for k = 1:1:length(debug.ap_final_dist_calc)
    ap_final_temp = debug.ap_final_dist_calc{k};

    for j = 1:1:length(ap_final_temp)
        [x_abs, y_abs, ~] = latlon_to_xy(ap_final_temp(j).lat, ap_final_temp(j).lon);
        xy_ref = [x_abs, y_abs] - [ref_loc_x, ref_loc_y];
        %% todo:index error 2021-04-30 17:15
        % temp = debug.ap_final_dist_calc{k, j}
        % temp = debug.ap_final_dist_calc{k}(j).abs_pos
        % debug.ap_final_dist_calc{k, j}.abs_pos = [x_abs, y_abs];
        % debug.ap_final_dist_calc{k, j}.ref_pos = [xy_ref(1), xy_ref(2)];
    end

end

%%
tt = trilateration(1, 2, 3, '00');
[tt, a] = tt.nlfit_inline();
b = 1;
% [pos_res, ~] = trilateration_gaussian_newton(cur_ap);
%% save variables
save('D:\Code\BlueTooth\pos_bluetooth_matlab\Trilateration\deve.mat', ...
    "test_tt", "test_ttc")
