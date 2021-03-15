function frame_ap_info = point_to_beacon_dist_error(frame_ap_info, beacon_info)
%功能：点位到信标的计算距离误差
%定义：frame_ap_info = point_to_beacon_dist_error(frame_ap_info, beacon_info)
%参数： 
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).name：第i个信标的名称
%                   frame_ap_info(i).lat：第i个信标的纬度
%                   frame_ap_info(i).lon：第i个信标的经度
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%    beacon_info：点位到各个信标的信息,结构体数组,具体形式如下：
%                 beacon_info(i).name：第i个信标的名称
%                 beacon_info(i).id：第i个信标的ID号
%                 beacon_info(i).lat：第i个信标的纬度
%                 beacon_info(i).lon：第i个信标的经度
%                 beacon_info(i).dist：第i个信标与点位的实际距离,单位：m
%输出：
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).name：第i个ap的名称
%                   frame_ap_info(i).id：第i个ap的ID号(信标ID号)
%                   frame_ap_info(i).lat：第i个ap的纬度
%                   frame_ap_info(i).lon：第i个ap的经度
%                   frame_ap_info(i).dist：第i个ap与点位的计算距离,单位：m
%                   frame_ap_info(i).true_dist：第i个ap与点位的实际距离,单位：m
%                   frame_ap_info(i).dist_error：第i个ap与点位的实际距离
%                                                和真实距离的误差,单位：m
%备注：frame_ap_info(i)及beacon_info(i)元素可多于说明中所提到的元素,但说明中所
%     提到的元素必须存在

    ap_num = length(frame_ap_info);
    beacon_num = length(beacon_info);
    beacon_name = cell(beacon_num, 1);
    beacon_dist = zeros(beacon_num, 1);
    beacon_id = zeros(beacon_num, 1);
    
    for i = 1:beacon_num
        beacon_name{i} = beacon_info(i).name;
        beacon_dist(i) = beacon_info(i).dist;
        beacon_id(i) = beacon_info(i).id;
    end
    
    for i = 1:ap_num
        true_dist = beacon_dist(ismember(beacon_name, frame_ap_info(i).name) == 1);
        id = beacon_id(ismember(beacon_name, frame_ap_info(i).name) == 1);
        
        if isempty(true_dist)
            frame_ap_info(i).true_dist = -1;
            frame_ap_info(i).dist_error = -1;
            frame_ap_info(i).id = -1;
            continue;
        end
        
        if length(true_dist) > 1
            error(['存在两个相同名字(', frame_ap_info(i).name, ')的信标']);
        end
        
        frame_ap_info(i).id = id;
        frame_ap_info(i).true_dist = true_dist;
        frame_ap_info(i).dist_error = abs(true_dist - frame_ap_info(i).dist);
    end
end