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
    %           beacon(i).x：UTM:x
    %           beacon(i).y：UTM:y

    %% 原有坐标信息，修改时间2021-05-17 11:46
    %{
    beacon = zeros(0);
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
        [x, y, ~] = latlon_to_xy(ap_lat(i), ap_lon(i));
        beacon(i).x = x;
        beacon(i).y = y;
    end

    %}
    % 原有坐标信息，修改时间：2021-07-02 10:40
    %{
    ap_name = ["oneposHLK 1", "oneposHLK 2", ...
                "oneposHLK 3", "oneposHLK 5", ...
                "oneposHLK 7", "oneposHLK 8"];
    ap_name = ap_name';
    %
    ap_lat = [30.548018797743, 30.548019508539, ...
            30.547880364315, 30.547874726343, ...
            30.547872167734, 30.548014837274];
    ap_lat = ap_lat';
    ap_lon = [104.058730768827, 104.058895271369, ...
            104.058728300713, 104.058889206422, ...
            104.058567643123, 104.058567183453];
    ap_lon = ap_lon';
    %}
    ap_name = ["ope 1", "ope 2", ...
                "ope 3", "ope 5", ...
                "ope 4", "ope 6"];
    ap_name = ap_name';
    %
    ap_lat = [30.547872167734, 30.548014837274, ...
            30.548018797743, 30.548019508539, ...
            30.547874726343, 30.547880364315];
    ap_lat = ap_lat';
    ap_lon = [104.058567643123, 104.058567183453, ...
            104.058730768827, 104.058895271369, ...
            104.058889206422, 104.058728300713];
    ap_lon = ap_lon';
    beacon = zeros(0);
    ap_num = 6; %ap个数

    for i = 1:ap_num
        beacon(i).name = ap_name(i);
        beacon(i).id = i;
        beacon(i).lat = ap_lat(i);
        beacon(i).lon = ap_lon(i);
        [x, y, ~] = latlon_to_xy(ap_lat(i), ap_lon(i));
        beacon(i).x = x;
        beacon(i).y = y;
    end

end
