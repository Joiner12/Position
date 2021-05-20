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

%% compare code -c
clc;
c1 = [1, 1, 2];
c2 = [5, 1, 2.5];
c3 = [4, 3, 2];
[est_pos, ~] = trilateration_wgn([c1(1), c2(1), c3(1)], [c1(2), c2(2), c3(2)], [c1(3), c2(3), c3(3)]);
est_pos_wgn = est_pos;
tcf('wgn');
figure('name', 'wgn');
hold on
circles(c1(1), c1(2), c1(3), 'facecolor', 'none', 'edgecolor', 'c')
circles(c2(1), c2(2), c2(3), 'facecolor', 'none', 'edgecolor', 'c')
circles(c3(1), c3(2), c3(3), 'facecolor', 'none', 'edgecolor', 'c')
plot(est_pos_wgn(1), est_pos_wgn(2), 'r*')
axis equal
