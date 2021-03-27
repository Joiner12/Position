function location_annotation_tool
% 功能:
%      为蓝牙节点采集的数据添加位置标签(经纬度)UI工具
% 定义: location_annotation_tool
% 输入:
%       None
% 输出:
%       None

%% Create UIFigure
UIFigure = uifigure('Name','Annotation Tool',...
    'Position',[100 100 640 480],...
    'Resize','off');
% Create TabGroup
TabGroup = uitabgroup(UIFigure);
TabGroup.Position = [1 1 640 480];

% Create Tab
Tab = uitab(TabGroup);
Tab.Title = 'Tab';
Tab.BackgroundColor = [0.149 0.149 0.149];

% Create label_select_file
label_select_file = uilabel(Tab);
label_select_file.BackgroundColor = [0.8 0.8 0.8];
label_select_file.HorizontalAlignment = 'center';
label_select_file.FontName = '微软雅黑';
label_select_file.FontColor = [1 0 0];
label_select_file.Position = [138 360 466 46];
label_select_file.Text = 'no-selected-file';

% Create label_select_folder
label_select_folder = uilabel(Tab);
label_select_folder.BackgroundColor = [0.8 0.8 0.8];
label_select_folder.HorizontalAlignment = 'center';
label_select_folder.FontName = '微软雅黑';
label_select_folder.FontColor = [1 0 0];
label_select_folder.Position = [138 254 466 46];
label_select_folder.Text = 'no-selected-folder';

% Create button_select_file
button_select_file = uibutton(Tab, 'push');
button_select_file.BackgroundColor = [0 0.451 0.7412];
button_select_file.FontSize = 14;
button_select_file.FontWeight = 'bold';
button_select_file.FontColor = [1 1 1];
button_select_file.Position = [22 360 102 46];
button_select_file.Text = {'选择待标注'; '数据文件'; ''};
% button_select_file:button_select_file_callback
button_select_file.ButtonPushedFcn = @(hobj,edata)button_select_file_callback(hobj,edata);

% Create button_select_folder
button_select_folder = uibutton(Tab, 'push');
button_select_folder.BackgroundColor = [0 0.451 0.7412];
button_select_folder.FontSize = 14;
button_select_folder.FontWeight = 'bold';
button_select_folder.FontColor = [1 1 1];
button_select_folder.Position = [22 254 102 46];
button_select_folder.Text = {'设置标注后'; '文件保存路径'};
button_select_folder.ButtonPushedFcn = @(hobj,edata)button_select_folder_callback(hobj,edata);

% Create button_mark
button_mark = uibutton(Tab, 'push');
button_mark.BackgroundColor = [0 0.451 0.7412];
button_mark.FontSize = 14;
button_mark.FontWeight = 'bold';
button_mark.FontColor = [0 1 0];
button_mark.Position = [269 44 102 46];
button_mark.Text = '一键标注';
button_mark.ButtonPushedFcn = @(hobj,edata)add_lat_lon_labels_ui(hobj,edata);
% Create label_mark_info
label_mark_info = uilabel(Tab);
label_mark_info.BackgroundColor = [0.502 0.502 0.502];
label_mark_info.HorizontalAlignment = 'center';
label_mark_info.FontSize = 14;
label_mark_info.FontWeight = 'bold';
label_mark_info.FontColor = [1 1 1];
label_mark_info.Position = [22 148 102 46];
label_mark_info.Text = {'设置文件将'; '标注的经纬度'};


% Create editFiled_lat
editFiled_lat = uieditfield(Tab, 'numeric');
editFiled_lat.Limits = [0 360];
editFiled_lat.HorizontalAlignment = 'left';
editFiled_lat.ValueDisplayFormat = '%.7f';
editFiled_lat.FontSize = 14;
editFiled_lat.FontWeight = 'bold';
editFiled_lat.Position = [249 160 100 22];
editFiled_lat.ValueChangedFcn = @(hobj,edata)editFiled_lat_valuechanged(hobj,edata);

% Create editFiled_lon
editFiled_lon = uieditfield(Tab, 'numeric');
editFiled_lon.Limits = [0 360];
editFiled_lon.HorizontalAlignment = 'left';
editFiled_lon.ValueDisplayFormat = '%.7f';
editFiled_lon.FontSize = 14;
editFiled_lon.FontWeight = 'bold';
editFiled_lon.Position = [473 160 100 22];
editFiled_lon.ValueChangedFcn = @(hobj,edata)editFiled_lon_valuechanged(hobj,edata);

% Create label_mark_lon
label_mark_lon = uilabel(Tab);
label_mark_lon.HorizontalAlignment = 'center';
label_mark_lon.FontName = '黑体';
label_mark_lon.FontSize = 14;
label_mark_lon.FontWeight = 'bold';
label_mark_lon.FontColor = [0.9412 0.9412 0.9412];
label_mark_lon.Position = [427 160 34 22];
label_mark_lon.Text = '经度';

% Create label_mark_lat
label_mark_lat = uilabel(Tab);
label_mark_lat.HorizontalAlignment = 'center';
label_mark_lat.FontName = '黑体';
label_mark_lat.FontSize = 14;
label_mark_lat.FontWeight = 'bold';
label_mark_lat.FontColor = [0.9412 0.9412 0.9412];
label_mark_lat.Position = [203 160 34 22];
label_mark_lat.Text = '纬度';

% Create Tab2
Tab2 = uitab(TabGroup);
Tab2.Title = 'Tab2';
% Create ThefeatureiscomingsoonLabel
ThefeatureiscomingsoonLabel = uilabel(Tab2);
ThefeatureiscomingsoonLabel.FontName = 'Calibri';
ThefeatureiscomingsoonLabel.FontSize = 18;
ThefeatureiscomingsoonLabel.FontWeight = 'bold';
ThefeatureiscomingsoonLabel.FontColor = [0.4706 0.6706 0.1882];
ThefeatureiscomingsoonLabel.Position = [31 40 600 24];
ThefeatureiscomingsoonLabel.Text = strcat('When you ',char([55357 56384]),...
    ' the abyss, the abyss ', char([55357 56384]), ' you...');

% Create Label_3
Label_3 = uilabel(Tab2);
Label_3.HorizontalAlignment = 'center';
Label_3.FontSize = 200;
Label_3.Position = [178 107 283 266];
Label_3.Text = char([55358 56611]);

%% =======================用户数据========================= %%
userdata = struct('src_file','' ... % 源数据文件
    ,'tar_folder','' ...            % 转换后存储路径
    ,'lat',0.0 ...                  % 纬度
    ,'lon',0.0);                    % 经度

%% =======================嵌套回调========================= %%
% ===================button_select_file_callback====================== %
    function button_select_file_callback(~,~)
        origin_file = 'no-selected-file';
        [file,path] = uigetfile({'*.txt';'*.log';'*.*'},...
            '选择需要转换的文件',...
            'MultiSelect', 'off');
        if ~isequal(file,0)
            origin_file = fullfile(path,file);
        end
        
        % 检查选择的文件
        if ~isfile(origin_file)
            label_select_file.Text = origin_file;
            label_select_file.FontColor = [1 0 0];
        else
            if length(origin_file) > 60
                cnt_temp = 1;
                text_temp = cell(0);
                while cnt_temp*60 < length(origin_file)
                    text_temp{cnt_temp} = origin_file((cnt_temp-1)*60+1:cnt_temp*60-1);
                    cnt_temp = cnt_temp + 1;
                end
                text_temp{cnt_temp} = origin_file((cnt_temp-1)*60+1:end);
            else
                text_temp = origin_file;
            end
            label_select_file.Text = text_temp;
            label_select_file.FontColor = [0.00,0.45,0.74];
        end
        % 更新用户数据
        userdata.src_file = origin_file;
    end

%% =======================嵌套回调========================= %%
% ===================button_select_file_callback====================== %
    function button_select_folder_callback(~,~)
        target_folder_temp = uigetdir(pwd,'选择目标文件保存路径');
        
        if isnumeric(target_folder_temp) % 选择取消
            target_folder = 'no-selected-folder';
            label_select_folder.Text = target_folder;
            label_select_folder.FontColor = [1 0 0];
        else
            target_folder = target_folder_temp;
            if length(target_folder_temp) > 60
                cnt_temp = 1;
                text_temp = cell(0);
                while cnt_temp*60 < length(target_folder_temp)
                    text_temp{cnt_temp} = target_folder_temp((cnt_temp-1)*60+1:cnt_temp*60-1);
                    cnt_temp = cnt_temp + 1;
                end
                text_temp{cnt_temp} = target_folder_temp((cnt_temp-1)*60+1:end);
            else
                text_temp = target_folder_temp;
            end
            label_select_folder.Text = text_temp;
            label_select_folder.FontColor = [0.00,0.45,0.74];
        end
        userdata.tar_folder = target_folder;
    end

%% =======================嵌套回调========================= %%
% =====================editFiled_lat_valuechanged==================== %
    function editFiled_lat_valuechanged(hobj,~)
        userdata.lat = hobj.Value;
    end

%% =======================嵌套回调========================= %%
% =====================editFiled_lon_valuechanged==================== %
    function editFiled_lon_valuechanged(hobj,~)
        userdata.lon = hobj.Value;
    end

%% =======================嵌套回调========================= %%
% =====================editFiled_lon_valuechanged==================== %
    function add_lat_lon_labels_ui(~,~)
        % userdata = struct('src_file','' ... % 源数据文件
        %     ,'tar_folder','' ...            % 转换后存储路径
        %     ,'lat',0.0 ...                  % 纬度
        %     ,'lon',0.0);                    % 经度
        lat = userdata.lat;
        lon = userdata.lon;
        originfile = userdata.src_file;
        targetfolder = userdata.tar_folder;
        if ~isfile(originfile)
            uiwait(msgbox({'无效源文件';originfile},'Success','modal'));
            return;
        end
        if ~isfolder(targetfolder)
            uiwait(msgbox({'无效目标路径';targetfolder},'Success','modal'));
            return;
        end
        
        quest  = '开始添加标签？';
        title = sprintf('源文件:\n%s\n保存路径:\n%s\n位置标签:\n经度:%0.7f\n纬度:%.7f\n',...
            originfile,targetfolder,lat,lon);
        selection = questdlg(title,quest,'Yes','No','Yes');
        switch selection
            case 'Yes'
                % 拼接目标文件名
                src_file_temp = regexp(originfile,'\\','split');
                name_temp = strsplit(src_file_temp{end},'.');
                tar_file_name = strcat(name_temp{1},'-added_lat_lon','.',name_temp{end});
                target_file = fullfile(targetfolder,tar_file_name);
                
                add_label_to_file(lat,lon,originfile,target_file);
                fprintf('源文件:\n%s\n保存路径:\n%s\n位置标签:\n纬度:%0.7f\n经度:%.7f\n',...
                    originfile,targetfolder,lat,lon);
                uiwait(msgbox('标注完成','Success','modal'));
            case 'No'
                return
        end
    end
end