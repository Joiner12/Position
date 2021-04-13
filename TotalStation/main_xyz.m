%{
    数据说明:
    ./data_llh.dat 经纬高数据
    ./data_xyz.dat 墨卡托投影数据(经纬高转换数据)
%}
clc
fid = fopen('data_xyz.dat');
tline = fgetl(fid);

tcf('靶点分布');
figure('name','靶点分布');
set(gca,'YDir','reverse');
set(gca,'XDir','reverse');
ylabel('north direction (m)')
xlabel('east direction (m)')
title('靶点分布-XYZ')
text_padding = -0.55;
grid on

wifi_loc = [];
bt_loc   = [];
test_loc = [];
test_name   = {};
anchor_loc  = [];

while ischar(tline)
    str = regexp(tline,',', 'split');
    
    if strcmp(str{2}, 'station')
        tline = fgetl(fid);
        continue;
    end
    
    if strfind(str{1}, 'w')
        hold on
        plot(str2double(str{4}), str2double(str{3}), '+r');
        hold on
        text(str2double(str{4})+text_padding, str2double(str{3})+text_padding, str{1});
        
        wifi_loc = [wifi_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
    end
    
    if strcmp(str{1}(1), 't')
        hold on
        plot(str2double(str{4}), str2double(str{3}), 'og');
        hold on
        text(str2double(str{4})-text_padding, str2double(str{3})-text_padding, str{1});
        
        test_loc = [test_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
        test_name = [test_name; str{1}];
    end
    
    
    if strfind(str{1}, 'b')
        if strfind(str{1}, 'bt')
            hold on
            plot(str2double(str{4}), str2double(str{3}), '*b');
            hold on
            text(str2double(str{4})+text_padding, str2double(str{3})+text_padding, str{1});
            bt_loc = [bt_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
            
        elseif strfind(str{1}, 'base')
        else
            hold on
            plot(str2double(str{4}), str2double(str{3}), '*k');
            hold on
            text(str2double(str{4})+text_padding, str2double(str{3})+text_padding, str{1});
            anchor_loc = [anchor_loc; [str2double(str{4}) str2double(str{3}) str2double(str{5})]];
        end
    end
    
    tline = fgetl(fid);
end

fclose(fid);


%% 可视图
tcf('靶点分布-1')
figure('name','靶点分布-1');
set(gca,'YDir','reverse');
set(gca,'XDir','reverse');
ylabel('north direction (m)')
xlabel('east direction (m)')
title('靶点分布-XYZ')
grid on
hold on
box on
axis equal
plot(anchor_loc(:, 1), anchor_loc(:, 2), '*k')
hold on
plot(wifi_loc(:, 1), wifi_loc(:, 2), '+r')
hold on
plot(bt_loc(:, 1), bt_loc(:, 2), '*b')
hold on
plot(test_loc(:, 1), test_loc(:, 2), 'og')
legend( 'Window Anchor', 'WIFI AP', 'BlueTooth AP', 'Test Target')