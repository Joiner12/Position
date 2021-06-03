function distance = rssi_to_distance_quadratic_polynomial(a, b, c, rssi, varargin)
    % ����:
    %       ������ϵĶ��ζ���ʽ·�����ģ��(quadratic polynomial path loss model )������RSSI��Ӧ��·����
    % ����:
    %       distance = rssi_to_distance_quadratic_polynomial(a, b, c, rssi, varargin)
    % ����:
    %       a,������ϵ����a*x^2��
    %       b,һ����ϵ����b*x^1��
    %       c,������ϵ����c*x^0��
    %       rssi,RSSI(array)
    %       varargin:��������
    % �����
    %       distance:����(array)

    %%
    dist_temp = a .* rssi.^2 + b .* rssi + c;

    %%
    distance = dist_temp;
    % disp('rssi �� distance finished');
end
