function [ap, ap_buffer_new] = prev_rssi_filter(ap,...
                                                ap_buffer,...
                                                param)
%���ܣ�rssi�˲�
%���壺[ap, ap_buffer_new] = prev_rssi_filter(ap,...
%                                             ap_buffer,...
%                                             param)
%������ 
%    ap�����˲���ap����
%    ap_buffer��ap����
%    param���˲�����,��������
%           param.moving_average_len����Ȩƽ���˲�����
%           param.gauss_filter_len����˹�˲�����
%           param.gauss_probability����˹�˲�У����ֵ
%           param.same_ap_judge_type����ͬap���жϷ�ʽ
%�����
%    ap���˲���ap����
%    ap_buffer_new�����º�ap����

    %% ��ʼ��
    ap_num = length(ap);
    moving_average_len = param.moving_average_len;
    gauss_filter_len = param.gauss_filter_len;
    gauss_probability = param.gauss_probability;
    ap_buffer_valid_frame_num = param.ap_buffer_valid_frame_num;
    same_ap_judge_type = param.same_ap_judge_type;
                     
    %��ʼ���������˲�����
    kalman_scm_init = [(0.05)^2, ((0.05)^2)/0.1;...
              ((0.05)^2)/0.1, (2*(0.05)^2)/(0.1^2)]; %״̬�����������ؾ���
    
    %��ʼ����ѯ��־Ϊ0�����ں����жϴ�֡�����Ƿ��ѯ�������е�ap
    for i = 1:length(ap_buffer)
        ap_buffer(i).isfind = 0;
    end
    
    %% ����ȡ���µ�RSSI���ݴ����վRSSI����
    for i = 1:ap_num
        isfind = 0;
        ap_buffer_len = length(ap_buffer);
        for j = 1:ap_buffer_len
            %ƥ�䵽������ap������ƥ�䵽��ap������
            if is_same_ap(same_ap_judge_type,...
                          ap(i).name, ap_buffer(j).name,...
                          ap(i).mac, ap_buffer(j).mac)
                      
                rssi_len = length(ap_buffer(j).rssi) + 1;
                isfind = 1;
                ap_buffer(j).isfind = 1;
                ap_buffer(j).no_sig_rec_num = 0;
                ap_buffer(j).mac = ap(i).mac;
                ap_buffer(j).rssi(rssi_len) = ap(i).rssi;
                
                %��Ȩƽ���˲�(�˲�������浽ap�����������ݷ����������㷨��Ҫ)
                ap_buffer(j).rssi_wma(rssi_len) = prev_rssi_weight_moving_average(...     
                                    ap_buffer(j).rssi, moving_average_len);
                                
                ap(i).rssi_wma = ap_buffer(j).rssi_wma(rssi_len);
                
                %��˹�˲�(�˲�������浽ap�����������ݷ����������㷨��Ҫ)
                ap_buffer(j).rssi_gf(rssi_len) = prev_rssi_gauss_filter(...
                   ap_buffer(j).rssi, gauss_filter_len, gauss_probability);
                
                ap(i).rssi_gf = ap_buffer(j).rssi_gf(rssi_len);
                
                %�������˲�
                gauge_cur = (ap(i).rssi_wma + ap(i).rssi_gf) / 2; %��Ȩ�˲��͸�˹�˲���һ��
                
                if rssi_len == 2
                    value_cur = gauge_cur;
                    vel_cur = gauge_cur - ap_buffer(j).kalman_rssi(rssi_len - 1);
                    scm_cur = ap_buffer(j).kalman_rssi_scm{rssi_len - 1};
                else
                    [value_cur, vel_cur, scm_cur] = prev_rssi_kalman_filter(...
                        ap_buffer(j).kalman_rssi(rssi_len - 1), ...
                        ap_buffer(j).kalman_rssi_vel(rssi_len - 1), ...
                        ap_buffer(j).kalman_rssi_scm{rssi_len - 1}, ...
                        gauge_cur);
                end
                
                ap_buffer(j).kalman_rssi(rssi_len) = value_cur;
                ap_buffer(j).kalman_rssi_vel(rssi_len) = vel_cur;
                ap_buffer(j).kalman_rssi_scm{rssi_len} = scm_cur;
                
                ap(i).rssi_kf = value_cur;
                
                break;
            end
        end
        
        %δƥ�䵽���еĻ��棬Ϊ�µ�ap����ӵ����浱��
        if isfind == 0
            ap_buffer_len = ap_buffer_len + 1;
            
            ap_buffer(ap_buffer_len).name = ap(i).name;
            ap_buffer(ap_buffer_len).isfind = 1;
            ap_buffer(ap_buffer_len).no_sig_rec_num = 0;
            ap_buffer(ap_buffer_len).mac = ap(i).mac;
            ap_buffer(ap_buffer_len).rssi(1) = ap(i).rssi;
            
            %��Ȩƽ���˲�(�˲�������浽ap�����������ݷ����������㷨��Ҫ)
            ap_buffer(ap_buffer_len).rssi_wma(1) = ap(i).rssi;
            
            %��˹�˲�(�˲�������浽ap�����������ݷ����������㷨��Ҫ)
            ap_buffer(ap_buffer_len).rssi_gf(1) = ap(i).rssi;
            
            %�������˲�
            ap_buffer(ap_buffer_len).kalman_rssi(1) = ap(i).rssi;
            ap_buffer(ap_buffer_len).kalman_rssi_vel(1) = 0;
            ap_buffer(ap_buffer_len).kalman_rssi_scm{1} = kalman_scm_init;

            ap(i).rssi_wma = ap(i).rssi;
            ap(i).rssi_gf = ap(i).rssi;
            ap(i).rssi_kf = ap(i).rssi;
        end
    end
    
    %���»����и���ap����δɨ�赽�Ĵ���
    for i = 1:length(ap_buffer)
        if ap_buffer(i).isfind == 0
            ap_buffer(i).no_sig_rec_num = ap_buffer(i).no_sig_rec_num + 1;
        end
    end
    
    %% ������ap_buffer_valid_frame_num������û���յ��źŵ�ap,�ӻ�����ɾ�����ap�Ļ�������
    ap_buffer_new_num = 0;
    new_flag = 0;
    for i = 1:length(ap_buffer)
       if ap_buffer(i).no_sig_rec_num <= ap_buffer_valid_frame_num
           ap_buffer_new_num = ap_buffer_new_num + 1;
           new_flag = 1;
           
           ap_buffer_new(ap_buffer_new_num) = ap_buffer(i);
       end
    end
    
    if ~new_flag
        ap_buffer_new = [];
    end
end