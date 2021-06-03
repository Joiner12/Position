function rssi_kf = kalman_filter_rssi(rssi, Q, R, varargin)
    % ����:
    %       ��rssi����kalman�˲�
    % ����:
    %       rssi_kf = kalman_filter_rssi(rssi, Q, R, varargin)
    % ����:
    %       rssi,rssi����;
    %       Q,��������Э����(����);
    %       R,�۲�����Э����(����);
    %       varargin,���Ų���;
    % ���:
    %       �˲����rssi����;

    % ϵͳ״̬�������
    A = 1; % ״̬ת��(����)
    B = 0; % ����(����)
    H = 1; % �۲�(����)
    Pk_p = zeros(size(rssi)); % �������Э����
    Uk = zeros(size(rssi)); % ϵͳ����
    Xk = zeros(size(rssi)); % ����״̬����ֵ
    K = zeros(size(rssi)); % kalman����
    Zk = rssi; % ϵͳ�۲�ֵ

    for j = 1:length(rssi)
        % �״ε���������ʼ��
        if isequal(j, 1)
            Xk(j) = Zk(j);
        else
            xk_ = A * Xk(j - 1) + B * Uk(j); % ϵͳ״̬Ԥ��ֵ
            pk_ = A * Pk_p(j - 1) * A' + Q; % Ԥ��Э����(����)
            % K(j) = pk_ * H' * inv(H * pk_ * H' + R); % kalman����
            K(j) = pk_ * H' / (H * pk_ * H' + R); % kalman����
            Xk(j) = xk_ + K(j) * (Zk(j) - H * xk_); % ���Ź���ֵ
            Pk_p(j) = (eye(1) - K(j) * H) * pk_; % ���º������Э����(����)
        end

    end

    rssi_kf = Xk;
    % ��ͼ
    if any(strcmpi(varargin, 'figure'))
        serial_x = [1:1:length(rssi)];
        tcf('kalman-1');
        figure('name', 'kalman-1', 'color', 'white');
        subplot(2, 1, 1)
        plot(serial_x, Zk, 'LineWidth', 1.5)
        hold on
        plot(serial_x, Xk, 'LineWidth', 1.5)
        legend('ԭʼ����', '�˲�����')
        subplot(2, 1, 2)
        title('kalman gain')
        plot(serial_x, K, 'LineWidth', 1.5)
    end

end
