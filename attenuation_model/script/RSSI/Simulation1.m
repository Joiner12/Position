%�ű�ڵ�λ�ڵȱ������ζ���ķ���
clc
clear all
%A,B,CΪ����ѡ�����ű�ڵ�,�ڵ�������֪(Ϊ���ڷ��漰��֤,�����в��õĵȱ�������)
for t = 1:5
    A = [0, 0];
    B = [5 * t, 5 * t * sqrt(3)];
    C = [10 * t, 0];
    nums = [A(1), A(2), B(1), B(2), C(1), C(2)];
    p = min(nums);
    q = max(nums);
    L = sqrt((A(1) - C(1))^2 + (A(2) - C(2))^2);
    m = 5;
    %������[p,q]��������ȷֲ������������
    %������һ��m��2�е��п������ڵȱ������������ڵ�����
    numbox = p + (q - p) * rand(m, 2);

    %������ֵ,���ո��ݼ��㽫������ɵĵ������ڵȱ������������ڵ����������µľ���
    n = 1;

    for i = 1:m
        dA(i) = sqrt((numbox(i, 1) - A(1))^2 + (numbox(i, 2) - A(2))^2);
        dB(i) = sqrt((numbox(i, 1) - B(1))^2 + (numbox(i, 2) - B(2))^2);
        dC(i) = sqrt((numbox(i, 1) - C(1))^2 + (numbox(i, 2) - C(2))^2);
        %��ȷʵ�ڵȱ������������ڵ��������P_position����
        if (dA(i) <= L) & (dB(i) <= L) & (dC(i) <= L)
            P_position(n, 1) = numbox(i, 1);
            P_position(n, 2) = numbox(i, 2);
            n = n + 1;
        end

    end

    %NΪ������ɵĵ������ڵȱ������������ڵĵ�(���Ե�)�ĸ���
    N = n - 1

    if N == 0
        disp('��ȡ�����������һ���ڵȱ���������,������mֵ�������г���.')
        return
    end

    %������Ե������������ʵ�ʾ���
    %disΪN��3�еľ���,���ڴ��N�����Ե�ֱ𵽵ȱ���������������A,B,C��ʵ�ʾ���
    for i = 1:N
        dis(i, 1) = sqrt((P_position(i, 1) - A(1))^2 + (P_position(i, 2) - A(2))^2);
        dis(i, 2) = sqrt((P_position(i, 1) - B(1))^2 + (P_position(i, 2) - B(2))^2);
        dis(i, 3) = sqrt((P_position(i, 1) - C(1))^2 + (P_position(i, 2) - C(2))^2);
    end

    %���ݺ���Distance������Ե�����������Ĳ��Ծ���(������˥������������)
    %dis_testΪN��3�еľ���,���ڴ��N�����Ե�ֱ𵽵ȱ���������������A,B,C�Ĳ��Ծ���
    a = 7; %��RSSI����T-R����ʱʹ�õĲ���

    for i = 1:N
        dis_test(i, 1) = Distance(dis(i, 1), a);
        dis_test(i, 2) = Distance(dis(i, 2), a);
        dis_test(i, 3) = Distance(dis(i, 3), a);
    end

    %���ݺ���Triangle����õĲ��Ծ�����ж�λ
    %P_calculateΪN��2�еľ���,���ڴ�Ŷ�λ���N������
    for i = 1:N
        P_temp = Triangle(A, B, C, dis_test(i, 1), dis_test(i, 2), dis_test(i, 3));
        P_calculate(i, 1) = P_temp(1);
        P_calculate(i, 2) = P_temp(2);
    end

    %���ڲ��Ծ��������ʵ���������,���Ǽ����е���Բ�п����޽���,���·�����ʵ��.
    %����P_calculate�л��������.�ڲ�����������ʵ������,���ȡ��ʵ���������һ����
    for i = 1:N
        P_calculate_real(i, 1) = real(P_calculate(i, 1));
        P_calculate_real(i, 2) = real(P_calculate(i, 2));
    end

    %�ԱȲ��Ե�Ķ�λ������ʵ������֮������
    P_position;
    P_calculate;
    P_calculate_real;
    %���㶨λ�������ʵ����֮��ľ������ƽ��ֵe_average(���Ե�ȸ���)
    e_sum = 0;

    for i = 1:N
        e = sqrt((P_calculate_real(i, 1) - P_position(i, 1))^2 + (P_calculate_real(i, 2) - P_position(i, 2))^2);
        e_sum = e_sum + e;
    end

    e_average = e_sum / N;
    e_average_percent = e_average / L;

    e_average_box(t) = e_average
    e_average_percent_box(t) = e_average_percent
end

%% 
x = [1:5:25];
e_average_box(t) = e_average;
y = e_average_box(t);
tcf('simulator-rssi'); figure('name', 'simulator-rssi');
plot(x, y, 'b-')
