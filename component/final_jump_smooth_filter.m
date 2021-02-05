function [pos_res, pos_queue, jump_num] = final_jump_smooth_filter(cur_pos,...
                                                                   prev_pos,...
                                                                   pos_queue,...
                                                                   param)
%���ܣ�����ƽ���˲�
%���壺[pos_res, pos_queue, jump_num] = final_jump_smooth_filter(cur_pos,...
%                                                                prev_pos,...
%                                                                pos_queue,...
%                                                                param)
%������ 
%    cur_pos����ǰ��λ���
%    prev_pos��ǰһ֡��λ���           
%    pos_queue�����껺�����
%    param����������,��������
%           param.frame_num����ǰ��Ч֡�ţ�������������������ĵ�frame_num֡��Ч����   
%           param.fit_dist_thr_max����������ϵ�����������
%           param.fit_dist_thr_min����������ϵ���С��������
%           param.jump_num����������Ĵ���
%           param.jump_num_max���������������Ĵ�������
%           param.smooth_len��ƽ������
%�����
%    pos_res���˲���λ���������Ϊ�ṹ�壬����Ԫ�����£�
%             pos_res.lat��γ��
%             pos_res.lon������
%    pos_queue���˲�����µ����껺�����
%    jump_num���˲�����µ���������Ĵ���
             
    frame_num = param.frame_num;
    fit_dist_thr_max = param.fit_dist_thr_max;
    fit_dist_thr_min = param.fit_dist_thr_min;
    jump_num = param.jump_num;
    jump_num_max = param.jump_num_max;
    smooth_len = param.smooth_len;

    if isempty(cur_pos)
        pos_res = [];
        jump_num = jump_num + 1;
        return;
    end
    
    %���㵱ǰ�����Ͼ�������
    step_dist = (fit_dist_thr_max - fit_dist_thr_min) / jump_num_max;   
    fit_dist_thr = fit_dist_thr_min + (jump_num * step_dist);
    
    %% �����˲�
    if frame_num > smooth_len
        %֡������ƽ�����ȣ����������˲�
        %���㵱ǰ��λ��������ϴζ�λ����ľ��루ע���ʱ�������ǰһ֡�����
        dist = utm_distance(cur_pos.lat, cur_pos.lon,...
                            prev_pos.lat, prev_pos.lon);
        
        if dist <= fit_dist_thr
            %��ǰ�㲻Ϊ����
            pos_queue = queue_push(pos_queue, cur_pos);
            jump_num = 0;
        else
            %��ǰ��Ϊ����
            jump_num = jump_num + 1; 
            
            if dist < (fit_dist_thr_max + 10)
                %��ǰ�㴦�����������
                if jump_num < jump_num_max
                    %�����������δ�ﵽ���ޣ���Ϊ��ʷ���ݿ��ţ���������ϵ�ǰ��λ���
                    a = jump_num / jump_num_max;
                    b = 1 - a;
                    pos.lat = a * cur_pos.lat + b * prev_pos.lat;
                    pos.lon = a * cur_pos.lon + b * prev_pos.lon;

                    pos_queue = queue_push(pos_queue, pos);
                else
                    %������������ﵽ���ޣ���Ϊ��ʷ���ݲ����ţ��������ʷ���ݣ�����
                    %��ǰ��Ϊ��ʼ���¸��»����������
                    pos_queue = queue_clear(pos_queue);
                    pos_queue = queue_push(pos_queue, cur_pos);
                end
            else
                %��ǰ�㳬����Ϸ�Χ�����ٶԵ�ǰ��λ����������
                if jump_num < jump_num_max
                    %�����������δ�ﵽ���ޣ���Ϊ��ʷ���ݿ��ţ�������һ�ν��
                    pos_queue = queue_push(pos_queue, prev_pos);
                else
                    %������������ﵽ���ޣ���Ϊ��ʷ���ݲ����ţ��������ʷ���ݣ�����
                    %��ǰ��Ϊ��ʼ���¸��»����������
                    pos_queue = queue_clear(pos_queue);
                    pos_queue = queue_push(pos_queue, cur_pos);
                end
            end
        end
    else 
        %֡��δ����ƽ�����ȣ������������˲�������ǰ֡���ݼ��뻺�����
        pos_queue = queue_push(pos_queue, cur_pos);
    end
    
    %% ƽ���˲����������˲�����µ����껺��������ݽ����˲�����Ϊ���������
    data = queue_get_data(pos_queue);

    if length(data) > smooth_len
        len = smooth_len;
    else
        len = length(data);
    end
    
    smooth_data = data(1:len);
    smooth_lat = zeros(len, 1);
    smooth_lon = zeros(len, 1);
    for i = 1:len
        smooth_lat(i) = smooth_data{i}.lat;
        smooth_lon(i) = smooth_data{i}.lon;
    end
    
    pos_res.lat = mean(smooth_lat);
    pos_res.lon = mean(smooth_lon);
end