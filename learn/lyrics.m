function lyrics(varargin)
    global f_b1 f_t1 f_t2 main_timer;
    % timer
    main_timer = timer('Name', 'ly_timer', 'Period', 1, ...
        'TimerFcn', @(~, ~)stamp(), 'ExecutionMode', 'fixedRate');

    f_main = uifigure('name', 'lyric', 'color', 'w', ...
        'Position', [100 100 512 512 * .618], 'Toolbar', 'none', ...
        'ReSize', 'off', 'DeleteFcn', @(f_main, ~)closefcn(f_main));
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
    global f_b1 main_timer;
    stop(main_timer);
    f_b1.Text = 'жд';
end

function playState()
    global f_b1 f_t1 main_timer;
    global lyric_index lyric;
    lyric_index = 1;
    % get lyric
    lyric = get_lyric('lyrics_file', ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\learn\international.lrc');
    f_t1.Text = lyric.title;
    start(main_timer);
    f_b1.Text = 'O';
    % load lyric file

end

function stamp(~, ~)
    global f_t2;
    global lyric_index lyric;
    temp_lyric = lyric.lyric;

    f_t2.Text = temp_lyric(lyric_index);

    if lyric_index == length(temp_lyric)
        lyric_index = 1;
    else
        lyric_index = lyric_index + 1;
    end

end

function closefcn(f, ~)
    global main_timer;
    stop(main_timer);
    clear global main_timer f_b1 f_t2 f_t1;
    delete(timerfind('name', 'ly_timer'));
    delete(f);
end
