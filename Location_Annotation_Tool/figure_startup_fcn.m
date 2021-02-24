function cfg_info = figure_startup_fcn(f,workspace_folder)
% ����:
%       ����ͼ���ص�����(ģ��)
%       1.��ȡ�ļ���./LocationToolConfig/ltc.cfg�����ļ������������Ϣ;
% ����: figure_startup_fcn(workspace_folder)
% ����: 
%       workspace_folder:���ű�����·��
%       f:ͼ�����
% ���: cfg_info:�����ļ���Ϣ

%% ���������ļ�·��
disp('�������ڣ������ļ���')
if ~isfolder(fullfile(workspace_folder,'LocationToolConfig'))
    [status, msg, msgID] = mkdir('LocationToolConfig');
    if ~isequal(status,1)
        disp({msg,msgID});
    end
end

%% ��������ļ�
cfg_info = cell(0);
Config_File = fullfile('LocationToolConfig','ltc.cfg');
if isfile(Config_File)
    Config_File_Id = fopen(Config_File,'r');
    info_cnt = 0;
    while ~feof(Config_File_Id)
        line_temp = fgetl(Config_File_Id);
        info_cnt = info_cnt + 1;
        cfg_info{info_cnt,1} = line_temp;
    end
    fclose(Config_File_Id);
else
    Config_File_Id = fopen(Config_File,'w+');
    fprintf(Config_File_Id,'this is a config files');
    fclose(Config_File_Id);
end

end