function rssi_gf = prev_rssi_gauss_filter(rssi, gauss_filter_len, probability)
%���ܣ���˹�˲�
%���壺rssi_gf = prev_rssi_gauss_filter(rssi, gauss_filter_len, probability)
%������ 
%    rssi�����˲���rssiʸ��������Ϊʵ��ʸ��,����ֵ�����յ���ʱ����Զ�������
%                           ���,����t1ʱ�̴�ŵ�rssi(1),��������t2ʱ�̴��
%                           ��rssi(2)��
%    gauss_filter_len����˹�˲�����
%    probability�����ڸ�˹ģ�͵�RSSIֵУ����ֵ
%�����
%    rssi_gf����˹�˲���rssi

    rssi_len = length(rssi);
    
    if rssi_len > gauss_filter_len
        %1�����RSSI��ľ�ֵ�ͷ��RSSI�飺һ��AP��gauss_filter_len����ʷ���ݣ�
        rssi_group = rssi(rssi_len - gauss_filter_len + 1:end);
        rssi_mean = mean(rssi_group);
        rssi_std = std(rssi_group);
        
        %2���þ�ֵ�ͷ��������˹��Χ�����ʷ�Χ��
        probability_min = probability / (rssi_std * sqrt(2 * pi));
        probability_max = 1 / (rssi_std * sqrt(2 * pi));
        
        %3���ø�˹��Χ��RSSI���ڸ���ĸ���ֵ��ѡ���ڸ�˹���ڵ�RSSI��
        rssi_probability = 1 ./ (rssi_std * sqrt(2 * pi)) .* ...
                    exp(-(rssi_group - rssi_mean).^2 ./ (2 * rssi_std^2));
        rssi_filtrate = rssi_group(rssi_probability > probability_min...
                                   & rssi_probability < probability_max);
                                
        rssi_gf = mean(rssi_filtrate);
    else
        rssi_gf = rssi(end);
    end
end 