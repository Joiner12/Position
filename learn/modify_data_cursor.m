% 修改数据游标格式
clc;
nbt_lat_lon_h = [104.058567643123, 30.547872167734, 467.946972989477
            104.058567183453, 30.548014837274, 468.115972990170
            104.058730768827, 30.548018797743, 467.900972989388
            104.058889206422, 30.547874726343, 468.024972987361
            104.058895271369, 30.548019508539, 469.051972987130
            104.058728300713, 30.547880364315, 469.601972988807];

[x_1, y_1, utm1] = latlon_to_xy(30.547872167734, 104.058567643123);
[x_2, y_2, utm1] = latlon_to_xy(30.548019508539, 104.058895271369);
% lat:30.5478721677,lon:104.0585676431
x_s = linspace(x_1, x_2, 200);
y_s = linspace(y_1, y_2, 200);
[x_s, y_s] = meshgrid(x_s, y_s);

tcf('map-grid');
f1 = figure('name', 'map-grid');
hold on
dcm_obj = datacursormode(f1);
set(dcm_obj, 'UpdateFcn', @modify_cursor_callback)
mesh(x_s, y_s, zeros(200, 200))
plot(x_s(1), y_s(1), 'r*')
text(x_s(1), y_s(1), '1')
plot(x_s(end), y_s(end), 'b*')
text(x_s(end), y_s(end), '5')
view(0, 90)
grid minor
