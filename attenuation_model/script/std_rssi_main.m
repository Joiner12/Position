
%%
tcf;
figure('Color','w');
for i = 1:1:length(noise_data_1)
    aptemp = noise_data_1{1,i};
    rssitemp = aptemp.RSSI;
    plot_py(linspace(1,length(rssitemp),length(rssitemp)),rssitemp)
    hold on
end
xlabel('采样序列');
ylabel('RSSI/dB')
title('蓝牙信号强度相互干扰测试')
legend({'HLK_1','HLK_2','HLK_3','HLK_4'})
%%
clc;
model_log = create_logarithmic_model_fit(dist,hlk_mean_vals_A7,'piecewise_rssi',-50);

%%
% a =      -41.43  (-43.22, -39.64)
% b =      -1.445  (-1.638, -1.252)
clc;
analysis_fit_model_normal(-25.59,3.038,HLK_18m_00cmA7,18);

%%
% -39.29  1.6
% -12 4.282
clc;
a = [-39.29,-12];
b = [1.6 4.282];
analysis_fit_model_piecewise(a(1),b(1),a(2),b(2),-50,HLK_1m_00cmA7,1)

%%
clc;
tcf('jet');
figure('Name','jet','Color','w')
n = 8;
r = (0:n)'/n;
theta = pi*(-n:n)/n;
X = r*cos(theta);
Y = r*sin(theta);
C = r*cos(2*theta);
pcolor(X,Y,C)
axis equal tight
% imagesc(xs,ys,data);colormap(jet);clorbar;

colormap(jet);
