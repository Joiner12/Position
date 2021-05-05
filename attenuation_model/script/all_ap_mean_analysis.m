%% 不同ap rssi均值
clc;
ap_rssi_mean_mean = zeros([18, 8]);

% 1~18m
for k = 1:1:18
    ap_rssi_specdist = zeros(0);
    % ap 1~8
    for j = 1:1:8
        temp = all_rssi_mean{j};
        temp = temp(k);
        ap_rssi_specdist(j) = temp;
    end

    ap_rssi_mean_mean(k, :) = ap_rssi_specdist;
end

ap_rssi_mean_specdist = zeros(0);

for ki = 1:1:size(ap_rssi_mean_mean, 1)
    ap_rssi_mean_specdist(ki) = mean(ap_rssi_mean_mean(ki, :));
end

clearvars temp j k ap_rssi_specdist ki

%%
tcf('expmean');
figure('name', 'expmean', 'color', 'w');
legds = cell(0);
mark_symbol = ['o', '+', '*', '.', 'x', '^', 'v', ...
                '>', '<', 'pentagram', 'hexagram', 'square', 'diamond'];

subplot(211)

for k = 1:1:length(all_rssi_mean)
    rssi_temp = all_rssi_mean{k};
    plot(rssi_temp(1:8), 'marker', mark_symbol(k))
    hold on
    legds = [legds, num2str(k)];
end

plot_py(linspace(1, 8, 8), ap_rssi_mean_specdist(1:8))
legds = [legds, 'more'];
legend(legds)

subplot(212)
legds = zeros(0);

for k = 1:1:length(all_rssi_mean)
    rssi_temp = all_rssi_mean{k};
    plot(rssi_temp(9:18), 'marker', mark_symbol(k))
    hold on
    legds = [legds, num2str(k)];
end

plot_py(linspace(1, 10, 10), ap_rssi_mean_specdist(9:18))
legds = [legds, 'more'];
legend(legds)
%%
clearvars temp j k ap_rssi_specdist ki legds rssi_temp x

%% fit model
clc;
part_rssi = ap_rssi_mean_specdist;
delta_env = -13; %
part_rssi = part_rssi(1:18) + delta_env;
%
handle_mode = 'check_model'; % 'fit_model'| 'check_model'

switch handle_mode
    case 'fit_model'
        create_logarithmic_model_fit(linspace(1, 18, 18), part_rssi)

    case 'check_model'
        a = -52;
        b = 2.5;
        analysis_fit_model_normal(a, b, part_rssi, 10);

    otherwise
        disp('no such selection')
end

clearvars part_rssi a
