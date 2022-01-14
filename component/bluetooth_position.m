function [position, debug_param] = bluetooth_position(data, varargin)
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
    %% ָ�ƶ�λ��ʼ��
    frame_gap = 5; %ָ�ƶ�λ֡���
    ble_fgpt = bluetooth_fingerprinting(frame_gap);
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
        % ����ָ�ƶ�λ���ݻ���
        ble_fgpt.update_frame_data(cur_frame_ap);

        %% �μ�ѡ������������ֵ����
        if true
            trilateration_ap = secondary_selector(trilateration_ap, 'singularvalue');
        end

        %% ����ģ��:RSSIת��Ϊ����
        cur_frame_ap = prev_dist_calc(trilateration_ap, ...
        config.dist_calc_type, ...
            config.dist_calc_param);

        debug_param.ap_final_dist_calc{i} = cur_frame_ap;

        %% ���߶�λ,pos_res = [x,y]
        [pos_res, ~] = trilateration_calc(cur_frame_ap);
        %% ָ�ƶ�λ
        relative_pos_fgpt = ble_fgpt.knn_prediction();
        fprintf('fgpt_pos:%.3f,%.3f\n', relative_pos_fgpt(1), relative_pos_fgpt(2));
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

        true_pos = struct();

        if any(strcmpi(varargin, 'true_pos'))
            true_pos = varargin{find(strcmpi(varargin, 'true_pos')) + 1};
        end

        % save png files
        save_process_pic = false;

        if any(strcmpi(varargin, 'save_process_pic'))
            save_process_pic = varargin{find(strcmpi(varargin, 'save_process_pic'), 1) + 1};
        end

        if ~isempty(fieldnames(pos_res)) ...
                && ~isempty(fieldnames(true_pos)) ...
                && true

            % pause(0.01); % save failed
            png_file = fullfile('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1', ...
            strcat('location-temp', num2str(gif_cnt), '.png'));
            draw_positioning_state('static', cur_frame_ap, 'estimated_positon', ...
                [pos_res.lat, pos_res.lon], ...
                'true_pos', [true_pos.lat, true_pos.lon], 'target_pic', png_file, ...
                'visible', false, 'save_figure', save_process_pic, ...
                'fingerprinting_pos', relative_pos_fgpt);

        end

        gif_cnt = gif_cnt +1;
    end

end
