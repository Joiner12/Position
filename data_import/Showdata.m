%%
clc;
pd = ParseBLEData();
a = pd.GetParsedData();
disp('data parse finished')
%%
clc;
b = a{1, 1};
rssi = cell(0);
rssitemp = zeros(0);

for i = 1:1:max(size(b))
    celltemp = b{i};
    rssitemp = zeros(0);

    for j = 1:1:length(celltemp)
        rssitemp = [rssitemp, celltemp(j).rssi];
    end

    rssi{i, 1} = rssitemp;
end

clearvars b celltemp rssitemp i j rssiTemp
%% how it looks like
clc;
tcf('showOff');
figure('name', 'showOff');
x_temp = linspace(1, 1, 1);
headIndex = 1;
hold on
grid minor
xlim([headIndex, 300]);
ylim([-85, -72]);

for k = 1:1:30 %length(rssi)
    plt_vals = rssi{k};
    scatter(linspace(headIndex, headIndex + length(plt_vals) - 1, length(plt_vals)), ...
        plt_vals, 'filled');
    line('XData', [headIndex + length(plt_vals), headIndex + length(plt_vals)], ...
        'YData', [-85, -72], 'Linestyle', '-.', 'Color', rand(1, 3))
    headIndex = headIndex + length(plt_vals) + 2;
    pause(0.5)
end

%%
str_temp = '$APMSG onepos_HLK_3         1d:06:00:3c:d6:40 -62  30.5480210           104.0585709';
split_temp = strsplit(str_temp, ' ')

if ~isempty(split_temp) && contains(split_temp{1}, '$APMSG')
    ap_name = split_temp{2};
    index_logical = strcmp(["onepos_HLK_1", "onepos_HLK_3", ...
            "onepos_HLK_7", "onepos_HLK_8"],ap_name);
    if any(index_logical)
        find(index_logical)
    end
    
end
