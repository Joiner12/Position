%% 目标函数-凸函数
clc;
X = x_lct;
Y = y_lct;
D = d_lct;
F1 = @(x, y)((sqrt((X(1) - x).^2 + (Y(1) - y).^2) - D(1)).^2 + ...
    (sqrt((X(2) - x).^2 + (Y(2) - y).^2) - D(2)).^2 + ...
    (sqrt((X(3) - x).^2 + (Y(3) - y).^2) - D(3)).^2);

[x_r, y_r] = meshgrid(-10:.1:10, -10:.1:10);
z_r = F1(x_r, y_r);
tcf('meshZ');
figure('name', 'meshZ')
mesh(x_r, y_r, z_r)

%%
clc;
[est_pos_gd, procss_gd] = trilateration_gd(x_lct, y_lct, d_lct);
%  debug for gradient descent
tcf('meshZ1');
figure('name', 'meshZ1');
proc_gdm = cell2mat(proc_gd);
plot(proc_gdm(1:2:end), proc_gdm(2:2:end), 'marker', '*')

%%
[x_index, y_index] = find((z_r == min(min(z_r))))
