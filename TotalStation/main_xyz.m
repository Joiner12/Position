%{
数据说明:
./ data_llh.dat 经纬高数据
./ data_xyz.dat 墨卡托投影数据(经纬高转换数据)
%}
clc
fid = fopen('data_xyz.dat');
tline = fgetl(fid);

tcf('靶点分布');
figure('name', '靶点分布');
set(gca, 'YDir', 'reverse');
set(gca, 'XDir', 'reverse');
ylabel('north direction (m)')
xlabel('east direction (m)')
title('靶点分布-XYZ')
text_padding = -0.55;
grid on

wifi_loc = [];
bt_loc = [];
test_loc = [];
test_name = {};
anchor_loc = [];

while ischar(tline)
    str = regexp(tline, ',', 'split');

    if strcmp(str{2}, 'station')
        tline = fgetl(fid);
        continue;
    end

    if strfind(str{1}, 'w')
        hold on
        plot(str2double(str{4}), str2double(str{3}), '+r');
        hold on
        text(str2double(str{4}) + text_padding, str2double(str{3}) + text_padding, str{1});

        wifi_loc = [wifi_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
    end

    if strcmp(str{1}(1), 't')
        hold on
        plot(str2double(str{4}), str2double(str{3}), 'og');
        hold on
        text(str2double(str{4}) - text_padding, str2double(str{3}) - text_padding, str{1});

        test_loc = [test_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
        test_name = [test_name; str{1}];
    end

    if strfind(str{1}, 'b')

        if strfind(str{1}, 'bt')
            hold on
            plot(str2double(str{4}), str2double(str{3}), '*b');
            hold on
            text(str2double(str{4}) + text_padding, str2double(str{3}) + text_padding, str{1});
            bt_loc = [bt_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];

        elseif strfind(str{1}, 'base')
        else
            hold on
            plot(str2double(str{4}), str2double(str{3}), '*k');
            hold on
            text(str2double(str{4}) + text_padding, str2double(str{3}) + text_padding, str{1});
            anchor_loc = [anchor_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
        end

    end

    tline = fgetl(fid);
end

fclose(fid);

%% 可视图
tcf('靶点分布-1')
figure('name', '靶点分布-1');
set(gca, 'YDir', 'reverse');
set(gca, 'XDir', 'reverse');
ylabel('north direction (m)')
xlabel('east direction (m)')
title('靶点分布-XYZ')
grid on
hold on
box on
axis equal
plot(anchor_loc(:, 1), anchor_loc(:, 2), '*k')
hold on
plot(wifi_loc(:, 1), wifi_loc(:, 2), '+r')
hold on
plot(bt_loc(:, 1), bt_loc(:, 2), '*b')
hold on
plot(test_loc(:, 1), test_loc(:, 2), 'og')
legend('Window Anchor', 'WIFI AP', 'BlueTooth AP', 'Test Target')

%% verify the total station data
%{
update date:2021 - 05 - 12 14:18
%}
clc;
disp('new bluetooth lat lon location');
nbt_lat_lon_h = [
            104.058567643123, 30.547872167734, 467.946972989477
            104.058567183453, 30.548014837274, 468.115972990170
            104.058730768827, 30.548018797743, 467.900972989388
            104.058889206422, 30.547874726343, 468.024972987361
            104.058895271369, 30.548019508539, 469.051972987130
            104.058728300713, 30.547880364315, 469.601972988807
            ];

nbt = table(["nt1", "nt2", "nt3", "nt4", "nt5", "nt6"]', ...
    nbt_lat_lon_h(:, 1), nbt_lat_lon_h(:, 2), nbt_lat_lon_h(:, 3), ...
    'VariableNames', {'nodeName', 'lon', 'lat', 'height'});

legs = cell(0);
tcf('gep');
figure('name', 'gep')
plot(nbt.lon, nbt.lat, 'LineStyle', 'none', 'Marker', '*');
text(nbt.lon, nbt.lat, nbt.nodeName);
% for k = 1:length(nbt.lat)
%     legs{k} = strcat('nt', num2str(k));
% end
%%
[x_1, y_1, ~] = latlon_to_xy(nbt.lat(1), nbt.lon(1));
[x_2, y_2, ~] = latlon_to_xy(nbt.lat(2), nbt.lon(2));
[x_3, y_3, ~] = latlon_to_xy(nbt.lat(3), nbt.lon(3));
[x_4, y_4, ~] = latlon_to_xy(nbt.lat(4), nbt.lon(4));
[x_5, y_5, ~] = latlon_to_xy(nbt.lat(5), nbt.lon(5));
[x_6, y_6, ~] = latlon_to_xy(nbt.lat(6), nbt.lon(6));
norm([x_1 - x_6, y_1 - y_6])
