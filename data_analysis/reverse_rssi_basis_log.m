function frame_ap_info = reverse_rssi_basis_log(frame_ap_info, loss_coef)
%���ܣ����ݶ���ģ�ͺͼ���ľ�������rssi
%���壺frame_ap_info = reverse_rssi_basis_log(frame_ap_info, loss_coef)
%������ 
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).rssi����λ���յ��ĵ�i���ű��rssi
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%                   frame_ap_info(i).rssi_reference����i���ű��1�״�rssi
%    loss_coef��·�����ϵ��
%�����
%    frame_ap_info����ǰ֡����ap����Ϣ,�ṹ������,������ʽ���£�
%                   frame_ap_info(i).dist����i���ű����λ�ļ������,��λ��m
%                   frame_ap_info(i).rssi����λ���յ��ĵ�i���ű��rssi
%                   frame_ap_info(i).rssi_reference����i���ű��1�״�rssi
%                   frame_ap_info(i).reverse_log_rssi����i���ű����ݶ���ģ�����Ƶ�rssi
%                   frame_ap_info(i).log_rssi_error����i���ű����Ƶ�rssi����ʵrssi�����
%��ע��frame_ap_info(i)Ԫ�ؿɶ���˵�������ᵽ��Ԫ��,��˵�������ᵽ��Ԫ�ر������

    ap_num = length(frame_ap_info);
    
    for i = 1:ap_num
        frame_ap_info(i).reverse_log_rssi = 10 * loss_coef * ...
                                            log10(frame_ap_info(i).dist) + ...
                                            frame_ap_info(i).rssi_reference;
        
        frame_ap_info(i).log_rssi_error = abs(frame_ap_info(i).reverse_log_rssi - ...
                                              frame_ap_info(i).rssi);
    end
end