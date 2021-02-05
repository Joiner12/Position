function [value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(value_pre,...
                                                                 vel_pre,...
                                                                 scm_pre,...
                                                                 gauge_cur)
%���ܣ��������˲�
%���壺[value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(value_pre,...
%                                                              vel_pre,...
%                                                              scm_pre,...
%                                                              gauge_cur)
%������ 
%    value_pre����һ�ο������˲�������״ֵ̬��Ӧ��ֵ
%    vel_pre����һ�ο������˲�������״ֵ̬��Ӧ���ٶ�
%    scm_pre����һ�ο������˲�������״̬�����������ؾ���ע��˲���Ϊ������Ϊϸ����
%    gauge_cur����ǰ״̬����ֵ
%�����
%    value_cur����ǰ�������˲�������״ֵ̬��Ӧ��ֵ
%    vel_cur����ǰ�������˲�������״ֵ̬��Ӧ���ٶ�
%    scm_cur����ǰ�������˲�������״̬�����������ؾ���

    t = 0.1;          %�������ڣ���λ��
    f = [1, t; 0, 1]; %(ģ��)״̬ת�ƾ���
    w = [t^2 / 2; t];   %���������������
    c = [1, 0];        %�۲����
    q = (1)^2;      %������������ؾ���
    r = (0.5)^2;      %�۲���������ؾ���

    z = gauge_cur;
    state_pre = [value_pre; vel_pre];

    state_cur = f * state_pre;               %��ģ��Ԥ�⵱ǰ״ֵ̬
    p_cur = f * scm_pre * f' + w * q * w';   %����Ԥ������ؾ���
    a = c * p_cur * c' + r;                  %������Ϣ��������ؾ���
    k = p_cur * c'* inv(a);                  %���㿨�����������
    a = z - c * state_cur;                   %������Ϣ����
    state = state_cur + k * a;               %״̬���ƣ���i....1ȥ����iʱ�̵�ֵ
    scm_cur = (eye(2) - k * c) * p_cur;      %����״̬�����������ؾ���
    value_cur = state(1);
    vel_cur = state(2);
end 