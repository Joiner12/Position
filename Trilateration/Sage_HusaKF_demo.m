clc
clear
a=randn(1,5000)*sqrt(0.1);
y=zeros(1,5000);
y(1)=a(1);
y(2)=a(2)-0.575*a(1);
for k=3:5000
y(k)=0.0673*y(k-1)+0.1553*y(k-2)+a(k)-0.575*a(k-1);
end
y = y+sqrt(0.05)*randn(1,length(y));
figure(1)
subplot(2,1,1)
plot(a),title('a');
subplot(2,1,2)
plot(y),title('y');
b=0;
% inlitial Kalman Filter
F = [0.0673 0.1553; 1 0];
G = [1 -0.575 ; 0 0];
H = [1 0];
s=1*eye(2);
Q0=diag([0.1,0.1]);
R0 = 0.5;
P0=eye(2)*10000;
X0=[0;0];
[X,e,P]=Sage_HusaKF(F,G,H,Q0,R0,X0,y,P0,b,s);
% [X,e,P]=StdKF2(F,G,H,Q0,R0,X0,y,P0);
% plot kalman
figure(2)
t=1:length(X);
subplot(2,1,1)
plot(t,X(1,:));%yk
subplot(2,1,2)
plot(t,X(2,:));%yk-1
figure(3)
plot(t,y);
hold on
plot(t,y,'r',t,X(1,:),'b');
hold off