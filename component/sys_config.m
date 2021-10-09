function config = sys_config()
    %���ܣ�ϵͳ�������ã����ø�����������Ĳ���
    %���壺config = sys_config()
    %������
    %
    %�����
    %    config�����õĲ���
    config = struct();
    same_ap_judge_type = 'addr';

    %% ������ͬ��ap����
    %��ͬap���жϷ�ʽ
    config.integrate_same_ap_param.same_ap_judge_type = same_ap_judge_type;

    %% rssi���
    config.rssi_fit_type = 'scope_mean'; %��Ϸ�ʽ
    config.rssi_fit_param.scope_mean.rssi_range = 10; %�����rssi��Χ���ֵ
    config.rssi_fit_param.scope_mean.ratio_thr = 0.75; %���ɹ��˵ı�����ֵ(0~1)

    %% rssi�˲�
    config.rssi_filter_param.moving_average_len = 5; %��Ȩƽ���˲�����
    config.rssi_filter_param.gauss_filter_len = 20; %��˹�˲�����
    config.rssi_filter_param.gauss_probability = 0.6; %��˹�˲�У����ֵ
    config.rssi_filter_param.ap_buffer_valid_frame_num = 10; %����ap����Ч����
    config.rssi_filter_param.same_ap_judge_type = same_ap_judge_type; %��ͬap���жϷ�ʽ

    %% dbscan���෨��apѡ����
    config.dbscan_selector_param.radius_calc.radius_max = 5000; %���ĵ�����뾶���ֵ
    config.dbscan_selector_param.dbscan.min_points = 0; %���ĵ�����뾶�ڵ�����Сֵ

    %% ���������ap�ľ���
    %     config.dist_calc_type = 'logarithmic';  %��������ģʽ
    config.dist_calc_type = 'redefined_model'; %��������ģʽ

    %����������ģ�ͣ��źŴ����ο�����d0(d0=1m)�������·�����,��d0��rssi
    %     config.dist_calc_param.logarithmic.rssi_reference = -10.61;
    %����������ģ�ͣ�·�����ϵ��
    %     config.dist_calc_param.logarithmic.loss_coef = -1.327;
    config.dist_calc_param.logarithmic.loss_coef = -3;

    %�����˹ģ�ͣ���˹ģ�Ͳ���a
    config.dist_calc_param.gauss.a = 177.5;
    %�����˹ģ�ͣ���˹ģ�Ͳ���b
    config.dist_calc_param.gauss.b = -103;
    %�����˹ģ�ͣ���˹ģ�Ͳ���b
    config.dist_calc_param.gauss.c = 24.28;

    %��˹����ģ�ͣ���˹ģ�ͼ����rssi��ֵ
    config.dist_calc_param.gausslog.rssi_thr = -100;

    %% �ֶμ������ap�ľ���
    %���������ֶ�rssi��ֵ
    config.subsection_dist_calc_param.rssi_thr = -65;
    %�����뻷������
    config.subsection_dist_calc_param.close_range_loss_coef = -2.5;
    %Զ���뻷������
    config.subsection_dist_calc_param.remote_loss_coef = -3;

    %% �������ǲ���
    config.dist_triangle_compensate_meter = 2; %���ǲ����ľ���(��λ����)

    %% NewtonGaussLS ��˹ţ�ٵ�����С�����㷨����Ȩ���Ľ��Ϊ��ʼ�㣩
    config.newtongaussls_param.iterative_num_max = 10;

    %% ��Χ�˲�
    if true
        % �����ű귶Χ�ڵĵ���Ϊ�˲���Χ
        lat_tencent = [30.54785; 30.54785; 30.54804; 30.54804]; % data_import\tencent_lib_environment.m
        lon_tencent = [104.05855; 104.05892; 104.05892; 104.05855]; % data_import\tencent_lib_environment.m
        config.scope_filter_param.lat_max = max(lat_tencent); %γ�����ֵ
        config.scope_filter_param.lat_min = min(lat_tencent); %γ����Сֵ
        config.scope_filter_param.lon_max = max(lon_tencent); %�������ֵ
        config.scope_filter_param.lon_min = min(lon_tencent); %������Сֵ
    else
        config.scope_filter_param.lat_max = 60; %γ�����ֵ
        config.scope_filter_param.lat_min = 10; %γ����Сֵ
        config.scope_filter_param.lon_max = 200; %�������ֵ
        config.scope_filter_param.lon_min = 100; %������Сֵ
    end

    %% ����ƽ���˲�
    config.jump_smooth_filter_param.fit_dist_thr_max = 30; %��������ϵ�����������(��)
    config.jump_smooth_filter_param.fit_dist_thr_min = 10; %��������ϵ���С��������(��)
    config.jump_smooth_filter_param.jump_num = 0; %��������Ĵ���
    config.jump_smooth_filter_param.jump_num_max = 20; %�������������Ĵ�������
    config.jump_smooth_filter_param.smooth_len = 5; %ƽ������

    %% ͨ�ò���
    %��ʷ������Ч��֡������
    config.history_valid_frame_num = config.jump_smooth_filter_param.jump_num_max;

    %% ���Բ���

    %% ���Թ�����Ϣ-markdown
    % дmarkdown�ļ���־
    config.write_markdown_flag = true;
    % markdownͼƬ����λ��
    config.save_procession_figure = true & config.write_markdown_flag;
    config.markdown_pic_path = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1';
    config.markdown_file_1 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ���̷���.md';
    config.markdown_file_2 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\����̬��λ�������.md';
    config.markdown_file_3 = 'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\��λ���̷���.html';
    %% ��ǰ��λ��ʵλ��
    %{
    {
        "true_pos_name":P1,
        "lat":30,
        "lon":120
        }
    %}
    % ���Ե�����1 update on:2021-10-08 11:44
    test_point_1_name = {"P0", "P1", "P2", "P3", "P4", "P5", "P6", "P7", ...
                        "P8", "P9", "P10", "P11", "P12", "P13", "P14", ...
                        "P15", "P16", "P17", "P18", "P19", "P20", "P21", ...
                        "P22", "P23", "P24", "P25"};

    test_point_1_lat = [30.54791184, 30.54790401, 30.54793101, ...
                        30.54789493, 30.54794679, 30.547878695800, ...
                        30.54791369, 30.54794521, 30.54792266, ...
                        30.54790463, 30.54787639, 30.54788535, ...
                        30.54788554, 30.54789482, 30.54789501, ...
                        30.54791173, 30.54791192, 30.54793089, ...
                        30.54793108, 30.54793991, 30.5479401, ...
                        30.54788523, 30.5478947, 30.54791161, ...
                        30.54793078, 30.5479398];
    test_point_1_lon = [104.0586157, 104.0585719, 104.0586155, ...
                        104.0586159, 104.0586154, 104.058616, ...
                        104.0586505, 104.0586886, 104.0587094, ...
                        104.0587095, 104.0586947, 104.0586003, ...
                        104.0586264, 104.0586002, 104.0586263, ...
                        104.0586001, 104.0586261, 104.0585999, ...
                        104.0586259, 104.0585998, 104.0586258, ...
                        104.0585847, 104.0585846, 104.0585844, ...
                        104.0585842, 104.0585842];
    true_pos_index = 1;
    config.cur_true_pos = struct('name', test_point_1_name{true_pos_index}, ...
        'lat', test_point_1_lat(true_pos_index), 'lon', test_point_1_lon(true_pos_index));

    %% ��λ�����ͳ��
    % ��̬ͳ�����ͼƬ·��
    config.save_position_error_statistics_pic = false;
    config.position_error_statistics_pic = ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-P0-2.png';
    % ԭʼ�����ļ�·��
    % config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6_3��\', ...
        %                             'P6-added_lat_lon.txt'];
    config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_100ms_6_3��_9�²��Ա���\', ...
                                'P0-added_lat_lon.txt'];
end
