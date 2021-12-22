function [roc_x, roc_y] = error_roc(x, N, varargin)
    % 功能:
    %       求解ROC值
    % 输入:
    %       x,待求解数据数组
    %       N,步长
    %       varargin,保留参数
    % 输出：
    %       roc_x,步长数组
    %       roc_y,ROC
    %
    gap_x = linspace(0, max(x) * 1.1, N);
    y = zeros(size(gap_x));
    len_x = length(x);

    for k = 1:N
        temp = x(x <= gap_x(k)); % 小于阈值
        y(k) = length(temp) / len_x;
    end

    roc_y = y;
    roc_x = gap_x;
end
