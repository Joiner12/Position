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
    'rssi', ap_rssi, 'lat', 0, 'lon', 0, 'all_rssi', -90); % 缓存ap(t-n)数据

figure_flag = true;

for j = 1:1:length(file_ap_msg)
    file_ap_temp = file_ap_msg{j};

    for k = 1:1:length(file_ap_temp)
        fprintf('----------------------%0.0f帧----------------------\n', k);
        frame_temp = file_ap_temp{k};
        ap_got = zeros([1, 8]);

        for ki = 1:1:length(frame_temp)
            cur_apinfo = frame_temp(ki);
            index = find(strcmp(cur_apinfo.name, ap_name));
            % 只记录一次
            if isequal(ap_got(index), 0)
                ap_got(index) = 1;
                cur_rssi = cur_apinfo.rssi;
                cur_rssi = reshape(cur_rssi, [length(cur_rssi), 1]);

                stored_data(index).rssi = [cur_rssi, ...
                                            stored_data(index).rssi(1:end - length(cur_rssi))];
                % 所有历史数据
                stored_data(index).all_rssi = [stored_data(index).all_rssi, mean(cur_rssi)];
                stored_data(index).lat = cur_apinfo.lat;
                stored_data(index).lon = cur_apinfo.lon;
            end

        end

        % 填充未收集到的rssi
        ap_got = ~ap_got;
        ap_nul = find(ap_got);

        for kk = 1:1:length(ap_nul)
            stored_data(ap_nul(kk)).all_rssi = [stored_data(ap_nul(kk)).all_rssi, -90];
        end

    end

end

% end

%% 整体趋势分析
if figure_flag
    tcf('shows'); figure('name', 'shows', 'color', 'w');
    markers = ['*', '<', '>', 's', 'd', '+', 'x', 'p'];
    hold on

    for kj = 1:1:length(stored_data)
        plot(stored_data(kj).all_rssi, 'Linewidth', 1.5, 'marker', markers(kj));
    end

    hold off

    ap_leg = strrep(ap_name, '_', '-');
    legend(ap_leg)
end

%% 分段分析
if figure_flag
    scope = 10;
    ap_all_rssi = cell(0);

    for i = 1:1:length(stored_data)
        ap_all_rssi{i} = stored_data(i).all_rssi;
    end

    valid_rssi = cell(0);
    tcf('shows'); figure('name', 'shows', 'color', 'w');
    markers = ['*', '<', '>', 's', 'd', '+', 'x', 'p'];
    hold on

    for k = 1:1:int16(length(ap_all_rssi{1}) / scope)

        for i = 1:1:length(stored_data)
            ap_rssi_temp = ap_all_rssi{i};
            ap_rssi_temp = ap_rssi_temp(10 * (k - 1) + 1:10 * k);
            ap_rssi_temp = ap_rssi_temp(ap_rssi_temp ~= -90);
            valid_rssi{k, i} = ap_rssi_temp;
        end

    end

    % draw figure
    x = zeros(0);
    y = zeros(0);

    for j = 1:1:size(valid_rssi, 1)
        x = [x, linspace(1, 8, 8) + (j - 1) * 5];

        for k = 1:1:size(valid_rssi, 2)
            y((j - 1) * 8 + k) = length(valid_rssi{j, k});
        end

    end

    bar(y)
    box on
end
