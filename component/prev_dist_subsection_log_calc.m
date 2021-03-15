function ap = prev_dist_subsection_log_calc(ap, param)
%���ܣ��ֶμ������,����rssi��ֵ,��ͬ��Χ��rssi�ڶ���ģ����ʹ�ò�ͬ�Ļ�������
%���壺ap = prev_dist_calc(ap, calctype, param)
%������ 
%    ap��ap���ݣ����ݸ���ap���ݵ�rssi�����Ӧ�ľ���
%    param������������,��������
%           param.rssi_thr�����������ֶ�rssi��ֵ
%           param.close_range_loss_coef�������뻷������
%           param.remote_loss_coef��Զ���뻷������
%�����
%    ap������������µ�ap���ݣ����²���Ϊ���Ե�dist�ֶΣ����뵥λ��m
    
    for i = 1:length(ap)
        if ap(i).rssi >= param.rssi_thr
            %С��rssi��ֵ,ʹ�ý�����Ļ�������
            calc_param.rssi_reference = ap(i).rssi_reference;
            calc_param.loss_coef = param.close_range_loss_coef;
            ap(i).dist = prev_dist_logarithmic(ap(i).rssi, calc_param);
        else
            %����rssi��ֵ,ʹ��Զ����Ļ�������
            calc_param.rssi_reference = ap(i).rssi_reference;
            calc_param.loss_coef = param.remote_loss_coef;
            ap(i).dist = prev_dist_logarithmic(ap(i).rssi, calc_param);
        end
    end
end