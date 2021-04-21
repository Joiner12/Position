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
    cur_frame = get(gcf);
    im = frame2im(cur_frame);
    imwrite(im, imgfile);
    fprintf('保存当前figure为：%s\n', imgfile);
end
