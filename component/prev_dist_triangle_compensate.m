function ap_new = prev_dist_triangle_compensate(ap, meter)
%���ܣ��������ǲ���
%���壺pos_res = location_least_squares(ap)
%������ 
%    ap���ο�����Ϣ
%    meter�������ĸ߶ȣ���λ���ף�,�ο���Ϣ�����ڲ����ľ��뵥λΪ��
%�����
%    ap_new�����벹����Ĳο�����Ϣ,������ľ��뵥λΪ��

    ap_new = ap;
    ap_num = length(ap_new);
    
    for i = 1:ap_num
        ap_new(i).dist = sqrt(abs(ap_new(i).dist^2 - meter^2));
    end
end