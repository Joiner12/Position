function f_handle = show_figure(varargin)
    tcf('ShowHandle');
    % f_handle = figure('name', 'ShowHandle', 'Color', 'w', 'Visible', 'off');
    f_handle = figure('name', 'ShowHandle', 'Color', 'w', 'Visible', 'on');
    x = linspace(0, 3 * pi, 200);
    y = cos(x) + rand(1, 200);
    sz = 25;
    c = linspace(1, 10, length(x));
    scatter_axes = axes(f_handle);
    scatter(scatter_axes, x, y, sz, c, 'filled');
end
