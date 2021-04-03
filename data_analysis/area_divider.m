% function block_pos = area_divider(varargin)
% ����:
%       ������ʷ���ݶԶ�λ������л���
% ����:
%       function block_pos = area_divider(varargin)
% ����:
%       varargin
% ���:
%       block_pos:��λ����(1��2��3)

%%

%��ȡ����λ����
files_data = data_import();

%��ȡ���ļ����ű����ݼ���ֵ
[file_ap_msg, ~] = extract_files_apmsg_truepos(files_data, 0);

%��ȡ��������
env_feat = tencent_lib_environment();

%��ȡ�ű���Ϣ
beacon = hlk_beacon_location();

disp('���ݵ������');

block_pos = 1;
%%
% ��ʼ���ṹ��
ap_name = {'onepos_HLK_1', 'onepos_HLK_2', 'onepos_HLK_3', ...
            'onepos_HLK_4', 'onepos_HLK_5', 'onepos_HLK_6', ...
            'onepos_HLK_7', 'onepos_HLK_8'};

buffer_size = 5; % ��������С
buffer = zeros(1, buffer_size);
ap_rssi = {buffer, buffer, buffer, buffer, buffer, ...
            buffer, buffer, buffer};
stored_data = struct('name', ap_name, 'mac', '', ...
    'rssi', ap_rssi, 'lat', 0, 'lon', 0, 'all_rssi', -90); % ����ap(t-n)����

figure_flag = true;

for j = 1:1:length(file_ap_msg)
    file_ap_temp = file_ap_msg{j};

    for k = 1:1:length(file_ap_temp)
        fprintf('----------------------%0.0f֡----------------------\n', k);
        frame_temp = file_ap_temp{k};
        ap_got = zeros([1, 8]);

        for ki = 1:1:length(frame_temp)
            cur_apinfo = frame_temp(ki);
            index = find(strcmp(cur_apinfo.name, ap_name));
            % ֻ��¼һ��
            if isequal(ap_got(index), 0)
                ap_got(index) = 1;
                cur_rssi = cur_apinfo.rssi;
                cur_rssi = reshape(cur_rssi, [length(cur_rssi), 1]);

                stored_data(index).rssi = [cur_rssi, ...
                                            stored_data(index).rssi(1:end - length(cur_rssi))];
                % ������ʷ����
                stored_data(index).all_rssi = [stored_data(index).all_rssi, mean(cur_rssi)];
                stored_data(index).lat = cur_apinfo.lat;
                stored_data(index).lon = cur_apinfo.lon;
            end

        end

        % ���δ�ռ�����rssi
        ap_got = ~ap_got;
        ap_nul = find(ap_got);

        for kk = 1:1:length(ap_nul)
            stored_data(ap_nul(kk)).all_rssi = [stored_data(ap_nul(kk)).all_rssi, -90];
        end

    end

end

% end

%% �������Ʒ���
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

%% �ֶη���
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
