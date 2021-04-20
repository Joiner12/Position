function [f_base, ref_loca] = draw_base_map(varargin)
    % 功能:
    %       绘制已有地图数据图作为其他绘图(动态图)底图
    % 定义:
    %       f_base = draw_base_map(varargin)
    % 输入:
    %       none
    % 输出:
    %       f_base：底图图像句柄
    %       ref_loca:参考点

    %% 参考坐标
    ref_loca = struct('lat', 30.32523571614, 'lon', 104.033144799862);
    [ref_loca_x, ref_loca_y, lam0] = latlon_to_xy(ref_loca.lat, ref_loca.lon);

    %% 点坐标数据-蓝牙
    anchor_1_x = zeros(0);
    anchor_1_y = zeros(0);
    anchor_1_name = cell(0);

    if false
        anchor_1_name = {'1', '2', '3', '4', '5', '6', '7', '8'};
        anchor_1_lat = [30.325284586259, 30.325260700923, 30.325236181531, 30.325237242973, ...
                        30.325237242973, 30.325262719590, 30.325287460597, 30.325288284143];
        anchor_1_lon = [104.033084380912, 104.033084401310, 104.033084300271, 104.033111546027 ...
                        104.033135912516, 104.033143109956, 104.033140627770, 104.033111259491];

        for k1 = 1:1:length(anchor_1_lat)
            [anchor_1_x(k1), anchor_1_y(k1), lam0] = latlon_to_xy(anchor_1_lat(k1), anchor_1_lon(k1));
        end

    else
        beacon = hlk_beacon_location();

        for k = 1:1:length(beacon)
            anchor_1_x(k, 1) = beacon(k).x;
            anchor_1_y(k, 1) = beacon(k).y;
            anchor_1_name{k, 1} = beacon(k).name;
        end

    end

    anchor_1_x = anchor_1_x - ref_loca_x;
    anchor_1_y = anchor_1_y - ref_loca_y;

    %% 点坐标数据-柱子
    anchor_2_name = {'P1', 'P2', 'P3', 'P4'};
    anchor_2_lat = [30.547955238; 30.547965822; 30.547965822; 30.547955238];
    anchor_2_lon = [104.058653621; 104.058653621; 104.05866709; 104.05866709];
    % anchor_2_lat = [30.325264639402, 30.325260886262, 30.325262937174, 30.325266413417];
    % anchor_2_lon = [104.033114916638, 104.033114982865, 104.033119303720, 104.033119562806];
    anchor_2_x = zeros(size(anchor_2_lat));
    anchor_2_y = zeros(size(anchor_2_lat));

    for k2 = 1:1:length(anchor_2_lat)
        [anchor_2_x(k2), anchor_2_y(k2), lam0] = latlon_to_xy(anchor_2_lat(k2), anchor_2_lon(k2));
    end

    anchor_2_x = anchor_2_x - ref_loca_x;
    anchor_2_y = anchor_2_y - ref_loca_y;

    %% 厕所门口
    anchor_3_lat = [30.547941771; 30.54793215; 30.54793215; 30.547941771];
    anchor_3_lon = [104.058569922; 104.058569922; 104.058567998; 104.058568078];
    anchor_3_x = zeros(0);
    anchor_3_y = zeros(0);

    for k1 = 1:1:length(anchor_3_lat)
        [anchor_3_x(k1), anchor_3_y(k1), lam0] = latlon_to_xy(anchor_3_lat(k1), anchor_3_lon(k1));
    end

    anchor_3_x = anchor_3_x - ref_loca_x;
    anchor_3_y = anchor_3_y - ref_loca_y;
    %% 货梯门口
    anchor_4_lat = [30.547998532; 30.547998532; 30.548011039; 30.548011039];
    anchor_4_lon = [104.058569922; 104.058567998; 104.05856792; 104.058569922];
    anchor_4_x = zeros(0);
    anchor_4_y = zeros(0);

    for k1 = 1:1:length(anchor_4_lat)
        [anchor_4_x(k1), anchor_4_y(k1), lam0] = latlon_to_xy(anchor_4_lat(k1), anchor_4_lon(k1));
    end

    anchor_4_x = anchor_4_x - ref_loca_x;
    anchor_4_y = anchor_4_y - ref_loca_y;
    %% 点坐标数据-其他
    % anchor_1_name = {'1', '2', '3', '4', '5', '6', '7', '8'};
    % anchor_1_lat = [];
    % anchor_1_lon = [];

    f = figure('name', 'basemap', 'color', 'w');
    hold on

    %% 外框

    %     rectangle('Position', [0, 0, width_r, height_r]);

    plot(anchor_1_x, anchor_1_y, '^');
    text(anchor_1_x, anchor_1_y, anchor_1_name);

    plot([anchor_2_x; anchor_2_x(1)], [anchor_2_y; anchor_2_y(1)], 'r');
    text(anchor_2_x, anchor_2_y, anchor_2_name);

    plot([anchor_3_x, anchor_3_x(1)], [anchor_3_y, anchor_3_y(1)], 'r');
    text(anchor_3_x(1), anchor_3_y(2), 'tolite');

    plot([anchor_4_x, anchor_4_x(1)], [anchor_4_y, anchor_4_y(1)], 'r');
    text(anchor_4_x(1), anchor_4_y(2), 'lift');

    %% 外框
    if true
        rectangle('Position', [anchor_1_x(1)-2, anchor_1_y(7)-2, ...
                    anchor_1_y(4) - anchor_1_y(7) + 5,...
                    anchor_1_y(6) - anchor_1_y(2) + 20],...
                    'EdgeColor',[103, 201, 28 ]./255,'Linewidth',2)
    end
    title('原有地理信息标志')
    f_base = f;

end
