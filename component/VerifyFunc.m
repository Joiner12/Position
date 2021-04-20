%% ÑéÖ¤lat_to_xyº¯Êý
clc;
tarDir = 'D:\Code\Python\Rsp';
location_file = fullfile(tarDir, 'result-1.txt');
real_pos = [30.5480360600000, 104.058595340000];
location_out = result1(1:end - 1, :);
dist_calc_python = location_out(:, 3);
python_err = err;

%%
dist_calc_matlab = zeros(0);

for j = 1:1:size(location_out, 1)
    pos_temp = location_out(j, :);
    dist = utm_distance(30.5480360600000, 104.058595340000, pos_temp(1), pos_temp(2));
    dist_calc_matlab(j) = dist;
    % dist = reshape(dist,[length()])
    % latlon_to_xy()
    % xy_to_latlon()
end
%% 
tcf('verify');
figure('name','verify')
plot(linspace(1,length(dist_calc_python),length(dist_calc_python)),dist_calc_python+0.1)
hold on
plot(linspace(1,length(dist_calc_matlab),length(dist_calc_matlab)),dist_calc_matlab)
legend({'geopy','geomatlab'})
