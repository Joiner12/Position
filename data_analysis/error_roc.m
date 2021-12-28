function [roc_x, roc_y] = error_roc(x, N, varargin)
    % ����:
    %       ���ROCֵ
    % ����:
    %       x,�������������
    %       N,����
    %       varargin,��������
    % �����
    %       roc_x,��������
    %       roc_y,ROC
    %
    gap_x = linspace(0, max(x) * 1.1, N);
    y = zeros(size(gap_x));
    len_x = length(x);

    for k = 1:N
        temp = x(x <= gap_x(k)); % С����ֵ
        y(k) = length(temp) / len_x;
    end

    roc_y = y;
    roc_x = gap_x;
end
