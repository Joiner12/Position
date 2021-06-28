function lyrics_roll(varargin)
    % 导入歌词文件
    lyricfile = '';

    if any(strcmpi(varargin, 'lyrics_file'))
        lyricfile = varargin{find(strcmpi(varargin, 'lyrics_file')) + 1};
    else
        [file, path] = uigetfile('*.lrc*', 'multiselect', 'off');
        lyricfile = fullfile(path, file);
    end

    assert(isfile(lyricfile), 'lyric file does not exist');
    lyric_id = open(lyricfile, 'r');
    lyric = cell(0);

    while (~eof(lyric_id))
        lyric{length(lyric) + 1, :} = fgetl(lyric_id);
    end

    fclose(lyric_id);
end

function parsed_lyric = parse_lyric(line_piece)
    parsed_lyric = cell(0);

    if ~ischar(line_piece)
        error('line is not char');
    end

end
