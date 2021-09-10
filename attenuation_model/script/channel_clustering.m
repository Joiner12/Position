function [data_idx, C] = channel_clustering(origin_data, clustering_num, varargin)
    % ����:
    %       ��origin_data(һά)����ʹ��k-means����
    % ����:
    %       [rssi_idx, C] = channel_clustering(rssi, clustering_num, varargin)
    % ����:
    %       origin_data,�������origin_data����
    %       clustering_num,������
    %       varargin,��������
    % ���:
    %       data_idx,���ر�ǩ��ԭʼ����
    %       C,������

    data_y = reshape(origin_data, [length(origin_data), 1]);
    data_x = 1:1:length(data_y);
    %% k-means THREE clustering
    clc;
    opts = statset('Display', 'final');
    [idx, C] = kmeans(data_y, 3, 'Distance', 'cityblock', ...
        'Replicates', clustering_num, 'Options', opts);
    idx = reshape(idx, [length(idx), 1]);
    data_idx = [data_y, idx];
    % markers
    markers = ['o', '+', '*', 'x', 's', ...
                'd', '^', 'v', '<', '>', 'p', 'h'];

    if any(strcmpi(varargin, 'show_figure'))
        tcf('clustering-figure');
        figure('name', 'clustering-figure', 'color', 'w');
        legs = cell(0);
        legs{1} = 'origin';
        hold on
        plot(data_x, data_y);

        for k = 1:clustering_num
            cur_marker = markers(randi(length(markers)));
            legs{k + 1} = strcat("clustering", num2str(k));
            plot(data_x(idx == k), data_y(idx == k), 'Marker', cur_marker, ...
                'MarkerSize', 8, 'LineStyle', 'None');

        end

        for k = 1:clustering_num
            line([1, length(data_x)], [C(k), C(k)], 'LineWidth', 1.5, ...
                'color', 'r', 'LineStyle', '-');
        end

        legend(legs);
        hold off;
        box on;
        grid minor;
    end

end
