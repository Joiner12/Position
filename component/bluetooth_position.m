function [position, debug_param] = bluetooth_position(data)
    %���ܣ�������λ
    %���壺[position, debug_param] = bluetooth_position(data)
    %������
    %    data��һ���ļ��ĸ�֡����
    %�����
    %    position����֡��λ���
    %    debug_param�����Բ���,�ṹ��,����Ԫ�ؽ����ڵ���,�������£�
    %               debug_param.ap_final_dist_calc����i֡��������ap����
    %               debug_param.frame_id����ǰ֡��
    %               debug_param.centroid������,ͨ�����ļ�������֡��
    %               debug_param.config��������������

    %% ϵͳ��ʼ��
    frame_num = length(data); %��֡��
    position = cell(0); %��ʼ��ÿ֡��λ���Ϊ��
    scope_prev_pos = struct(); %��Χ�˲���һ֡���
    pos_res_prev = struct(); % ��һ֡��λ���
    config = sys_config(); %���ø�����������

    %������debug
    rssi_fit_flag = 0;
    debug_param.ap_final_dist_calc = cell(frame_num, 1);
    debug_param.centroid = [];
    debug_param.frame_id = 0;
    debug_param.config = config;
    %% apselector ��ʼ��
    ap_selector = init_ap_selector(21);
    gif_cnt = 1;

    % ��֡����
    for i = 1:frame_num
        %% ��λǰԤ����
        debug_param.frame_id = i;

        cur_frame_ap = data{i};

        %�޳���γ��������Ч��ap����
        cur_frame_ap = prev_data_reduction_invalid_coordinate_del(cur_frame_ap);

        %������ͬ��ap����
        cur_frame_ap = prev_data_redcution_integrate_same_ap(cur_frame_ap, ...
            config.integrate_same_ap_param);

        % ��ap���յ���ԭʼRSSI�����˲������������˲�
        cur_frame_ap = prev_data_reduction_rssi_fit(cur_frame_ap, ...
            config.rssi_fit_type, ...
            config.rssi_fit_param);

        if rssi_fit_flag
            %rssi�˲�������ֻ���õ��������˲�����rssi_kf����˹��ƽ��������������ݷ�����
            [cur_frame_ap, ap_buf] = prev_rssi_filter(cur_frame_ap, ...
                ap_buf, ...
                config.rssi_filter_param);

            for j = 1:length(cur_frame_ap)
                cur_frame_ap(j).rssi = cur_frame_ap(j).rssi_kf;
            end

        else

            for j = 1:length(cur_frame_ap)
                cur_frame_ap(j).rssi_kf = cur_frame_ap(j).rssi;
            end

        end

        [trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame_ap, ap_selector);
        %% ����BS(base station)���ֽ��ж���ѡ��
        if false % �رն���ѡ����
            trilateration_ap = secondary_selector(trilateration_ap);
        end

        %% ����ģ��:RSSIת��Ϊ����
        cur_frame_ap = prev_dist_calc(trilateration_ap, ...
            config.dist_calc_type, ...
            config.dist_calc_param);

        debug_param.ap_final_dist_calc{i} = cur_frame_ap;

        %% ���߶�λ,pos_res = [x,y]
        [pos_res, ~] = trilateration_calc(cur_frame_ap);

        %% ��λ����-��Χ�˲�
        if true
            pos_res = final_scope_filter(pos_res, ...
                scope_prev_pos, ...
                config.scope_filter_param);
            scope_prev_pos = pos_res;
        end

        % ��Ч��λ���
        if ~isempty(fieldnames(pos_res))
            position{length(position) + 1} = pos_res;
        end

        %% figure
        if true &&~isempty(fieldnames(pos_res))
            tcf('Positining'); % todo:�쳣�㴦��
            f1 = figure('name', 'Positining', 'Color', 'w', 'Visible', 'off');
            cfg = get_config_debug();
            true_pos_manual = get_test_point(cfg(3).truepos);
            draw_positioning_state(gca, 'static', cur_frame_ap, 'estimated_positon', ...
                [pos_res.lat, pos_res.lon], ...
                'true_pos', [true_pos_manual{1}.lat, true_pos_manual{1}.lon]);

            % save png files
            if false
                % pause(0.01);
                png_file = strcat('location-temp', num2str(gif_cnt), '.png');
                png_file = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1', png_file);
                % imwrite(frame2im(getframe(gcf)), png_file);
                saveas(f1, png_file);
                fprintf('save figure as png file:%s\n', png_file);
            end

            gif_cnt = gif_cnt +1;

            fprintf('cnt = %.0f\n', gif_cnt);
        end

    end

end
