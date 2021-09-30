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
    config.write_markdown_flag = false;
    % markdownͼƬ����λ��
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
    test_point_1_name = {"P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "P10"};

    test_point_1_lon = [104.0585719, 104.058615502714, 104.058615850824, ...
                        104.058615350415, 104.058616007473, 104.058660192224, ...
                        104.058688771294, 104.058709374097, 104.058709548135, ...
                        104.0586505];
    test_point_1_lat = [30.54790401, 30.547931006136, 30.547894930042, ...
                        30.547946789427, 30.547878695800, 30.547912297694, ...
                        30.547945353836, 30.547922664987, 30.547904626940, ...
                        30.54791369];

    % true_pos_p1 = struct('name', "P1", 'lat', test_point_1_lat(1), 'lon', test_point_1_lon(1));
    % config.true_pos1 = true_pos_p1;
    % true_pos_p2 = struct('name', "P2", 'lat', test_point_1_lat(2), 'lon', test_point_1_lon(2));
    % config.true_pos2 = true_pos_p2;
    % true_pos_p3 = struct('name', "P3", 'lat', test_point_1_lat(3), 'lon', test_point_1_lon(3));
    % config.true_pos3 = true_pos_p3;
    % true_pos_p4 = struct('name', "P4", 'lat', test_point_1_lat(4), 'lon', test_point_1_lon(4));
    % config.true_pos4 = true_pos_p4;
    % true_pos_p5 = struct('name', "P5", 'lat', test_point_1_lat(5), 'lon', test_point_1_lon(5));
    % config.true_pos5 = true_pos_p5;
    % true_pos_p6 = struct('name', "P6", 'lat', test_point_1_lat(6), 'lon', test_point_1_lon(6));
    % config.true_pos6 = true_pos_p6;
    true_pos_index = 6;
    config.cur_true_pos = struct('name', test_point_1_name{true_pos_index}, ...
        'lat', test_point_1_lat(true_pos_index), 'lon', test_point_1_lon(true_pos_index));

    %% ��λ�����ͳ��
    % ��̬ͳ�����ͼƬ·��
    config.save_position_error_statistics_pic = true;
    config.position_error_statistics_pic = ...
        'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\static-p6-1.png';
    % ԭʼ�����ļ�·��
    config.origin_data_file = ['D:\Code\BlueTooth\pos_bluetooth_matlab\data\data_beacon_100ms_6_3��\', ...
                                'P6-added_lat_lon.txt'];
end
