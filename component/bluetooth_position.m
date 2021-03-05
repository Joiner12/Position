function position = bluetooth_position(data)
%���ܣ�������λ
%���壺position = bluetooth_position(data)
%������ 
%    data��һ���ļ��ĸ�֡����
%�����
%    position����֡��λ���

%% ϵͳ��ʼ��
    frame_num = length(data);  %��֡��
    position = cell(1, frame_num); %��ʼ��ÿ֡��λ���Ϊ��
    continue_valid_frame_num = 0;  %������Ч��֡��
    continue_invalid_frame_num = 0;%������Ч��֡��
    ap_buf = [];  %��ʼ����ͬap���ݵĻ���
    prev_ap = []; %��ʼ����һ֡��ap����
    scope_prev_pos = [];       %��Χ�˲���һ֡���
    jump_smooth_prev_pos = []; %���㷶Χ�˲���һ֡���
    invalid_situation_pos = [];%��Ч�������������Ķ�λ���
    config = sys_config();     %���ø�����������
    pos_queue = queue_init(config.jump_smooth_filter_param.smooth_len); %��ʼ�����껺�����

%% ��֡����
    for i = 1:frame_num
    %% ��λǰԤ����
        cur_ap = data{i};
        
        %�޳���γ��������Ч��ap����
        cur_ap = prev_data_reduction_invalid_coordinate_del(cur_ap);
        
        %������ͬ��ap����
        cur_ap = prev_data_redcution_integrate_same_ap(cur_ap,...
                                                       config.integrate_same_ap_param);
        
        %��ϸ���ap��rssi
        cur_ap = prev_data_reduction_rssi_fit(cur_ap,...
                                              config.rssi_fit_type,...
                                              config.rssi_fit_param);
        
        if i == 135
            a = 1;
        end
        
        if i == 158
            a = 1;
        end
        
        if i == 142
            a = 1;
        end
                                          
        %rssi�˲�������ֻ���õ��������˲�����rssi_kf����˹��ƽ��������������ݷ�����
%         [cur_ap, ap_buf] = prev_rssi_filter(cur_ap,...
%                                             ap_buf,...
%                                             config.rssi_filter_param);
                                        
        for j = 1:length(cur_ap) 
            cur_ap(j).rssi_kf = cur_ap(j).rssi;
        end
                                        
        %dbscan���෨��apѡ����
%         cur_ap = prev_dbscan_ap_selector(cur_ap,...
%                                          prev_ap,...
%                                          config.dbscan_selector_param);
                                
        prev_ap = cur_ap;
                                          
        %���������ap�ľ���
        cur_ap = prev_dist_calc(cur_ap,...
                                config.dist_calc_type,...
                                config.dist_calc_param);
                            
        %�������ǲ���
        cur_ap = prev_dist_triangle_compensate(cur_ap, config.dist_triangle_compensate_meter);
        
    %% ��λ
        %��˹ţ�ٵ�����С�����㷨����Ȩ���Ľ��Ϊ��ʼ�㣩
%         pos_res = location_gauss_newton_least_squares_wma(cur_ap,...
%                                                           config.newtongaussls_param);
        
        pos_res = location_least_squares(cur_ap);
        
        if isempty(pos_res)
            pos_res = pos_res_prev;
        else
            pos_res_prev = pos_res;
        end
                                                      
%         if isempty(pos_res)
%             %��ǰ֡δ��λ�����
%             continue_invalid_frame_num = continue_invalid_frame_num + 1;
%             
%             if continue_invalid_frame_num >= config.history_valid_frame_num
%                 %��Ч֡���ﵽ��������,��Ϊ��ʷ�����Ѿ���Ч,�����ʷ����,�ָ���
%                 %��ʼ��λ��״̬,ֱ�������һ�����ս��
%                 %
%                 %ע�⣺ap���ݻ���ap_buf���Բ���գ���Ϊprev_rssi_filter�������õ�
%                 %      ����ap��Ч����ap_buffer_valid_frame_numС����Ч֡������
%                 %      history_valid_frame_num,ͬʱ��ǰ�㷨���ڲ�������Ч����ʱ
%                 %      ����δ��λ����������,��˻�δ�ﵽ�����ʷ����������
%                 %      ʱ��,ap���ݻ����Ѿ�ȫ������,��ʵ��ʱ����Ҫ�ظ����ap���ݻ���
%                 continue_valid_frame_num = 0;
%                 config.jump_smooth_filter_param.jump_num = 0;
%                 ap_buf = [];
%                 prev_ap = [];
%                 scope_prev_pos = [];
%                 jump_smooth_prev_pos = [];
%                 pos_queue = queue_clear(pos_queue);
%                 position{i} = invalid_situation_pos;
%                 
%                 continue;
%             else
%                 %��ʷ���ݻ���Ч,�����ϴμ���ĳ�ʼ��λ������к�����λ����
%                 pos_res = pos_res_prev;
%             end
%         else
%             %��ǰ֡�ɹ���λ�����,���浱ǰ�����Ϊ��ʼ��λ����ʷ����
%             pos_res_prev = pos_res;
%         end
        
    %% ��λ����
%         %��Χ�˲�
%         pos_res = final_scope_filter(pos_res,...
%                                      scope_prev_pos,...
%                                      config.scope_filter_param);
%                                  
%         scope_prev_pos = pos_res;
%         
%         %����ƽ���˲�
%         continue_valid_frame_num = continue_valid_frame_num + 1;
%         config.jump_smooth_filter_param.frame_num = continue_valid_frame_num;
%         [pos_res, pos_queue, jump_num] = final_jump_smooth_filter(pos_res,...
%                                                                   jump_smooth_prev_pos,...
%                                                                   pos_queue,...
%                                                                   config.jump_smooth_filter_param);
%                                                               
%          config.jump_smooth_filter_param.jump_num = jump_num;                                       
%          jump_smooth_prev_pos = pos_res;
%          invalid_situation_pos = pos_res;
         
         position{i} = pos_res;
    end
end