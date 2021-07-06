function [position, debug_param] = bluetooth_position(data)
    %功能：蓝牙定位
    %定义：[position, debug_param] = bluetooth_position(data)
    %参数：
    %    data：一个文件的各帧数据
    %输出：
    %    position：各帧定位结果
    %    debug_param：调试参数,结构体,所有元素仅用于调试,具体如下：
    %               debug_param.ap_final_dist_calc：第i帧距离计算后ap数据
    %               debug_param.frame_id：当前帧号
    %               debug_param.centroid：数组,通过质心计算距离的帧号
    %               debug_param.config：各个构件参数

    %% 系统初始化
    frame_num = length(data); %总帧数
    position = cell(0); %初始化每帧定位结果为空
    scope_prev_pos = struct(); %范围滤波上一帧结果
    pos_res_prev = struct(); % 上一帧定位结果
    config = sys_config(); %设置各个构件参数

    %仅用于debug
    rssi_fit_flag = 0;
    debug_param.ap_final_dist_calc = cell(frame_num, 1);
    debug_param.centroid = [];
    debug_param.frame_id = 0;
    debug_param.config = config;
    %% apselector 初始化
    ap_selector = init_ap_selector(10);
    gif_cnt = 1;

    % 逐帧处理
    for i = 1:frame_num
        %% 定位前预处理
        debug_param.frame_id = i;

        cur_ap = data{i};

        %剔除经纬度数据无效的ap数据
        cur_ap = prev_data_reduction_invalid_coordinate_del(cur_ap);

        %整合相同的ap数据
        cur_ap = prev_data_redcution_integrate_same_ap(cur_ap, ...
            config.integrate_same_ap_param);

        % 对ap接收到的原始RSSI进行滤波处理——滑动滤波
        cur_ap = prev_data_reduction_rssi_fit(cur_ap, ...
            config.rssi_fit_type, ...
            config.rssi_fit_param);

        if rssi_fit_flag
            %rssi滤波（后续只会用到卡尔曼滤波后结果rssi_kf，高斯及平滑结果仅用于数据分析）
            [cur_ap, ap_buf] = prev_rssi_filter(cur_ap, ...
                ap_buf, ...
                config.rssi_filter_param);

            for j = 1:length(cur_ap)
                cur_ap(j).rssi = cur_ap(j).rssi_kf;
            end

        else

            for j = 1:length(cur_ap)
                cur_ap(j).rssi_kf = cur_ap(j).rssi;
            end

        end

        [trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_ap, ap_selector);

        %% 对数模型:RSSI转换为距离
        cur_ap = prev_dist_calc(trilateration_ap, ...
            config.dist_calc_type, ...
            config.dist_calc_param);

        debug_param.ap_final_dist_calc{i} = cur_ap;

        %% 三边定位,pos_res = [x,y]
        [pos_res, ~] = trilateration_calc(cur_ap);

        %% 定位后处理-范围滤波
        if true
            pos_res = final_scope_filter(pos_res, ...
                scope_prev_pos, ...
                config.scope_filter_param);
            scope_prev_pos = pos_res;
        end

        % 有效定位结果
        if ~isempty(fieldnames(pos_res))
            position{length(position) + 1} = pos_res;
        end

        %% figure
        if true &&~isempty(fieldnames(pos_res))
            tcf('Positining'); % todo:异常点处理
            figure('name', 'Positining', 'Color', 'w');

            % draw_positioning_state(gca,'static', cur_ap, 'estimated_positon', [pos_res.lat, pos_res.lon], ...
                %     'true_pos', [30.54798217, 104.05861620]);
            % lat:30.547966937307,lon:104.058595105583 static-1
            % lat:30.547966458202,lon:104.058698530348 static-2
            % lat:30.547965611298,lon:104.058814724652 static-3
            true_pos_manual = [30.5479692317, 104.0585915092; ...
                                30.5479705577, 104.0586741723; ...
                                30.5479727197, 104.0587717089];
            draw_positioning_state(gca, 'static', cur_ap, 'estimated_positon', ...
                [pos_res.lat, pos_res.lon], ...
                'true_pos', true_pos_manual(2, :));
            % 生成gif
            if false
                frame = getframe(gcf);
                imind = frame2im(frame);
                [imind, cm] = rgb2ind(imind, 256);

                if gif_cnt == 1
                    imwrite(imind, cm, 'D:\Code\BlueTooth\pos_bluetooth_matlab\test.gif', ...
                        'gif', 'Loopcount', inf, 'DelayTime', 0.5);
                else
                    imwrite(imind, cm, 'D:\Code\BlueTooth\pos_bluetooth_matlab\test.gif', ...
                        'gif', 'WriteMode', 'append', 'DelayTime', 0.5);
                end

            end

            % save png files
            if false
                pause(0.1);
                png_file = strcat('location-temp', num2str(gif_cnt), '.png');
                png_file = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\', png_file);
                imwrite(frame2im(getframe(gcf)), png_file);
                fprintf('save figure as png file:%s\n', png_file);
            end

            gif_cnt = gif_cnt +1;
            fprintf('cnt = %.0f\n', gif_cnt);
        end

    end

end
