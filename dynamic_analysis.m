%%
clc;
y1 = randi(100, 1, 100);
y2 = randi(200, 1, 100);
y3 = rand(1, 1000);
tcf('discreted')
figure('name', 'discreted', 'color', 'w')
subplot(3, 1, 1)
hold on
plot(y1, 'marker', 'o', 'linewidth', 1.5)
plot(y2, 'marker', 'o', 'linewidth', 1.5)
legend('max rand value 100', 'max rand value 200')
subplot(3, 1, 2)
% hold on
histfit(y1)
subplot(3, 1, 3)
histfit(y3)
