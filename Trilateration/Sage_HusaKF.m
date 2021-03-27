function [X,e,P]=Sage_HusaKF(F,G,H,Q0,R0,X0,Z,P0,b,s);
% X   ��ָ�õ���k״̬�µ����ŵĹ���ֵ
% e   �в�epsilon(k)
% P   ��ָ���µ�k״̬��X��Ӧ��Э����

% F   ϵͳ���������ڶ�ģ��ϵͳ������Ϊ����
% G   ϵͳ���������ڶ�ģ��ϵͳ������Ϊ����
% H   ��ʾЭ�����ת��ϵ��
% Q0  ��ʾϵͳ���̵�Э�����ֵ
% R0  ��ʾĳ�ֲ�ȷ����(����������)��Э�����ֵ
% X0  �����ŵĹ���ֵ��ֵ  
% Z   ��ʾk ʱ��״̬�µĹ۲�ֵ��
% P0  ��X��Ӧ��Э�����ֵ
% b   sage-Husa����ʱ�õ���δ�õ�Ĭ��
% s   2*2�ĵ�λ���󣬳�ֵ

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
    X_est=F*X(:,k-1)+q;                  %����һ��Ԥ����ƣ�X(k/k-1)
    P_pre=F*P*F'+G*Q*G';               %һ��Ԥ����Ƶľ������P(k/k-1)
    e(:,k)=Z(:,k)-H*X_est-r;           %����в�epsilon(k)
    K=P_pre*H'*inv((H*P_pre*H')+R);    %kʱ�̵�������
    X(:,k)=X_est+K*e(:,k);           %kʱ�̵�״̬����X(k)
    P = (eye(M)-K*H)*P_pre;%*(eye(M)-K*H)'+K*R*K';  %����������P(k)
    
% %     sage-Husa����Q��R��q,r
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