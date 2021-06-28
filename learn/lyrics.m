function lyrics(varargin)
    global f_b1 f_t1 f_t2;
    f_main = uifigure('name', 'lyric', 'color', 'w', ...
        'Position', [100 100 512 512 * .618], 'Toolbar', 'none', ...
        'ReSize', 'off');
    % title label
    f_t1 = uilabel('Parent', f_main, ...
        'Position', [1, 512 * .618 - 35, 512, 35], 'Text', 'Title', ...
        'HorizontalAlignment', 'center', 'FontName', '┴е╩щ', 'FontSize', 20, ...
        'FontWeight', 'bold', 'backgroundcolor', 'w', 'FontColor', [0.1333 0.4392 0.4314]);
    % main lyric label
    f_t2 = uilabel('Parent', f_main, ...
        'Position', [1, 512 * .618 - 275, 512, 240], 'Text', 'Lyrics', ...
        'HorizontalAlignment', 'center', 'FontName', '┴е╩щ', 'FontSize', 20, ...
        'FontWeight', 'bold', 'backgroundcolor', 'w', 'FontColor', 'r');
    f_b1 = uibutton('Parent', f_main, ...
        'Position', [256 - 35, 512 * .618 - 310, 70, 35], 'Text', 'жд', ...
        'HorizontalAlignment', 'center', 'FontName', 'Helvetica', 'FontSize', 20, ...
        'FontWeight', 'bold', 'backgroundcolor', 'w', 'FontColor', 'r');
    f_b1.ButtonPushedFcn = @(~, ~)changeState();
end

function changeState(~, ~)
    global f_b1;

    if strcmpi(f_b1.Text, 'жд')
        playState();
    else
        resetState();
    end

end

function resetState()
    global f_b1 f_t1 f_t2 main_timer;
    f_b1.Text = 'жд';
    main_timer.stop();
end

function playState()
    global f_b1 f_t1 f_t2 main_timer;
    main_timer = timer('Name', 'ly_timer', 'Period', 10, 'TimerFcn', @(~, ~)stamp);
    main_timer.start()
    f_b1.Text = 'O';
end

function stamp(~, ~)
    global f_b1 f_t1 f_t2;
    f_t2.Text = num2str(rand());
end
