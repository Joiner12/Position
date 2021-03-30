% function block_pos = area_divider(varargin)
% 功能:
%       根据历史数据对定位区域进行划分
% 定义:
%       function block_pos = area_divider(varargin)
% 输入:
%       varargin
% 输出:
%       block_pos:定位区域(1、2、3)

%%

%读取待定位数据
files_data = data_import();

%提取各文件的信标数据及真值
[file_ap_msg, ~] = extract_files_apmsg_truepos(files_data, 0);

%获取环境特征
env_feat = tencent_lib_environment();

%获取信标信息
beacon = hlk_beacon_location();

disp('数据导入完成');

block_pos = 1;
%%
% 初始化结构体
ap_name = {'onepos_HLK_1', 'onepos_HLK_2', 'onepos_HLK_3', ...
            'onepos_HLK_4', 'onepos_HLK_5', 'onepos_HLK_6', ...
            'onepos_HLK_7', 'onepos_HLK_8'};

buffer_size = 5; % 缓存区大小
buffer = zeros(1, buffer_size);
ap_rssi = {buffer, buffer, buffer, buffer, buffer, ...
            buffer, buffer, buffer};
stored_data = struct('name', ap_name, 'mac', '', ...
    'rssi', ap_rssi, 'lat', 0, 'lon', 0); % 缓存ap(t-n)数据
tcf('shows'); figure('name', 'shows', 'color', 'w');

for j = 1:1:length(file_ap_msg)
    file_ap_temp = file_ap_msg{j};

    for k = 1:1:length(file_ap_temp)
        fprintf('----------------------%0.0f帧----------------------\n', k);
        frame_temp = file_ap_temp{k};

        for ki = 1:1:length(frame_temp)
            cur_apinfo = frame_temp(ki);
            index = find(strcmp(cur_apinfo.name, ap_name));
            cur_rssi = cur_apinfo.rssi;
            cur_rssi = reshape(cur_rssi, [length(cur_rssi), 1]);
            stored_data(index).rssi = [cur_rssi, ...
                                        stored_data(index).rssi(1:end - length(cur_rssi))];
            stored_data(index).lat = cur_apinfo.lat;
            stored_data(index).lon = cur_apinfo.lon;
        end

        % figure
        cla;
        hold on
        for kj = 1:1:length(stored_data)
            markers = ['*','<','>','s','d','+','x','p'];
            plot(stored_data(kj).rssi,'Linewidth',1.5,'marker',markers(kj));
        end

        hold off
        ap_leg = strrep(ap_name, '_', '-');
        legend(ap_leg)
        pause(1);
    end

end

% end
