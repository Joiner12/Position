function lyric = get_lyric(varargin)
    % 导入歌词文件
    lyricfile = '';

    if any(strcmpi(varargin, 'lyrics_file'))
        lyricfile = varargin{find(strcmpi(varargin, 'lyrics_file')) + 1};
    else
        [file, path] = uigetfile('*.lrc*', 'multiselect', 'off');
        lyricfile = fullfile(path, file);
    end

    assert(isfile(lyricfile), 'lyric file does not exist');
    lyric_id = fopen(lyricfile, 'r');
    lyric = cell(0);

    while (~feof(lyric_id))
        lyric_temp = fgetl(lyric_id);

        if ~isempty(lyric_temp)
            lyric{length(lyric) + 1, 1} = lyric_temp;
        end

    end

    fclose(lyric_id);
    % parse lyric file
    if isempty(lyric)
        lyric = struct();
    else
        lyric = parse_lyric(lyric);
    end

end

function parsed_lyric = parse_lyric(line_piece)
    parsed_lyric = struct('title', '');
    lyric = strings(0);

    for k = 1:length(line_piece)
        temp = line_piece{k};

        if contains(temp, 'title:')
            parsed_lyric.title = strrep(temp, 'title:', '');
        else
            lyric(length(lyric) + 1, 1) = temp;
        end

    end

    parsed_lyric.lyric = lyric;
end
