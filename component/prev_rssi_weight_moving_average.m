function rssi_wma = prev_rssi_weight_moving_average(rssi, moving_average_len)
%���ܣ���Ȩƽ�������˲�
%���壺rssi_wma = prev_rssi_weight_moving_average(rssi, moving_average_len)
%������ 
%    rssi�����˲���rssiʸ��������Ϊʵ��ʸ��,����ֵ�����յ���ʱ����Զ�������
%                           ���,����t1ʱ�̴�ŵ�rssi(1),��������t2ʱ�̴��
%                           ��rssi(2)��
%    moving_average_len����������
%�����
%    rssi_wma����Ȩƽ����rssi

    rssi_len = length(rssi);
    weight_vec = cell(1, 6);

    weight_vec{1} = [0.05, 0.1, 0.15, 0.3, 0.4];
    weight_vec{2} = [0.05, 0.08, 0.12, 0.15, 0.2, 0.4];
    weight_vec{3} = [0.01, 0.03, 0.08, 0.15, 0.18, 0.25, 0.3];
    weight_vec{4} = [0.01, 0.015, 0.035, 0.07, 0.14, 0.18, 0.25, 0.3];
    weight_vec{5} = [0.01, 0.015, 0.025, 0.06, 0.1, 0.14, 0.18, 0.22, 0.25];
    weight_vec{6} = [0.01, 0.015, 0.025, 0.03, 0.05, 0.09, 0.13, 0.18, 0.22, 0.25];
    
    switch moving_average_len
        case 5
            weight = weight_vec{1};
        case 6
            weight = weight_vec{2};
        case 7
            weight = weight_vec{3};
        case 8
            weight = weight_vec{4};
        case 9
            weight = weight_vec{5};
        case 10
            weight = weight_vec{6};
        otherwise
            moving_average_len = 5;
            weight = weight_vec{1};
    end
    
    if  rssi_len > moving_average_len
        weigth_vec = rssi(rssi_len - moving_average_len + 1:end) .* weight;
        rssi_wma = sum(weigth_vec);
    else
        rssi_wma = mean(rssi);
    end
end