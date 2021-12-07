%%
disp('test file');
% D:\Code\BlueTooth\pos_bluetooth_matlab
lat_lon_1 = [30.5480286, 104.0587327];
lat_lon_2 = [30.5480285, 104.0587327];
[x_1, y_1, ~] = latlon_to_xy(lat_lon_1(1), lat_lon_1(2));
[x_2, y_2, ~] = latlon_to_xy(lat_lon_2(1), lat_lon_2(2));
norm([x_2 - x_1, y_2 - y_1])
% ×Ö·û´®Ö¸ÕëÊý×é

%%
clc;
ble5 = [30.547872167734, 104.058567643123]; % ope_1
ble6 = [30.548014837274, 104.058567183453]; % ope_2
ble7 = [30.548018797743, 104.058730768827]; % ope_3
ble8 = [30.547880364315, 104.058728300713]; % ope_6
ble_dots = [ble5; ble6; ble7; ble8];

if false
    tcf('ble');
    figure('name', 'ble');
    geoscatter(ble_dots(:, 1), ble_dots(:, 2));
    text(ble5(1), ble5(2), '11');
    text(ble6(1), ble6(2), '22');
    text(ble7(1), ble7(2), '33');
    text(ble8(1), ble8(2), '44');
end

% dist = utm_distance(lat1, lon1, lat2, lon2)
dist12 = utm_distance(ble5(1), ble5(2), ble6(1), ble6(2));
dist13 = utm_distance(ble5(1), ble5(2), ble7(1), ble7(2));
dist14 = utm_distance(ble5(1), ble5(2), ble8(1), ble8(2));
dist34 = utm_distance(ble7(1), ble7(2), ble8(1), ble8(2));

Pble1 = [0, 0];
Pble2 = [dist12, 0];
Pble3 = [0, -1 * dist14];
Pble4 = [dist12, -1 * dist14];
Pbles = [Pble1; Pble2; Pble3; Pble4];
% fingerprintint points
grid_gap = 2;
fpps_xy = cell(0);

for i = 0:grid_gap:dist12

    for j = 0:-1 * grid_gap:-1 * dist14
        fpps_xy{i / grid_gap + 1, -1 * j / grid_gap + 1} = [i, j];
    end

end

tcf('radio_map');
figure('name', 'radio_map', 'color', 'w');
hold on
plot(Pbles(:, 1), Pbles(:, 2), 'marker', '*', ...
    'linestyle', 'none', 'markersize', 15, 'color', 'r')

for i1 = 1:size(fpps_xy, 1)

    for i2 = 1:size(fpps_xy, 2)
        cur_point = fpps_xy{i1, i2};
        plot(cur_point(1), cur_point(2), 'marker', 'o', 'markersize', 2)
    end

end

fprintf('radio map size:%.0f*%.0f=%.0f\n', ...
    dist12, dist14, dist12 * dist14);
title(sprintf('radio map size:%.0f*%.0f=%.0f\n', ...
    dist12, dist14, dist12 * dist14));
hold off
