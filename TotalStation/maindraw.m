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
get_ble_anchor
%% 
