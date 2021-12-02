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
ble1 = [30.5478754, 104.0585674];
ble2 = [30.5479455, 104.0585715];
ble3 = [30.5478776, 104.0586508];
ble4 = [30.5479471, 104.0586529];
ble_dots = [ble1; ble2; ble3; ble4];

if false
    tcf('ble');
    figure('name', 'ble');
    geoscatter(ble_dots(:, 1), ble_dots(:, 2));
    text(ble1(1), ble1(2), '11');
    text(ble2(1), ble2(2), '22');
    text(ble3(1), ble3(2), '33');
    text(ble4(1), ble4(2), '44');
end

% dist = utm_distance(lat1, lon1, lat2, lon2)
dist12 = utm_distance(ble1(1), ble1(2), ble2(1), ble2(2));
dist13 = utm_distance(ble1(1), ble1(2), ble3(1), ble3(2));
dist24 = utm_distance(ble2(1), ble2(2), ble4(1), ble4(2));
dist34 = utm_distance(ble3(1), ble3(2), ble4(1), ble4(2));

Pble1 = [0, 0];
Pble2 = [7.78, 0];
Pble3 = [0, -8];
Pble4 = [7.71, -7.81];
Pbles = [Pble1; Pble2; Pble3; Pble4];
% fingerprintint points
grid_gap = 1;
fpps_xy = cell(0);

for i = 0:grid_gap:8

    for j = 0:-1 * grid_gap:-8
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
    size(fpps_xy, 1), size(fpps_xy, 2), size(fpps_xy, 1) * size(fpps_xy, 2));
title(sprintf('radio map size:%.0f*%.0f=%.0f\n', ...
    size(fpps_xy, 1), size(fpps_xy, 2), size(fpps_xy, 1) * size(fpps_xy, 2)));
hold off
