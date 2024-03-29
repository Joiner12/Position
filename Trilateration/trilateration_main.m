clc;

if true
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
ap_final = cell(0);

for k = 1:1:length(debug{1}.ap_final_dist_calc)
    ap_final_temp = debug{1}.ap_final_dist_calc{k};

    for j = 1:1:length(ap_final_temp)
        [x_abs, y_abs, ~] = latlon_to_xy(ap_final_temp(j).lat, ap_final_temp(j).lon);
        xy_ref = [x_abs, y_abs] - [ref_loc_x, ref_loc_y];
        ap_final_temp(j).x_ref = xy_ref(1);
        ap_final_temp(j).y_ref = xy_ref(2);
    end

    ap_final{k} = ap_final_temp;
end

%%
clc;

if false
    ap_temp = ap_final{16};
    x_lct = [ap_temp(1).x_ref, ap_temp(2).x_ref, ap_temp(3).x_ref];
    y_lct = [ap_temp(1).y_ref, ap_temp(2).y_ref, ap_temp(3).y_ref];
    d_lct = [ap_temp(1).dist, ap_temp(2).dist, ap_temp(3).dist];
else
    % 验证最小二乘(多节点 > 3)
    % ap_temp = ap_final{16};
    x_lct = [0, 3, 2.2, 1.2];
    y_lct = [0, 1, 4, 4.6];
    d_lct = [2, 1.5, 2.3, 3];
end

if false
    tic;
    [est_ols, proc_ols] = trilateration_ols(x_lct, y_lct, d_lct);
    toc;
    tic;
    [est_gd, proc_gd] = trilateration_gd(x_lct, y_lct, d_lct);
    toc;
end

if false
    tic;
    [est_gn, proc_gn] = trilateration_gn(x_lct, y_lct, d_lct);
    toc;

end

if false
    tic;
    [est_lm, proc_lm] = trilateration_lm(x_lct, y_lct, d_lct);
    toc;
    %
    tic;
    [est_wgn, proc_wgn] = trilateration_wgn(x_lct, y_lct, d_lct);
    toc;
end

tic;
[est_wgn_s, proc_wgn_s] = trilateration_wgn_s(x_lct, y_lct, d_lct);
toc;
tic;
est_nlm = trilateration_fitnlm(x_lct, y_lct, d_lct);
toc;
centroid = [mean(x_lct), mean(y_lct)];
%%
draw_location([1, 1, 0, 0], {[x_lct(1), y_lct(1), d_lct(1)], ...
                            [x_lct(2), y_lct(2), d_lct(2)], ...
                            [x_lct(3), y_lct(3), d_lct(3)], ...
                            [x_lct(4), y_lct(4), d_lct(4)]}, ...
    {est_wgn_s, est_nlm, centroid})
