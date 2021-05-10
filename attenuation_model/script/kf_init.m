function kf_params = kf_init(Px, Py, Vx, Vy, varargin)
    % ���ܣ�
    %       kalman�˲�����ʼ��
    % ����:
    %       kf_params = kf_init(Px, Py, Vx, Vy)
    % ����:
    %       Px,��ʼX������(m)
    %       Py,...Y..
    %       Vx,��ʼX�᷽���ٶ�(m/s)
    %       Vy,..Y..
    % �����
    %       kf_params,kalman����������������
    % ģ�Ͷ��壺
    % X_k = A*X_{k-1} + B*u_{k} + Q
    % Z_k = H*X_k + R

    %%
    kf_params.B = 0; % �������
    kf_params.u = 0; % ϵͳ����
    kf_params.K = NaN; % ���������������ʼ��
    kf_params.z = NaN; % �����ʼ����ÿ��ʹ��kf_update֮ǰ��Ҫ����۲�ֵz
    kf_params.P = zeros(4, 4); % ��ʼP��Ϊ0

    % ��ʼ״̬��ʹ�ù۲�ֵ���г�ʼ����Vx��Vy��ʼΪ0;
    kf_params.x = [Px; Py; Vx; Vy];

    % ״̬ת�ƾ���A
    kf_params.A = eye(4) + diag(ones(1, 2), 2);

    %{
    Ԥ������Э�������Q������Ԥ������ϵ���һ����˹������Э�������ΪQ
    ��Сȡ���ڶ�Ԥ����̵����γ̶ȡ�
    ���磬������Ϊ�˶�Ŀ����y���ϵ��ٶȿ��ܲ����٣���ô���԰�����ԽǾ�������һ��ֵ����
    ��ʱϣ�������Ĺ켣��ƽ�������԰��������С
    %}
    kf_params.Q = diag(ones(4, 1) * 0.01);

    % �۲����H
    kf_params.H = eye(2, 4);

    % �۲�����Э�������R������۲�����ϴ���һ����˹������Э�������ΪR
    kf_params.R = diag(ones(2, 1) * 4); 
end
