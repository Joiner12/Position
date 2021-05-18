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
    position = cell(1, frame_num); %��ʼ��ÿ֡��λ���Ϊ��
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
    ap_selector = init_ap_selector(20);
    gif_cnt = 1;

    % ��֡����
    for i = 1:frame_num
        %% ��λǰԤ����
        debug_param.frame_id = i;

        cur_ap = data{i};

        %�޳���γ��������Ч��ap����
        cur_ap = prev_data_reduction_invalid_coordinate_del(cur_ap);

        %������ͬ��ap����
        cur_ap = prev_data_redcution_integrate_same_ap(cur_ap, ...
            config.integrate_same_ap_param);

        % ��ap���յ���ԭʼRSSI�����˲������������˲�
        cur_ap = prev_data_reduction_rssi_fit(cur_ap, ...
            config.rssi_fit_type, ...
            config.rssi_fit_param);

        if rssi_fit_flag
            %rssi�˲�������ֻ���õ��������˲�����rssi_kf����˹��ƽ��������������ݷ�����
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

        %% ����ģ��:RSSIת��Ϊ����
        cur_ap = prev_dist_calc(trilateration_ap, ...
            config.dist_calc_type, ...
            config.dist_calc_param);

        debug_param.ap_final_dist_calc{i} = cur_ap;

        %% ���߶�λ,pos_res = [x,y]
        [pos_res, ~] = trilateration_calc(cur_ap);

        % if final_flag

        %     if isempty(pos_res)
        %         %��ǰ֡δ��λ�����
        %         continue_invalid_frame_num = continue_invalid_frame_num + 1;

        %         if continue_invalid_frame_num >= config.history_valid_frame_num
        %             %��Ч֡���ﵽ��������,��Ϊ��ʷ�����Ѿ���Ч,�����ʷ����,�ָ���
        %             %��ʼ��λ��״̬,ֱ�������һ�����ս��
        %             %
        %             %ע�⣺ap���ݻ���ap_buf���Բ���գ���Ϊprev_rssi_filter�������õ�
        %             %      ����ap��Ч����ap_buffer_valid_frame_numС����Ч֡������
        %             %      history_valid_frame_num,ͬʱ��ǰ�㷨���ڲ�������Ч����ʱ
        %             %      ����δ��λ����������,��˻�δ�ﵽ�����ʷ����������
        %             %      ʱ��,ap���ݻ����Ѿ�ȫ������,��ʵ��ʱ����Ҫ�ظ����ap���ݻ���
        %             continue_valid_frame_num = 0;
        %             config.jump_smooth_filter_param.jump_num = 0;
        %             ap_buf = [];
        %             prev_ap = [];
        %             scope_prev_pos = [];
        %             jump_smooth_prev_pos = [];
        %             pos_queue = queue_clear(pos_queue);
        %             position{i} = invalid_situation_pos;

        %             % continue;
        %         else
        %             %��ʷ���ݻ���Ч,�����ϴμ���ĳ�ʼ��λ������к�����λ����
        %             pos_res = pos_res_prev;
        %         end

        %     else
        %         %��ǰ֡�ɹ���λ�����,���浱ǰ�����Ϊ��ʼ��λ����ʷ����
        %         pos_res_prev = pos_res;
        %     end

        %     %% ��λ����
        %     % ��Χ�˲�
        %     pos_res = final_scope_filter(pos_res, ...
        %         scope_prev_pos, ...
        %         config.scope_filter_param);

        %     scope_prev_pos = pos_res;

        %     %����ƽ���˲�
        %     continue_valid_frame_num = continue_valid_frame_num + 1;
        %     config.jump_smooth_filter_param.frame_num = continue_valid_frame_num;
        %     [pos_res, pos_queue, jump_num] = final_jump_smooth_filter(pos_res, ...
        %         jump_smooth_prev_pos, ...
        %         pos_queue, ...
        %         config.jump_smooth_filter_param);

        %     config.jump_smooth_filter_param.jump_num = jump_num;
        %     jump_smooth_prev_pos = pos_res;
        %     invalid_situation_pos = pos_res;
        % else

        %     if isempty(pos_res)
        %         pos_res = pos_res_prev;
        %     else
        %         pos_res_prev = pos_res;
        %     end

        % end

        %% ��λ����-��Χ�˲�
        pos_res = final_scope_filter(pos_res, ...
            scope_prev_pos, ...
            config.scope_filter_param);

        scope_prev_pos = pos_res;

        if isempty(fieldnames(pos_res))
            pos_res = pos_res_prev;
        else
            pos_res_prev = pos_res;
        end

        position{i} = pos_res_prev;

        %% figure
        if true
            tcf('Positining'); % todo:�쳣�㴦��
            figure('name', 'Positining', 'Color', 'w');

            % draw_positioning_state(gca,'static', cur_ap, 'estimated_positon', [pos_res.lat, pos_res.lon], ...
                %     'true_pos', [30.54798217, 104.05861620]);
            draw_positioning_state(gca, 'static', cur_ap, 'estimated_positon', [pos_res.lat, pos_res.lon]);
            %% ����gif
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

            %% save png files
            if true
                pause(0.1);
                png_file = strcat('location-temp', num2str(gif_cnt), '.png');
                png_file = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\', png_file);
                imwrite(frame2im(getframe(gcf)), png_file);
                fprintf('save figure as png file:%s\n', png_file);
            end

            gif_cnt = gif_cnt +1;

            if (gif_cnt >= 47 && gif_cnt <= 50) || (gif_cnt >= 65 && gif_cnt <= 70)
                debug_line = 1;
            end

            fprintf('cnt = %.0f\n', gif_cnt);
        end

    end

end
