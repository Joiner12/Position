function blu_data_analyse_static()
%���ܣ���̬���ݷ�����
%��ϸ�����������������ڹ̶�λ��ɨ�����ݣ���������ɨ�赽������֡�����ݰ�ap��ȡ��
%         ����ÿ��ap�ڲ�ͬʱ��ɨ�赽��rssi���ݻ�����ͼ�У��ɷ���ap
%         �źŵ��ȶ���

    %��ȡ�ļ�
    [file_name, path] = uigetfile('*.*');
    file = [path, file_name];
    
    %��ȡ������������
    [data, frame_num_total] = blu_data_file_parsing(file);
    
    %��ȡ��ɨ�赽�����������и�����ͬap����Ϣ��
    %����ÿ��ap��ɨ�赽��rssi��ʱ��˳�����У�ɨ���֡��
    different_ap = extract_different_ap_info(data);
    
    %���ƾ�̬���ݷ���ͼ
    handle = [];
    for i = 1:length(different_ap)
        rssi = different_ap(i).frame_rssi_mean;
   
        rssi_mean = mean(rssi);
        rssi_max = max(rssi);
        rssi_min = min(rssi);
        targ = [different_ap(i).name, ' rssi range: ', ...
                num2str(rssi_max - rssi_min)];
        
        %����rssiͼ
        handle(i) = figure;
        set(handle(i), 'name', targ);
        plot(rssi, 'r*-');
        x_idx_low = 1;
        x_idx_hign = length(rssi);
        y_idx_low = rssi_min - 5;
        y_idx_high = rssi_max + 5;
        if x_idx_low == x_idx_hign
            x_idx_hign = x_idx_hign + 1;
        end
        axis([x_idx_low x_idx_hign y_idx_low y_idx_high]);
        hold on;
        title(targ);
        ylabel('rssi');
        
        %����rssi��ֵ�ߡ����ֵ�ߡ���Сֵ��
        plot([1, length(rssi)], [rssi_mean, rssi_mean], 'b-');
        hold on;
        plot([1, length(rssi)], [rssi_max, rssi_max], 'm--');
        hold on;
        plot([1, length(rssi)], [rssi_min, rssi_min], 'c--');
        
        %���ñ�ǩ
        legend('rssi', ['rssi mean:', num2str(rssi_mean)],...
                       ['rssi max:', num2str(rssi_max)],...
                       ['rssi min:', num2str(rssi_min)]);
    end
end