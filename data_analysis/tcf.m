function tcf(varargin)
% ����: �ر�ͼ��
% ����: tcf(varargin)
% ����: ͼ����
% ���: none

%%
if isequal(nargin,0)
    try
        close all;
    catch
        error('>> close all failed');
    end
    return;
else
    for i=1:1:length(varargin)
        try
            close(varargin{i})
        catch
%             warning('no figure name: %s show\n ', varargin{i})
        end
    end
end
end