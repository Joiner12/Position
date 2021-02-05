function new_ap = prev_data_reduction_invalid_coordinate_del(ap)
%���ܣ��޳���γ��������Ч��ap����
%���壺new_ap = prev_data_reduction_invalid_coordinate_del(ap)
%������ 
%    ap�����޳�������ap����
%�����
%    new_ap���޳���Чap��ʣ���ap����
%��ע�������й���γ�ȷ�Χ��������Ϊ��Ч����

    %�й���γ�ȵķ�Χ(��Ȼ����)
    china_lat_max = 54;
    china_lat_min = 3;
    china_lon_max = 136;
    china_lon_min = 73;

    ap_num = length(ap);
    new_ap_num = 0;
    new_ap_flag = 0;
    
    for i = 1:ap_num
        if ~isempty(ap(i).lat) && ~isempty(ap(i).lon) ...
            && (ap(i).lat >= china_lat_min) && (ap(i).lat <= china_lat_max) ...
            && (ap(i).lon >= china_lon_min) && (ap(i).lon <= china_lon_max)
            
            new_ap_flag = 1;
            new_ap_num = new_ap_num + 1;
            new_ap(new_ap_num) = ap(i);
        end
    end
    
    if new_ap_flag == 0
        %û����Ч���ݣ����Ϊ��
        new_ap = [];
    end
end