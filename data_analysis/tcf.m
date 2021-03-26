function tcf(varargin)
% 功能: 关闭图窗
% 定义: tcf(varargin)
% 输入: 图像句柄
% 输出: none

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