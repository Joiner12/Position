%%
%{
https: // blog.csdn.net / qq_17119267 / article / details / 103441461
https: // blog.csdn.net / qq_43499622 / article / details / 103055593
%}

%kalman�˲���
clc %���
N = 200; %���ݸ���N
w(1) = 0; %wΪԤ��ģ�͵Ĺ�������
w = randn(1, N) %randn()����������󣬷�����̬�ֲ�
x(1) = 0; %��ʼֵ
f = 1; %aΪ����1�е�״̬ת�ƾ�������Ϊһά����

%x��Ԥ��ֵ
for k = 2:N;
    x(k) = f * x(k - 1) + w(k - 1); %����1��Ϊx���Ʋ�ֵ
end

%�۲첻ȷ����
V = randn(1, N); %VΪ�۲�������randn()����������󣬷�����̬�ֲ�
q1 = std(V); %����һ��������ÿ�ж�Ӧ�ı�׼���������
R = q1.^2; % R ����ʾ�۲��еĲ�ȷ���ԣ�Э�������

%ʵ�ʹ۲�ֵY
H = 0.4; %HΪ������H(k)
y = H * x + V; %YΪʵ�ʹ۲�ֵ

%Ԥ�ⲻȷ����
q2 = std(w); %����һ��������ÿ�ж�Ӧ�ı�׼�����������Ԥ��ģ��
Q = q2.^2; % Q Ԥ��ģ�ͱ����������Э�������

%x������ֵ�����������˲���ֵ��
p(1) = 0; %Э������� ����ֵ������һ��ʱ�̵Ĳ�ȷ����
s(1) = 0; %����ֵ��ֵ

for t = 2:N;
    p1(t) = f.^2 * p(t - 1) + Q; %����2��p1(t)Э������� ��-������һ״̬�Ʋ����
    k(t) = H * p1(t) / (H.^2 * p1(t) + R); %����3 ��k(t)Ϊ������ϵ��
    s(t) = f * s(t - 1) + k(t) * (y(t) - f * H * s(t - 1)); %����4�����ݹ���ֵ��������
    p(t) = p1(t) - H * k(t) * p1(t); %����5��p(t)ΪЭ������� ����������ֵ�������ֲ����и���
end

%������ͼ
t = 1:N;
plot(t, s, 'r', t, y, 'g', t, x, 'b');
%��ɫ���ߣ�x������ֵ
%��ɫ���ߣ�x��ʵ�ʹ۲�ֵ
%��ɫ���ߣ�x��Ԥ��ֵ

%%

%��ʼ������
N = 120; %���������
A = 1;
B = 1;
H = 1;
Q = 0.01;
R = 0.25;
W = sqrt(Q) * randn(1, N);
V = sqrt(R) * randn(1, N);
CON = 25; %�¶���ʵֵ
%����ռ�
X = zeros(1, N);
Z = zeros(1, N);
Xkf = zeros(1, N);
P = zeros(1, N);
X(1) = 25.1;
P(1) = 0.01;
Z(1) = 24.9;
Xkf(1) = Z(1);
I = eye(1);

%kalman����
for k = 2:N
    X(k) = A * X(k - 1) + B * W(k);
    Z(k) = H * X(k) + V(k);
    X_pre(k) = A * Xkf(k - 1);
    P_pre(k) = A * P(k - 1) * A' + Q;
    Kg = P_pre(k) / (H * P_pre(k) * H' + R);
    Xkf(k) = X_pre(k) + Kg * (Z(k) - H * X_pre(k));
    P(k) = (I - Kg * H) * P_pre(k);
end

%������
Err_Messure = zeros(1, N);
Err_Kalman = zeros(1, N);

for k = 1:N
    Err_Messure(k) = Z(k) - X(k);
    Err_Kalman(k) = Xkf(k) - X(k);
end

t = 1:N;
figure;
plot(t, CON * ones(1, N), '-b', t, X, '-r', t, Z, 'g+', t, Xkf, '-k');
legend('����ֵ', '��ʵֵ', '����ֵ', 'kalman����ֵ');
xlabel('����ʱ��');
ylabel('�¶�');
title('Kalman Filter Simulation');

figure;
plot(t, Err_Messure, '-b', t, Err_Kalman, '-k');
legend('�������', 'kalman���');
xlabel('����ʱ��');
