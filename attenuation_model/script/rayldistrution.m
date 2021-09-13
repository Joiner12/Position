clc; disp('Rayleigh probability density');
x = 0:.1:4;
y1 = raylpdf(x, 0.5); % b=0.5
y2 = raylpdf(x, 0.7); % b=0.7
y3 = raylpdf(x, 1); % b=1
y4 = raylpdf(x, 2); % b=2
y5 = raylpdf(x, 8); % b=8
tcf('raly'); figure('name', 'raly', 'color', 'w');
hold on
plot(x, y1, 'r');
plot(x, y2, 'r--');
plot(x, y3, 'b-');
plot(x, y4, 'b--');
plot(x, y5, 'g-');
hold off
title('ÈðÀû·Ö²¼');
legend('b=0.5', 'b=0.7', 'b=1', 'b=2', 'b=8');
