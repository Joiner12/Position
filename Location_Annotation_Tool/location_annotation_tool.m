function location_annotation_tool
% 功能:
%      为蓝牙节点采集的数据添加位置标签(经纬度)UI工具
% 定义: location_annotation_tool
% 输入:
%       None
% 输出:
%       None

%% Create UIFigure
UIFigure = uifigure;
UIFigure.Position = [100 100 640 480];
UIFigure.Name = 'Ananotation Tool';
% UIFigure.CloseRequestFcn = @(f, event)figure_closereq(f);
% UIFigure.CreateFcn = @(f,filepath,event)figure_startup_fcn(f,filepath);
% Create TabGroup
TabGroup = uitabgroup(UIFigure);
TabGroup.Position = [1 1 640 480];

% Create Tab
Tab = uitab(TabGroup);
Tab.Title = 'Tab';
Tab.BackgroundColor = [0.149 0.149 0.149];

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

% Create button_mark
button_mark = uibutton(Tab, 'push');
button_mark.BackgroundColor = [0 0.451 0.7412];
button_mark.FontSize = 14;
button_mark.FontWeight = 'bold';
button_mark.FontColor = [0 1 0];
button_mark.Position = [269 44 102 46];
button_mark.Text = '一键标注';

% Create label_mark_info
label_mark_info = uilabel(Tab);
label_mark_info.BackgroundColor = [0.502 0.502 0.502];
label_mark_info.HorizontalAlignment = 'center';
label_mark_info.FontSize = 14;
label_mark_info.FontWeight = 'bold';
label_mark_info.FontColor = [1 1 1];
label_mark_info.Position = [22 148 102 46];
label_mark_info.Text = {'设置文件将'; '标注的经纬度'};

% Create label_mark_lat
label_mark_lat = uilabel(Tab);
label_mark_lat.HorizontalAlignment = 'center';
label_mark_lat.FontName = '黑体';
label_mark_lat.FontSize = 14;
label_mark_lat.FontWeight = 'bold';
label_mark_lat.FontColor = [0.9412 0.9412 0.9412];
label_mark_lat.Position = [203 160 34 22];
label_mark_lat.Text = '经度';

% Create editFiled_lat
editFiled_lat = uieditfield(Tab, 'numeric');
editFiled_lat.Limits = [0 360];
editFiled_lat.HorizontalAlignment = 'left';
editFiled_lat.ValueDisplayFormat = '%.7f';
editFiled_lat.FontSize = 14;
editFiled_lat.FontWeight = 'bold';
editFiled_lat.Position = [249 160 100 22];

% Create label_select_file
label_select_file = uilabel(Tab);
label_select_file.BackgroundColor = [0.8 0.8 0.8];
label_select_file.HorizontalAlignment = 'center';
label_select_file.FontName = '微软雅黑';
label_select_file.FontColor = [0 0.451 0.7412];
label_select_file.Position = [138 360 466 46];
label_select_file.Text = 'D:\aa\bb\cc\dd\数据格式样例-蓝牙_5.txt';

% Create label_select_folder
label_select_folder = uilabel(Tab);
label_select_folder.BackgroundColor = [0.8 0.8 0.8];
label_select_folder.HorizontalAlignment = 'center';
label_select_folder.FontName = '微软雅黑';
label_select_folder.FontColor = [0 0.451 0.7412];
label_select_folder.Position = [138 254 466 46];
label_select_folder.Text = 'D:\aa\bb\cc\dd';

% Create label_mark_lon
label_mark_lon = uilabel(Tab);
label_mark_lon.HorizontalAlignment = 'center';
label_mark_lon.FontName = '黑体';
label_mark_lon.FontSize = 14;
label_mark_lon.FontWeight = 'bold';
label_mark_lon.FontColor = [0.9412 0.9412 0.9412];
label_mark_lon.Position = [427 160 34 22];
label_mark_lon.Text = '经度';

% Create editFiled_lon
editFiled_lon = uieditfield(Tab, 'numeric');
editFiled_lon.Limits = [0 360];
editFiled_lon.HorizontalAlignment = 'left';
editFiled_lon.ValueDisplayFormat = '%.7f';
editFiled_lon.FontSize = 14;
editFiled_lon.FontWeight = 'bold';
editFiled_lon.Position = [473 160 100 22];

% Create Tab2
Tab2 = uitab(TabGroup);
Tab2.Title = 'Tab2';

%% =======================callback function========================= %%
% ===================button_select_file_callback====================== %
    function button_select_file_callback(hobj,edata)
        origin_file = 'none';
        [file,path] = uigetfile({'*.txt';'*.log';'*.*'},...
            '选择需要转换的文件',...
            'MultiSelect', 'off');
        if ~isequal(file,0)
            origin_file = fullfile(path,file);
        end
        % 检查选择的文件
        if ~isfile(origin_file)
            warning('所选文件:%s 不存在,\n文件选择出错,请重新运行程序',origin_file);
        end
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
        % 需要处理过长字符串


    end


end