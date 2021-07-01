function output_txt = modify_cursor_callback(obj, event_obj)
    % Display the position of the data cursor
    % obj          Currently not used (empty)
    % event_obj    Handle to event object
    % output_txt   Data cursor text string (string or cell array of strings).

    pos = get(event_obj, 'Position');
    x_text = sprintf('%.10f', pos(1));
    y_text = sprintf('%.10f', pos(2));
    output_txt = {['X: ', x_text], ...
        % 此处的pos(1)后的数字，即X轴的数据游标的显示精度位数
            ['Y: ', y_text]};
    % 此处的pos(2)后的数字，即Y轴的数据游标的显示精度位数

    % If there is a Z-coordinate in the position, display it as well
    if length(pos) > 2
        z_text = sprintf('%.10f', pos(3));
        output_txt{end + 1} = ['Z: ', z_text];
        % 此处的pos(3)后的数字，即Z轴的数据游标的显示精度位数
        fprintf('x:%s,y:%s,hei:%s\n', x_text, y_text, z_text);
    end

    % [x,y]转换为[lat,lon]
    if true
        [lat, lon] = xy_to_latlon(pos(1), pos(2), 1.832595714594046);
        fprintf('lat:%0.10f,lon:%0.10f\n', lat, lon);
    end

end
