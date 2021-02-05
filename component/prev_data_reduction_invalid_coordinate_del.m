function new_ap = prev_data_reduction_invalid_coordinate_del(ap)
%功能：剔除经纬度数据无效的ap数据
%定义：new_ap = prev_data_reduction_invalid_coordinate_del(ap)
%参数： 
%    ap：待剔除的所有ap数据
%输出：
%    new_ap：剔除无效ap后剩余的ap数据
%备注：超出中国经纬度范围的数据视为无效数据

    %中国经纬度的范围(自然常数)
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
        %没有有效数据，输出为空
        new_ap = [];
    end
end