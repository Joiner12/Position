function ap_select = prev_rssi_ap_selector(cur_ap, param)
%���ܣ�����rssiѡ��ap
%���壺ap_select = prev_rssi_ap_selector(cur_ap, select_len)
%������ 
%    cur_ap����ǰ��ѡ�������ap����
%    param����������,��������
%           param.select_len��ѡȡ��ap����
%�����
%    ap_select��ѡ����ap���� 

    ap_select = [];
    if isempty(cur_ap)
        return;
    end
    
    select_len = param.select_len;
    
    cur_ap_num = length(cur_ap);
    rssi = zeros(cur_ap_num, 1);
    for i = 1:cur_ap_num
        rssi(i) = cur_ap_num(i).rssi;
    end
    
    %��rssi�������������
    [rssi_sorted, rssi_idx] = sort(rssi, 'descend');
    
    %ѡȡ�ź���ǿ��ǰselect_len��ap����ap��������select_len������ѡ��ȫ��ap
    if cur_ap_num > select_len
        ap_select = cur_ap(rssi_idx(1:select_len));
    else
        ap_select = cur_ap;
    end
end 