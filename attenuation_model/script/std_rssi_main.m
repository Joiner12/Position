%%
tcf;
figure('Color', 'w');

for i = 1:1:length(noise_data_1)
    aptemp = noise_data_1{1, i};
    rssitemp = aptemp.RSSI;
    plot_py(linspace(1, length(rssitemp), length(rssitemp)), rssitemp)
    hold on
end

xlabel('��������');
ylabel('RSSI/dB')
title('�����ź�ǿ���໥���Ų���')
legend({'HLK_1', 'HLK_2', 'HLK_3', 'HLK_4'})
%%
clc;
model_log = create_logarithmic_model_fit(dist, hlk_mean_vals_A7, 'piecewise_rssi', -50);

%%
% a =      -41.43  (-43.22, -39.64)
% b =      -1.445  (-1.638, -1.252)
clc;
analysis_fit_model_normal(-25.59, 3.038, HLK_18m_00cmA7, 18);

%%
% -39.29  1.6
% -12 4.282
clc;
a = [-39.29, -12];
b = [1.6 4.282];
analysis_fit_model_piecewise(a(1), b(1), a(2), b(2), -50, HLK_1m_00cmA7, 1)

%%
clc;
tcf('jet');
figure('Name', 'jet', 'Color', 'w')
n = 8;
r = (0:n)' / n;
theta = pi * (-n:n) / n;
X = r * cos(theta);
Y = r * sin(theta);
C = r * cos(2 * theta);
pcolor(X, Y, C)
axis equal tight
% imagesc(xs,ys,data);colormap(jet);clorbar;

colormap(jet);

%%
or_file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\��̬-1-fast-m-split.txt';
rssi_A1 = get_rssi_info(or_file, '1');
rssi_A3 = get_rssi_info(or_file, '3');
rssi_A7 = get_rssi_info(or_file, '7');
rssi_A8 = get_rssi_info(or_file, '8');
%%
get_rssi_statistics(rssi_A1, 'showfigure')
get_rssi_statistics(rssi_A3, 'showfigure')
get_rssi_statistics(rssi_A7, 'showfigure')
get_rssi_statistics(rssi_A8, 'showfigure')

%%
clc;
tcf('face');
% clarify filter
windowSize = 100;
b = (1 / windowSize) * ones(1, windowSize);
a = 1;
rssi_A1_f = filter(b, a, rssi_A1);
figure('name', 'face')
plot(rssi_A1)
hold on
plot(rssi_A1_f)
legend({'a', 'f'})

%%
clc;
A = -49.5;
b = 2.2;
envf = 0;
rssi = linspace(-85, -50, 100);
d = 10.^((A - rssi + envf) / 10 / b);
tcf('dodo');
figure('name', 'dodo')
plot(rssi, d)

%%
clc;
dev = 6;
f1 = @(x)0.02354 * x.^2 + 1.677 * x + 29.87;
f2 = @(x)0.02354 * (x + dev).^2 + 1.677 * (x + dev) + 29.87;
f3 = @(x)0.02354 * x.^2 + 1.677 * x + 29.87 - dev;
tcf('dev');
figure('name', 'dev', 'color', 'white');
rssi_x = [-80, -42];
hold on;
fplot(f1, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
fplot(f2, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
fplot(f3, rssi_x, 'LineWidth', 1.5, 'Marker', 'd')
legend('up', 'down-x', 'down-y')
title("����ʽ���-���뻷������(DEV)")
xlabel('rssi/dbm');
ylabel('distance/m')
box on
grid minor

%%
cur_rssi = HLK_0m_75cmA7;
rssi_kf = kalman_filter_rssi(cur_rssi, 4.5, 0);
tcf('kalman');
figure('name', 'kalman', 'color', 'white')
hold on
plot(cur_rssi)
plot(rssi_kf)
plot(ones(size(rssi_kf)) * mean(rssi_kf))

%% 
rssi_kf_std =kalman_cmp(cur_rssi);

%% 
%�����ӴӰٶ��Ŀ��еõ��� �Լ�ע��
% clear
N=length(cur_rssi);%ȡ200����

% ������������ ������������
w=randn(1,N); %����һ��1��N������������һ����Ϊ0��wΪ������������ͺ�ߵ�v�ڿ������������Ϊ��˹��������
w(1)=0;
Q=var(w); % R��Q�ֱ�Ϊ���������Ͳ���������Э����(�˷��̵�״ֻ̬��һά��������Э������ͬ) 

v=randn(1,N);%��������
R=var(v);

% ������ʵ״̬
x_true(1)=0;%״̬x_true��ʼֵ
A=1;%aΪ״̬ת���󣬴˳�������ȡ1
for k=2:N
    x_true(k)=A*x_true(k-1)+w(k-1);  %ϵͳ״̬���̣�kʱ�̵�״̬����k-1ʱ��״̬����״̬ת������������˴�������ϵͳ�Ŀ�������
end


% ����ʵ״̬�õ��������ݣ� �������ݲ����ܱ�������������ݣ� �������ǲ��ɼ���
z = cur_rssi;

% ��ʼ Ԥ��-���¹���

% x_predict: Ԥ����̵õ���x
% x_update:���¹��̵õ���x
% P_predict:Ԥ����̵õ���P
% P_update:���¹��̵õ���P

%��ʼ����� �� ��ʼλ��
x_update(1)=x_true(1);%s(1)��ʾΪ��ʼ���Ż�����
P_update(1)=0;%��ʼ���Ż�����Э����

for t=2:N
    %-----1. Ԥ��-----
    %-----1.1 Ԥ��״̬-----
    x_predict(t) = A*x_update(t-1); %û�п��Ʊ���
    %-----1.2 Ԥ�����Э����-----
    P_predict(t)=A*P_update(t-1)*A'+Q;%p1Ϊһ�����Ƶ�Э�����ʽ��t-1ʱ�����Ż�����s��Э����õ�t-1ʱ�̵�tʱ��һ�����Ƶ�Э����

    %-----2. ����-----
    %-----2.1 ���㿨��������-----
    K(t)=H*P_predict(t) / (H*P_predict(t)*H'+R);%bΪ���������棬�������ʾΪ״̬����Э��������������Э����֮��(���˼���)
    %-----2.2 ����״̬-----
    x_update(t)=x_predict(t)  +  K(t) * (z(t)-H*x_predict(t));%Y(t)-a*c*s(t-1)��֮Ϊ��Ϣ���ǹ۲�ֵ��һ�����Ƶõ��Ĺ۲�ֵ֮���ʽ����һʱ��״̬�����Ż�����s(t-1)�õ���ǰʱ�̵����Ż�����s(t)
    %-----2.3 �������Э����-----
    P_update(t)=P_predict(t) - H*K(t)*P_predict(t);%��ʽ��һ�����Ƶ�Э����õ���ʱ�����Ż����Ƶ�Э����
end

% plot
%��ͼ����ɫΪ�������˲�����ɫΪ���⣬��ɫΪ״̬
%kalman�˲������þ��� ����ɫ�Ĳ��εõ���ɫ�Ĳ��Σ� ʹ֮�����ӽ���ɫ����ʵ״̬��
t=1:N;
plot(t,x_update,'r',t,z,'g')
legend('kalman','origin')
