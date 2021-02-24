function figure_closereq(f)
% 功能:
%       
% 定义:
%       
% 输入:
%       
% 输出:
%   
selection = questdlg('Close the figure window?',...
    'Confirmation',...
    'Yes','No','Yes');
switch selection
    case 'Yes'
        delete(f)
    case 'No'
        return
end
end