function beacon = hlk_beacon_location()
%功能：获取信标位置
%定义：beacon = hlk_beacon_location()
%参数：
%
%输出：
%    beacon：各个信标的位置信息,结构体数组,具体形式如下：
%           beacon(i).name：信标名称
%           beacon(i).id：信标ID号
%           beacon(i).lat：信标纬度
%           beacon(i).lon：信标经度

    beacon = [];
    ap_num = 8; %ap个数
    ap_name = 'onepos_HLK_'; %ap统一名称标记

    %各ap纬度
    ap_lat = [30.5478867; 30.5479558; 30.5480210; 30.5480384; ...
              30.5480286; 30.5479562; 30.5478838; 30.5478864];
    
    %各ap经度
    ap_lon = [104.0585689; 104.0585699; 104.0585709; 104.0586489; ...
              104.0587327; 104.0587338; 104.0587162; 104.0586441];
          
    for i = 1:ap_num
        beacon(i).name = [ap_name, num2str(i)];
        beacon(i).id = i;
        beacon(i).lat = ap_lat(i);
        beacon(i).lon = ap_lon(i);
    end
end