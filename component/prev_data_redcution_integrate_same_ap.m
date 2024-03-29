function new_ap = prev_data_redcution_integrate_same_ap(ap, param)
    %功能：整合相同的ap数据
    %定义：new_ap = prev_data_redcution_integrate_same_ap(ap)
    %参数：
    %    ap：待整合的所有ap数据
    %    param：函数参数,具体如下
    %           param.same_ap_judge_type：相同ap的判断方式
    %输出：
    %    new_ap：整合后的ap数据
    %备注：若整合过程中发现同一个ap存在不同的经纬度，依据整合顺序，更新为最新的经纬度

    if false
        %{
        此类型的变量不支持使用点进行索引。

        出错 prev_data_redcution_integrate_same_ap (line 51)
        new_ap(new_ap_num).name = ap(i).name;

        %}
        new_ap = [];
    else
        new_ap = struct([]);
    end

    ap_num = length(ap);
    new_ap_num = 0;
    same_ap_judge_type = param.same_ap_judge_type;

    for i = 1:ap_num
        isfind = 0;

        for j = 1:new_ap_num

            if is_same_ap(same_ap_judge_type, ...
                    new_ap(j).name, ap(i).name, ...
                    new_ap(j).mac, ap(i).mac)
                %已经找到过相同的ap
                isfind = 1;
                recv_rssi_len = length(new_ap(j).recv_rssi);
                new_ap(j).recv_rssi(recv_rssi_len + 1) = ap(i).rssi;

                % if (new_ap(j).lat ~= ap(i).lat) ...
                %         || (new_ap(j).lon ~= ap(j).lon)

                if ~isequal(new_ap(j).lat, ap(i).lat) ...
                        ||~isequal(new_ap(j).lon, ap(i).lon)
                    warning(['%s(%s)出现不同的经纬度,原经度：%.10f, 原纬度：%.10f,', ...
                            '经度更新为：%.10f, 纬度更新为：%.10f'], ...
                        new_ap(j).name, new_ap(j).mac, new_ap(j).lon, ...
                        new_ap(j).lat, ap(i).lon, ap(i).lat);

                    new_ap(j).lat = ap(i).lat;
                    new_ap(j).lon = ap(i).lon;
                end

                break;
            end

        end

        if isfind == 0
            %新的ap，增加到输出中
            new_ap_num = new_ap_num + 1;
            new_ap(new_ap_num).name = ap(i).name;
            new_ap(new_ap_num).mac = ap(i).mac;
            new_ap(new_ap_num).lat = ap(i).lat;
            new_ap(new_ap_num).lon = ap(i).lon;
            new_ap(new_ap_num).recv_rssi(1) = ap(i).rssi;
            new_ap(new_ap_num).rssi_reference = ap(i).rssi_reference;
            new_ap(new_ap_num).rssi = [];
        end

    end

end
