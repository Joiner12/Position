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
ap_temp = ap_final{16};
x_lct = [ap_temp(1).x_ref, ap_temp(2).x_ref, ap_temp(3).x_ref];
y_lct = [ap_temp(1).y_ref, ap_temp(2).y_ref, ap_temp(3).y_ref];
d_lct = [ap_temp(1).dist, ap_temp(2).dist, ap_temp(3).dist];
tt = trilateration(x_lct, y_lct, d_lct, 'OLS');
tic;
[est_ols, proc_ols] = trilateration_ols(x_lct, y_lct, d_lct);
toc;
tic;
% [est_gd, proc_gd] = trilateration_gd(x_lct, y_lct, d_lct);
toc;
tic;
[est_gn, proc_gn] = trilateration_gn(x_lct, y_lct, d_lct);
toc;
tic;
[est_lm, proc_lm] = trilateration_lm(x_lct, y_lct, d_lct);
toc;
tic;
est_nlfit = tt.nlfit_inline();
toc;
centroid = [mean(x_lct), mean(y_lct)];
%
draw_location([1, 1, 0, 0], {[x_lct(1), y_lct(1), d_lct(1)], ...
                            [x_lct(2), y_lct(2), d_lct(2)], ...
                            [x_lct(3), y_lct(3), d_lct(3)]}, ...
    {est_gd, est_ols, est_gn, est_lm, est_nlfit, centroid})


%%
function draw_location(rect, ccs, points)
    tcf('draw_location');
    figure('name', 'draw_location');
    hold on
    % rectangle
    rectangle('position', rect, 'edgecolor', 'b', 'linewidth', 2);
    % circle
    line_point = zeros(0);

    for k = 1:1:length(ccs)
        circle_temp = ccs{k};
        circles(circle_temp(1), circle_temp(2), circle_temp(3), ...
            'facecolor', 'none', 'edgecolor', rand(1, 3))
        line_point(k, 1) = circle_temp(1);
        line_point(k, 2) = circle_temp(2);
    end

    line_point = [line_point; line_point(1, :)];
    % line
    plot(line_point(:, 1), line_point(:, 2), 'marker', '+', 'color', 'r');
    % dot
    for j = 1:1:length(points)
        point_temp = points{j};
        plot(point_temp(1), point_temp(2), 'marker', '*', 'color', rand(1, 3));
        text(point_temp(1), point_temp(2), ...
            strcat('\color[rgb]{0,0.5,0.5}\fontsize{16}\bf\diamondsuit', num2str(j)), ...
            'HorizontalAlignment', 'center');
    end

    axis equal;
    box on;
end
