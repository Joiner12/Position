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
    % ����:
    %       ����ǰfigure����Ϊimage;
    % ����:
    %       SaveFigure2Img(imgfile,varargin)
    % ����:
    %       imgfile,Ŀ��imageȫ·��,e.g:D:/xx/A.png
    %       varargin,��������
    % ���:
    %       none

    %%
    cur_frame = getframe(gcf);
    im = frame2im(cur_frame);
    imwrite(im, imgfile);
    fprintf('���浱ǰfigureΪ��%s\n', imgfile);
end

function createfigure(X1, YMatrix1)
    %CREATEFIGURE1(X1, YMATRIX1)
    %  X1:  x ���ݵ�ʸ��
    %  YMATRIX1:  y ���ݵľ���
    % eg: X1 = [1,2,3]
    %     YMatrix1 = [[1,2,3],[2,3,4]]
    %  �� MATLAB �� 02-May-2020 13:14:38 �Զ�����

    % ���� figure
    figure1 = figure('Name', 'figure_save-1', 'Color', [1 1 1]);
    colormap(hot);

    % ���� axes
    axes1 = axes('Parent', figure1, 'Position', [0.1 0.1 0.8 0.8]);
    hold(axes1, 'on');

    % ʹ�� plot �ľ������봴������
    plot1 = plot(X1, YMatrix1, 'MarkerSize', 3, 'LineWidth', 1, 'Parent', axes1);
    set(plot1(1), 'DisplayName', '����1', 'Marker', '+');
    set(plot1(2), 'DisplayName', '����2', 'Marker', '>');
    set(plot1(3), 'DisplayName', '����3', 'Marker', '*');
    set(plot1(4), 'DisplayName', '����4', 'Marker', 'hexagram');
    set(plot1(5), 'DisplayName', '����5', 'Marker', '.');

    % ���� xlabel
    xlabel('��������', 'FontSize', 8);

    % ���� ylabel
    ylabel('׼ȷ��%', 'BackgroundColor', [1 1 1], 'LineStyle', 'none', ...
        'EdgeColor', [0 0 0], ...
        'HorizontalAlignment', 'center', ...
        'FontSize', 8);

    % ȡ�������е�ע���Ա���������� X ��Χ
    %xlim(axes1, [1 22]);
    % ȡ�������е�ע���Ա���������� Y ��Χ
    %ylim(axes1, [0.2 1]);
    box(axes1, 'on');
    % ������������������
    set(axes1, 'FontSize', 8);
    % ���� legend
    legend1 = legend(axes1, 'show');
    set(legend1, ...
        'Position', [0.6 0.2 0.1 0.1], ...
        'FontSize', 8);
end
