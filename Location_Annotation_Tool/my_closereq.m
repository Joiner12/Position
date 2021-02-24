function my_closereq(f)
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