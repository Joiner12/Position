function cfg_info = figure_startup_fcn(f,workspace_folder)
% 功能:
%       启动图窗回调函数(模拟)
%       1.读取文件夹./LocationToolConfig/ltc.cfg配置文件，填充配置信息;
% 定义: figure_startup_fcn(workspace_folder)
% 输入: 
%       workspace_folder:主脚本运行路径
%       f:图窗句柄
% 输出: cfg_info:配置文件信息

%% 设置配置文件路径
disp('启动窗口，配置文件。')
if ~isfolder(fullfile(workspace_folder,'LocationToolConfig'))
    [status, msg, msgID] = mkdir('LocationToolConfig');
    if ~isequal(status,1)
        disp({msg,msgID});
    end
end

%% 检查配置文件
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