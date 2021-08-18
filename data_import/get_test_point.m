function [pos_info] = get_test_point(pos_name, varargin)
    %功能:
    %       获取测试点(静|动)坐标
    %定义:
    %       [lat, lon] = get_test_point(pos_name, varargin)
    %参数：
    %       pos_name,测试点名称(string|cell)
    %       varargin,扩展参数
    %返回:
    % pos_info,测试点信息(struct{ lat lon...})

    %% 静态测试点数据-1
    %{
    P1, 104.058567955784, 30.547914282752, 468.155972989276
    P2, , 104.058615502714, 30.547931006136, 466.862972988747
    P3, , 104.058615850824, 30.547894930042, 466.862972987816
    P4, , 104.058615350415, 30.547946789427, 466.862972987816
    P5, , 104.058616007473, 30.547878695800, 466.848972988315
    P6, , 104.058660192224, 30.547912297694, 468.098972990178
    P7, , 104.058688771294, 30.547945353836, 468.385972986929
    P8, , 104.058709374097, 30.547922664987, 466.862972990610
    P9, , 104.058709548135, 30.547904626940, 466.862972990610
    p10, , 104.058691829034, 30.547880100711, 469.601972987875
    %}
    test_point_1_name = {"P1", "P2", "P3", "P4", "P5", "P6", "P7", "P8", "P9", "P10"};
    test_point_1_lon = [104.058567955784, 104.058615502714, 104.058615850824, ...
                        104.058615350415, 104.058616007473, 104.058660192224, ...
                        104.058688771294, 104.058709374097, 104.058709548135, ...
                        104.058691829034];
    test_point_1_lat = [30.547914282752, 30.547931006136, 30.547894930042, ...
                        30.547946789427, 30.547878695800, 30.547912297694, ...
                        30.547945353836, 30.547922664987, 30.547904626940, ...
                        30.547880100711];
    test_points = struct();

    for k = 1:length(test_point_1_name)
        test_points(k).name = test_point_1_name{k};
        test_points(k).lat = test_point_1_lat(k);
        test_points(k).lon = test_point_1_lon(k);
    end

    %
    pos_info = cell(0);

    if ischar(pos_name) || isstring(pos_name)
        info_found = find_info_by_name(pos_name, test_points);
        pos_info{1} = info_found;
        return;
    end

    if iscell(pos_name) &&~isempty(pos_name)

        for j = 1:length(pos_name)
            pos_info{j} = find_info_by_name(pos_name{j}, test_points);
        end

    end

end

%% static function find infomation by name
function info_found = find_info_by_name(name, org_info)
    info_found = struct();

    for k = 1:length(org_info)

        if strcmp(org_info(k).name, name)
            info_found = org_info(k);
            return;
        end

    end

end
