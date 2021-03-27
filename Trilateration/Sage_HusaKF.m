function [X,e,P]=Sage_HusaKF(F,G,H,Q0,R0,X0,Z,P0,b,s);
% X   是指得到的k状态下的最优的估算值
% e   残差epsilon(k)
% P   是指更新的k状态下X对应的协方差

% F   系统参数，对于多模型系统，它们为矩阵
% G   系统参数，对于多模型系统，它们为矩阵
% H   表示协方差的转换系数
% Q0  表示系统过程的协方差初值
% R0  表示某种不确定性(传感器噪声)的协方差初值
% X0  是最优的估算值初值  
% Z   表示k 时刻状态下的观测值。
% P0  是X对应的协方差初值
% b   sage-Husa更新时用到，未用到默认
% s   2*2的单位矩阵，初值

% Sage-Husa adeptive KF

N=length(Z);
M=length(X0);
X=zeros(M,N);
X(:,1)=X0;
s=1*eye(2);
P=P0;
q0 = zeros(M,1);
r0 = 0;
q = q0;
r = r0;
Q = Q0;
R = R0;
for k=2:N
    X_est=F*X(:,k-1)+q;                  %计算一步预测估计：X(k/k-1)
    P_pre=F*P*F'+G*Q*G';               %一步预测估计的均方误差P(k/k-1)
    e(:,k)=Z(:,k)-H*X_est-r;           %计算残差epsilon(k)
    K=P_pre*H'*inv((H*P_pre*H')+R);    %k时刻的增益阵
    X(:,k)=X_est+K*e(:,k);           %k时刻的状态估计X(k)
    P = (eye(M)-K*H)*P_pre;%*(eye(M)-K*H)'+K*R*K';  %均方误差矩阵P(k)
    
% %     sage-Husa更新Q，R，q,r
%     d = (1-b)/(1-b^(k));
%     r = (1-d)*r +d*(Z(:,k)-H*X_est);
%     q = (1-d)*q +d*(X(:,k)-F*X(:,k-1));
%     R = (1-d)*R +d*(Z(:,k)*Z(:,k)'-H*P*H');
%     Q = (1-d)*Q +d*(K*e(:,k)*e(:,k)'*K'+P-F*P*F');
%    
      r = 1/k*((k-1)*r +Z(:,k)-H*X_est);
    
      q = 1/k*((k-1)*q+X(:,k)-F*X(:,k-1));
    
      R = 1/k*((k-1)*R+Z(:,k)*Z(:,k)'-H*P*H');
     
      Q = 1/k*((k-1)*Q+K*e(:,k)*e(:,k)'*K'+P-F*P*F');
%     
end