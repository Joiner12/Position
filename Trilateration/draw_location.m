function draw_location(rect, ccs, points, varargin)
    % 功能:
    %       绘制不同三边定位解算方法对比图
    % 定义:
    %       draw_location(rect, ccs, points, varargin)
    % 参数:
    %       rect,矩形(cell)[x,y,width,height];
    %       ccs,圆圈(cell)[x,y,r];
    %       points,点(cell)[x,y];
    %       varargin,保留参数;
    % 输出:
    %       none

    tcf('draw_location');
    figure1 = figure('name', 'draw_location');
    axes1 = axes('Parent', figure1);
    hold(axes1, 'on');
    % rectangle
    rectangle('position', rect, 'edgecolor', 'b', 'linewidth', 2);
    % circle
    line_point = zeros(0);

    for k = 1:1:length(ccs)
        circle_temp = ccs{k};
        circles(circle_temp(1), circle_temp(2), circle_temp(3), ...
            'facecolor', 'none', ...
            'edgecolor', [77, 223, 166] ./ 255, 'linewidth', 1.5)
        line_point(k, 1) = circle_temp(1);
        line_point(k, 2) = circle_temp(2);
    end

    line_point = [line_point; line_point(1, :)];
    % line
    plot(line_point(:, 1), line_point(:, 2), 'color', 'r', ...
        'linewidth', 1.5);
    scatter(line_point(:, 1), line_point(:, 2), 'markerfacecolor', [27, 155, 57] ./ 255, ...
        'markeredgecolor', [27, 155, 57] ./ 255);
    % dot
    for j = 1:1:length(points)
        point_temp = points{j};
        color_temp = rand(1, 3);
        plot(point_temp(1), point_temp(2), 'marker', '*', 'markersize', 12, ...
            'color', color_temp);
        text(point_temp(1), point_temp(2), ...
            strcat('\fontsize{16}\bf\leftarrow', num2str(j)), ...
            'HorizontalAlignment', 'left', 'color', color_temp);
    end

    axis(axes1, 'equal');
    box(axes1, 'on');
end
