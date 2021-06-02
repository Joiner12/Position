function rssi_kf = kalman_cmp(rssi)
    N = length(rssi); %ȡ200����
    w = randn(1, N);
    % R��Q�ֱ�Ϊ���������Ͳ���������Э����
    % (�˷��̵�״ֻ̬��һά��������Э������ͬ)
    Q = var(w);
    R = var(rssi);

    %% ������ʵ״̬
    x_true = mean(rssi) * ones(size(rssi));
    A = 1; % aΪ״̬ת���󣬴˳�������ȡ1

    %% ����ʵ״̬�õ��������ݣ� �������ݲ����ܱ�������������ݣ� �������ǲ��ɼ���
    H = 1;
    z = rssi; %���ⷽ�cΪ�������ͬa��ȡΪһ����

    %% Ԥ��-���¹���

    % x_predict: Ԥ����̵õ���x
    % x_update:���¹��̵õ���x
    % P_predict:Ԥ����̵õ���P
    % P_update:���¹��̵õ���P

    %��ʼ����� �� ��ʼλ��
    x_update(1) = x_true(1); %s(1)��ʾΪ��ʼ���Ż�����
    P_update(1) = 0; %��ʼ���Ż�����Э����
    for t = 2:N

        x_predict(t) = A * x_update(t - 1); %û�п��Ʊ���

        P_predict(t) = A * P_update(t - 1) * A' + Q;

        k(t) = H * P_predict(t) / (H * P_predict(t) * H' + R);
        % bΪ���������棬�������ʾΪ״̬����Э��������������Э����֮��(���˼���)

        x_update(t) = x_predict(t) + K(t) * (z(t) - H * x_predict(t));

        P_update(t) = P_predict(t) - H * K(t) * P_predict(t);
    end

    rssi_kf = x_update;


end
