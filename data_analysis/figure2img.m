function figure2img(f, imgfile, varargin)
    % ����:
    %       ����ͼ��Ϊͼ���ļ�
    % ���壺
    %       function figure2img(f,varargin)
    % ����:
    %       f,ͼ�����
    %       imgfile,ͼ���ļ�����(e.g:D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\pic.png)
    %       varargin,��������
    % �����
    %       none
    %

    %%
    % if isa(f, 'hanlde')
    % end
    cur_frame = getframe(f);
    imwrite(frame2im(cur_frame), imgfile);
    fprintf('image file:%s\n', imgfile);

end
