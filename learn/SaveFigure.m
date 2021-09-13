%% different ways to save matlab figure
clc;
disp('different ways to save matlab figure')
tar_folder = 'D:\Code\BlueTooth\pos_bluetooth_matlab\learn\figuretemp';
dir_detail = dir(tar_folder);

tcf('figure_save-1');

x = linspace(0, 1, 10);
y = [x; x .* x; sin(x); cos(x); tan(x)].';
createfigure(x, y)
set(gcf, 'PaperPositionMode', 'auto')
% imwrite
imgfiles_1 = fullfile(tar_folder, 'save-imwrite-1.png');
SaveFigure2Img(imgfiles_1)
% saveas
saveas(gcf, fullfile(tar_folder, 'save-imwrite-2.png'))
% print
print(gcf, '-opengl', fullfile(tar_folder, 'save-imwrite-3.png'), '-dpng', '-r0')

%%
function SaveFigure2Img(imgfile, varargin)
    % 功能:
    %       将当前figure保存为image;
    % 定义:
    %       SaveFigure2Img(imgfile,varargin)
    % 输入:
    %       imgfile,目标image全路径,e.g:D:/xx/A.png
    %       varargin,保留参数
    % 输出:
    %       none

    %%
    cur_frame = getframe(gcf);
    im = frame2im(cur_frame);
    imwrite(im, imgfile);
    fprintf('保存当前figure为：%s\n', imgfile);
end

function createfigure(X1, YMatrix1)
    %CREATEFIGURE1(X1, YMATRIX1)
    %  X1:  x 数据的矢量
    %  YMATRIX1:  y 数据的矩阵
    % eg: X1 = [1,2,3]
    %     YMatrix1 = [[1,2,3],[2,3,4]]
    %  由 MATLAB 于 02-May-2020 13:14:38 自动生成

    % 创建 figure
    figure1 = figure('Name', 'figure_save-1', 'Color', [1 1 1]);
    colormap(hot);

    % 创建 axes
    axes1 = axes('Parent', figure1, 'Position', [0.1 0.1 0.8 0.8]);
    hold(axes1, 'on');

    % 使用 plot 的矩阵输入创建多行
    plot1 = plot(X1, YMatrix1, 'MarkerSize', 3, 'LineWidth', 1, 'Parent', axes1);
    set(plot1(1), 'DisplayName', '方法1', 'Marker', '+');
    set(plot1(2), 'DisplayName', '方法2', 'Marker', '>');
    set(plot1(3), 'DisplayName', '方法3', 'Marker', '*');
    set(plot1(4), 'DisplayName', '方法4', 'Marker', 'hexagram');
    set(plot1(5), 'DisplayName', '方法5', 'Marker', '.');

    % 创建 xlabel
    xlabel('迭代次数', 'FontSize', 8);

    % 创建 ylabel
    ylabel('准确率%', 'BackgroundColor', [1 1 1], 'LineStyle', 'none', ...
        'EdgeColor', [0 0 0], ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 8);

    % 取消以下行的注释以保留坐标轴的 X 范围
    %xlim(axes1, [1 22]);
    % 取消以下行的注释以保留坐标轴的 Y 范围
    %ylim(axes1, [0.2 1]);
    box(axes1, 'on');
    % 设置其余坐标轴属性
    set(axes1, 'FontSize', 8);
    % 创建 legend
    legend1 = legend(axes1, 'show');
    set(legend1, ...
        'Position', [0.6 0.2 0.1 0.1], ...
        'FontSize', 8);
end
