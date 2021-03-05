function config = sys_config()
%���ܣ�ϵͳ�������ã����ø�����������Ĳ���
%���壺config = sys_config()
%������ 
%
%�����
%    config�����õĲ���

    same_ap_judge_type = 'addr';

    %% ������ͬ��ap����
    %��ͬap���жϷ�ʽ
    config.integrate_same_ap_param.same_ap_judge_type = same_ap_judge_type;

    %% rssi���
    config.rssi_fit_type = 'scope_mean';               %��Ϸ�ʽ
    config.rssi_fit_param.scope_mean.rssi_range = 10;  %�����rssi��Χ���ֵ
    config.rssi_fit_param.scope_mean.ratio_thr = 0.75; %���ɹ��˵ı�����ֵ(0~1)

    %% rssi�˲�
    config.rssi_filter_param.moving_average_len = 5;   %��Ȩƽ���˲�����
    config.rssi_filter_param.gauss_filter_len = 20;    %��˹�˲�����
    config.rssi_filter_param.gauss_probability = 0.6;  %��˹�˲�У����ֵ
    config.rssi_filter_param.ap_buffer_valid_frame_num = 10;          %����ap����Ч����
    config.rssi_filter_param.same_ap_judge_type = same_ap_judge_type; %��ͬap���жϷ�ʽ
    
    %% dbscan���෨��apѡ����
    config.dbscan_selector_param.radius_calc.radius_max = 5000; %���ĵ�����뾶���ֵ
    config.dbscan_selector_param.dbscan.min_points = 0;         %���ĵ�����뾶�ڵ�����Сֵ
    
    %% ���������ap�ľ���
    config.dist_calc_type = 'logarithmic';  %��������ģʽ
    
    %����������ģ�ͣ��źŴ����ο�����d0(d0=1m)�������·�����,��d0��rssi
%     config.dist_calc_param.logarithmic.rssi_reference = -10.61; 
    %����������ģ�ͣ�·�����ϵ��,һ��ȡ2~3֮��
%     config.dist_calc_param.logarithmic.loss_coef = -1.327; 
    config.dist_calc_param.logarithmic.loss_coef = -1.886; 
    
    %�����˹ģ�ͣ���˹ģ�Ͳ���a
    config.dist_calc_param.gauss.a = 177.5; 
    %�����˹ģ�ͣ���˹ģ�Ͳ���b
    config.dist_calc_param.gauss.b = -103;     
    %�����˹ģ�ͣ���˹ģ�Ͳ���b
    config.dist_calc_param.gauss.c = 24.28;  
    
    %��˹����ģ�ͣ���˹ģ�ͼ����rssi��ֵ
    config.dist_calc_param.gausslog.rssi_thr = -100;  
    
    %% �������ǲ���
    config.dist_triangle_compensate_meter = 2; %���ǲ����ľ���(��λ����)
    
    %% NewtonGaussLS ��˹ţ�ٵ�����С�����㷨����Ȩ���Ľ��Ϊ��ʼ�㣩
    config.newtongaussls_param.iterative_num_max = 10;
    
    %% ��Χ�˲�
    config.scope_filter_param.lat_max = 60;   %γ�����ֵ
    config.scope_filter_param.lat_min = 10;   %γ����Сֵ
    config.scope_filter_param.lon_max = 200;  %�������ֵ
    config.scope_filter_param.lon_min = 100;  %������Сֵ
    
    %% ����ƽ���˲�
    config.jump_smooth_filter_param.fit_dist_thr_max = 30;   %��������ϵ�����������(��)
    config.jump_smooth_filter_param.fit_dist_thr_min = 10;   %��������ϵ���С��������(��)
    config.jump_smooth_filter_param.jump_num = 0;            %��������Ĵ���
    config.jump_smooth_filter_param.jump_num_max = 20;       %�������������Ĵ�������
    config.jump_smooth_filter_param.smooth_len = 5;          %ƽ������
    
    %% ͨ�ò���
    %��ʷ������Ч��֡������
    config.history_valid_frame_num = config.jump_smooth_filter_param.jump_num_max;      
end