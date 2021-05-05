function figure2img(f, imgfile, varargin)
    % 功能:
    %       保存图窗为图像文件
    % 定义：
    %       function figure2img(f,varargin)
    % 输入:
    %       f,图窗句柄
    %       imgfile,图像文件名字(e.g:D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\pic.png)
    %       varargin,保留参数
    % 输出：
    %       none
    %

    %%
    % if isa(f, 'hanlde')
    % end
    cur_frame = getframe(f);
    imwrite(frame2im(cur_frame), imgfile);
    fprintf('image file:%s\n', imgfile);

end
