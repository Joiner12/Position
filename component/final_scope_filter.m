function pos_res = final_scope_filter(cur_pos, ...
        prev_pos, ...
        param)
    %功能：范围滤波，依据经纬度范围，过滤当前定位结果
    %定义：pos_res = final_scope_filter(cur_pos,...
    %                                   prev_pos,...
    %                                   param)
    %参数：
    %    cur_pos：当前定位结果
    %    prev_pos：前一帧定位结果
    %    param：函数参数,具体如下
    %           param.lat_max：纬度最大值
    %           param.lat_min：纬度最小值
    %           param.lon_max：经度最大值
    %           param.lon_min：经度最小值
    %输出：
    %    pos_res：滤波后定位结果，数据为结构体，包含元素如下：
    %             pos_res.lat：纬度
    %             pos_res.lon：经度

    if isempty(fieldnames(cur_pos))
        %当前未定位出结果
        if isempty(fieldnames(prev_pos))
            %没有前一帧数据
            pos_res = struct();
        else
            %有前一帧数据，输出前一帧数据
            pos_res = prev_pos;
        end

    else
        lat_max = param.lat_max;
        lat_min = param.lat_min;
        lon_max = param.lon_max;
        lon_min = param.lon_min;
        %当前定位出结果
        if (cur_pos.lat >= lat_min) && (cur_pos.lat <= lat_max) ...
                && (cur_pos.lon >= lon_min) && (cur_pos.lon <= lon_max)
            %经纬度在经纬度限定范围内
            pos_res = cur_pos;
        else
            %经纬度超出限定范围
            if isempty(fieldnames(prev_pos))
                % 没有前一帧数据此处应该数据为空
                pos_res = struct();
            else
                % 有前一帧数据，输出前一帧数据
                pos_res = prev_pos;
            end

        end

    end

end
