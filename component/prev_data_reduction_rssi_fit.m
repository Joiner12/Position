function ap = prev_data_reduction_rssi_fit(ap, type, param)
%���ܣ���ϸ���ap��rssi
%���壺ap = prev_data_reduction_rssi_fit(ap, type, param)
%������ 
%    ap������ϵ�����ap����
%    type����Ϸ�ʽ��֧����ʽ����
%          'mean'��ȡ��ǰ֡����rssi�ľ�ֵ
%          'scope_mean'�����ݷ�Χ�޶������˵�ǰ֡������rssi,ȡ���˺�rssi�ľ�ֵ
%    param������ģʽ�Ĳ���,��������
%          'mean'��[]
%          'scope_mean'��param.scope_mean.rssi_range�������rssi��Χ���ֵ
%                        param.scope_mean.ratio_thr�����ɹ��˵ı�����ֵ(0~1)
%�����
%    ap����Ϻ��ap����

    switch type
        case 'mean'
            for i = 1:length(ap)
                ap(i).rssi = mean(ap(i).recv_rssi);
            end
        case 'scope_mean'
            for i = 1:length(ap)
                recv_rssi = ap(i).recv_rssi;
                
                rssi_max = max(recv_rssi);
                [rssi_min, idx] = min(recv_rssi);
                while (rssi_max - rssi_min) > param.scope_mean.rssi_range
                    %rssi�ķ�Χ�����޶�ֵ,��Ҫ���й���
                    if length(idx) >= (length(recv_rssi) * param.scope_mean.ratio_thr)
                        %��Сֵrssi�ĸ������ܸ����ı����ﵽ�޶���ֵ,ֹͣ����,�˳�ѭ��
                        break;
                    else
                        %ɾ��rssi�е���Сֵ
                        recv_rssi(idx) = [];
                    end
                    
                    rssi_max = max(recv_rssi);
                    [rssi_min, idx] = min(recv_rssi);
                end
                
                ap(i).rssi = mean(recv_rssi);
            end
        otherwise
            error('ѡ�����Ϸ�ʽ����,û��%s����Ϸ�ʽ', type);
    end
end