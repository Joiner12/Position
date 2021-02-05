function new_ap = prev_data_redcution_integrate_same_ap(ap, param)
%���ܣ�������ͬ��ap����
%���壺new_ap = prev_data_redcution_integrate_same_ap(ap)
%������ 
%    ap�������ϵ�����ap����
%    param����������,��������
%           param.same_ap_judge_type����ͬap���жϷ�ʽ
%�����
%    new_ap�����Ϻ��ap����
%��ע�������Ϲ����з���ͬһ��ap���ڲ�ͬ�ľ�γ�ȣ���������˳�򣬸���Ϊ���µľ�γ��

    ap_num = length(ap);
    new_ap_num = 0;
    same_ap_judge_type = param.same_ap_judge_type;
    
    for i = 1:ap_num
        isfind = 0;
        
        for j = 1:new_ap_num
            if is_same_ap(same_ap_judge_type,...
                          new_ap(j).name, ap(i).name,...
                          new_ap(j).mac, ap(i).mac)
                %�Ѿ��ҵ�����ͬ��ap
                isfind = 1;
                recv_rssi_len = length(new_ap(j).recv_rssi);
                new_ap(j).recv_rssi(recv_rssi_len + 1) = ap(i).rssi;
                
                if (new_ap(j).lat ~= ap(i).lat) ...
                    || (new_ap(j).lon ~= ap(j).lon)
                    warning(['%s(%s)���ֲ�ͬ�ľ�γ��,ԭ���ȣ�%s, ԭγ�ȣ�%s,', ...
                             '���ȸ���Ϊ��%s, γ�ȸ���Ϊ��%s'], ...
                             new_ap(j).name, new_ap(j).mac, new_ap(j).lon, ...
                             new_ap(j).lat, ap(i).lon, ap(i).lat);
                         
                    new_ap(j).lat = ap(i).lat;
                    new_ap(j).lon = ap(i).lon;
                end
                
                break;
            end
        end
        
        if isfind == 0
            %�µ�ap�����ӵ������
            new_ap_num = new_ap_num + 1;
            new_ap(new_ap_num) = ap(i); 
            new_ap(new_ap_num).recv_rssi(1) = ap(i).rssi;
            new_ap(new_ap_num).rssi = [];
        end
    end
end