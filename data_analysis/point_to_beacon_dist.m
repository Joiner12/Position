function beacon_info = point_to_beacon_dist(point, beacon_info)
%功能：点位到信标的真实距离
%定义：beacon_info = point_to_beacon_dist(point, beacon_info)
%参数： 
%    point：点位经纬度,结构体,具体形式如下：
%          point.lat：纬度
%          point.lat：经度
%    beacon_info：各个信标的位置信息,结构体数组,具体形式如下：
%                beacon_info(i).name：第i个信标的名称
%                beacon_info(i).id：第i个信标的ID号
%                beacon_info(i).lat：第i个信标的纬度
%                beacon_info(i).lon：第i个信标的经度
%输出：
%    beacon_info：点位到各个信标的距离,结构体数组,具体形式如下：
%                beacon_info(i).name：第i个信标的名称
%                beacon_info(i).id：第i个信标的ID号
%                beacon_info(i).lat：第i个信标的纬度
%                beacon_info(i).lon：第i个信标的经度
%                beacon_info(i).dist：第i个信标与点位的距离
%备注：frame_ap_info(i)及beacon_info(i)元素可多于数明中所提到的元素,但说明中所
%     提到的元素必须存在

    beacon_info_num = length(beacon_info);
    
    for i = 1:beacon_info_num
        beacon_info(i).dist = utm_distance(point.lat, point.lon, ...
                                           beacon_info(i).lat, beacon_info(i).lon);
    end
end