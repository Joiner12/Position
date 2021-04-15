%% È«Õ¾ÒÇ²âÊÔÊý¾Ý
% lat lon height
clc;
% Bluetooth anchor
load('datallh.mat');
bt_tab = datallh(find(contains(datallh.name, 'bt')), :);
% test point
exp = '^t[\d]{1,}';
cell_temp = regexp(datallh.name, exp, 'match');
t_index = zeros(0);

for k = 1:1:size(cell_temp, 1)

    if ~isempty(cell_temp{k})
        t_index = [t_index; k];
    end

end

test_tab = datallh(t_index, :);

%%
figure('name', 'ss', 'color', 'w');
geoplot(bt_tab.lat, bt_tab.lon, '*')
hold on
geoplot(test_tab.lat, test_tab.lon, '>')
geobasemap bluegreen

%%
clc;
x = zeros(0);
y = zeros(0);

for k = 1:1:height(bt_tab)
    [x(k), y(k), ~] = latlon_to_xy(bt_tab.lat(k), bt_tab.lon(k));
end

x = x - min(x);
y = y - min(y);

%%
% Bluetooth anchor
bt_tab_xyz = dataxyz(find(contains(dataxyz.name, 'bt')), :);
% test point
exp = '^t[\d]{1,}';
cell_temp = regexp(dataxyz.name, exp, 'match');
t_index = zeros(0);

for k = 1:1:size(cell_temp, 1)

    if ~isempty(cell_temp{k})
        t_index = [t_index; k];
    end

end

%%
figure('name', 's')
plot(bt_tab_xyz.x - min(bt_tab_xyz.x), bt_tab_xyz.y - min(bt_tab_xyz.y), '*')

%%
clc;
[x1, y1, ~] = latlon_to_xy(bt_tab.lat(1), bt_tab.lon(1));
[x2, y2, ~] = latlon_to_xy(bt_tab.lat(2), bt_tab.lon(2));
a1 = [x1, y1; x2, y2];
a2 = [bt_tab_xyz.x(1), bt_tab_xyz.y(1);bt_tab_xyz.x(2), bt_tab_xyz.y(2)];
a1(1,:) - a1(2,:)
a2(1,:) - a2(2,:)
