function check_model_tool()
    A = -17.91;
    b = 3.363;
    global f_main;
    f_main = uifigure('name', 'lyric', 'color', 'w', ...
        'Position', [100 100 512 512 * .618], 'Toolbar', 'none', ...
        'ReSize', 'on', 'DeleteFcn', @(f_main, ~)closefcn(f_main));
end

function closefcn(~, ~)
    clear global f_main;
    disp('close figure');
end
