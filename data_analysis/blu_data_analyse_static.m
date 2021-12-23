function blu_data_analyse_static()
    %功能:静态数据分析。
    %详细描述:蓝牙接收器在固定位置扫描数据，本函数将扫描到的所有帧的数据按ap提取，
    %         并将每个ap在不同时间扫描到的rssi数据绘制在图中，可分析ap
    %         信号的稳定性
    %参数:
    %    varargin,扩展参数
    %    ap_name_filter,字符串数组或者字符数组,用以根据名字筛选特定的ap
    %    比如需要筛选名字为Beacon0的ap信息,则函数为:
    %    ble_data_analyse_static('ap_name_filter',["Beacon0"])
    %    比如需要筛选名字为Beacon0和Beacon1的ap信息,则函数为:
    %    ble_data_analyse_static('ap_name_filter',["Beacon0","Beacon1"])
    %输出:
    %    ap_msg:提取出的各帧的信标数据,细胞数组,各个细胞表示各帧的信标数据
    %获取文件
    [file_name, path] = uigetfile('*.*');
    file = [path, file_name];

    %获取待分析的数据
    [data, frame_num_total] = blu_data_file_parsing(file);

    %提取出扫描到的所有数据中各个不同ap的信息，
    %其中每个ap的扫描到的rssi按时间顺序排列（扫描的帧序）
    different_ap = extract_different_ap_info(data);

    %绘制静态数据分析图
    handle = [];

    for i = 1:length(different_ap)
        rssi = different_ap(i).frame_rssi_mean;

        rssi_mean = mean(rssi);
        rssi_max = max(rssi);
        rssi_min = min(rssi);
        targ = [different_ap(i).name, ' rssi range: ', ...
                num2str(rssi_max - rssi_min)];

        %绘制rssi图
        handle(i) = figure;
        set(handle(i), 'name', targ, 'color', 'w');
        plot(rssi, 'r*-');
        x_idx_low = 1;
        x_idx_hign = length(rssi);
        y_idx_low = rssi_min - 5;
        y_idx_high = rssi_max + 5;

        if x_idx_low == x_idx_hign
            x_idx_hign = x_idx_hign + 1;
        end

        axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
        hold on;
        title(targ);
        ylabel('rssi');

        %绘制rssi均值线、最大值线、最小值线
        plot([1, length(rssi)], [rssi_mean, rssi_mean], 'b-');
        hold on;
        plot([1, length(rssi)], [rssi_max, rssi_max], 'm--');
        hold on;
        plot([1, length(rssi)], [rssi_min, rssi_min], 'c--');

        %设置标签
        legend('rssi', ['rssi mean:', num2str(rssi_mean)], ...
        ['rssi max:', num2str(rssi_max)], ...
            ['rssi min:', num2str(rssi_min)]);
    end

end
