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
    cur_frame = get(gcf);
    im = frame2im(cur_frame);
    imwrite(im, imgfile);
    fprintf('���浱ǰfigureΪ��%s\n', imgfile);
end
