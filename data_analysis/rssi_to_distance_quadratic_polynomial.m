function distance = rssi_to_distance_quadratic_polynomial(a, b, c, rssi, varargin)
    % 功能:
    %       根据拟合的二次多项式路径损耗模型(quadratic polynomial path loss model )，计算RSSI对应的路径。
    % 定义:
    %       distance = rssi_to_distance_quadratic_polynomial(a, b, c, rssi, varargin)
    % 参数:
    %       a,二次项系数，a*x^2。
    %       b,一次项系数，b*x^1。
    %       c,常数项系数，c*x^0。
    %       rssi,RSSI(array)
    %       varargin:保留参数
    % 输出：
    %       distance:距离(array)

    %%
    dist_temp = a .* rssi.^2 + b .* rssi + c;

    %%
    distance = dist_temp;
    % disp('rssi → distance finished');
end
