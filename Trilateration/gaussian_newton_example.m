close all;
clc;

a=1;b=2;c=1;              %������ϵ��
x=(0:0.01:1)';
w=rand(length(x),1)*2-1;   %��������
y=exp(a*x.^2+b*x+c)+w;     %��������ģ��

pre=rand(3,1);      %����1
for i=1:1000

    f = exp(pre(1)*x.^2+pre(2)*x+pre(3));
    g = y-f;                    %����2�е����

    p1 = exp(pre(1)*x.^2+pre(2)*x+pre(3)).*x.^2;    %��a��ƫ��
    p2 = exp(pre(1)*x.^2+pre(2)*x+pre(3)).*x;       %��b��ƫ��
    p3 = exp(pre(1)*x.^2+pre(2)*x+pre(3));          %��c��ƫ��
    J = [p1 p2 p3];             %����2�е��ſ˱Ⱦ���

    delta = inv(J'*J)*J'* g;    %����3��inv(J'*J)*J'ΪH����

    pcur = pre+delta;           %����4
    if norm(delta) <1e-16
        break;
    end
    pre = pcur;
end

figure('Color',[1 1 1]);
scatter(x,y,'filled')
hold on;
plot_py(x,exp(a*x.^2+b*x+c),'r');
hold on
plot_py(x,exp(pre(1)*x.^2+pre(2)*x+pre(3)),'g');
legend({'origin';'final';'pre'})
%�Ƚ�һ��
[a b c]
pre'