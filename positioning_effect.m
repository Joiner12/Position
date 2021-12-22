clc;
beacon(1).name = 'Beacon1';
beacon(1).lat = 30.5478754;
beacon(1).lon = 104.0585674;
beacon(2).name = 'Beacon6';
beacon(2).lat = 30.5480148;
beacon(2).lon = 104.0585672;
beacon(3).name = 'Beacon7';
beacon(3).lat = 30.5480188;
beacon(3).lon = 104.0587308;
beacon(4).name = 'Beacon8';
beacon(4).lat = 30.5480195;
beacon(4).lon = 104.0588953;
beacon(5).name = 'Beacon9';
beacon(5).lat = 30.5478747;
beacon(5).lon = 104.0588892;
beacon(6).name = 'Beacon0';
beacon(6).lat = 30.5478767;
beacon(6).lon = 104.0587312;

point(1).name = 'nt2';
point(1).lat = 30.547967082230;
point(1).lon = 104.058615154603;
point(2).name = 'nt2-L3';
point(2).lat = 30.547994139300;
point(2).lon = 104.058614893520;
point(3).name = 'nt2-R5';
point(3).lat = 30.547921987113;
point(3).lon = 104.058615589741;
point(4).name = 'nt2-t5-9';
point(4).lat = 30.547966380195;
point(4).lon = 104.058708952316;
point(5).name = 'nt2-t5-9-L3';
point(5).lat = 30.547993437266;
point(5).lon = 104.058708691259;
point(6).name = 'nt2-t5-9-R5';
point(6).lat = 30.547921285077;
point(6).lon = 104.058709387411;
point(7).name = 'nt2-t5-12';
point(7).lat = 30.547966146168;
point(7).lon = 104.058740218221;
point(8).name = 'nt2-t5-12-L3';
point(8).lat = 30.547993203240;
point(8).lon = 104.058739957172;
point(9).name = 'nt2-t5-12-R5';
point(9).lat = 30.547921051050;
point(9).lon = 104.058740653301;
point(10).name = 'nt2-t5-15';
point(10).lat = 30.547965912134;
point(10).lon = 104.058771484126;
point(11).name = 'nt2-t5-15-L3';
point(11).lat = 30.547992969206;
point(11).lon = 104.058771223086;
point(12).name = 'nt2-t5-15-R5';
point(12).lat = 30.547920817015;
point(12).lon = 104.058771919192;
point(13).name = 't5';
point(13).lat = 30.547965611298;
point(13).lon = 104.058814724652;
point(14).name = 't5-L3';
point(14).lat = 30.547992668369;
point(14).lon = 104.058814463624;
point(15).name = 't5-R5';
point(15).lat = 30.547920516178;
point(15).lon = 104.058815159698;
point(16).name = 't5+3';
point(16).lat = 30.547965837216;
point(16).lon = 104.058845986119;
point(17).name = 't5+3-L3';
point(17).lat = 30.547992894288;
point(17).lon = 104.058845725100;
point(18).name = 't5+3-R5';
point(18).lat = 30.547920742096;
point(18).lon = 104.058846421151;
%--------------------------------------------------------------------------
% ÑÕÉ«±í
c_perfect = [30, 219, 41]./255; % 5m , 95%
c_good = [75, 172, 159]./255; % 5m , 68%
c_bad = [227, 51, 28]./255 % 5m
% 
test_point = struct();
%
test_point(1).lat = 30.54796708;
test_point(1).lon = 104.05861515;
test_point(1).name = 'P30';
test_point(1).effect_color = c_perfect;
%
test_point(2).lat = 30.54799414;
test_point(2).lon = 104.05861489;
test_point(2).name = 'P31';
test_point(2).effect_color = c_perfect;
%
test_point(3).lat = 30.54799344;
test_point(3).lon = 104.05870869;
test_point(3).name = 'P32';
test_point(3).effect_color = c_good;
%
test_point(4).lat = 30.54799320;
test_point(4).lon = 104.05873996;
test_point(4).name = 'P33';
test_point(4).effect_color = c_good;
%
test_point(5).lat = 30.54799297;
test_point(5).lon = 104.05877122;
test_point(5).name = 'P34';
test_point(5).effect_color = c_perfect;
%
test_point(6).lat = 30.54799267;
test_point(6).lon = 104.05881446;
test_point(6).name = 'P35';
test_point(6).effect_color = c_good;
%
test_point(7).lat = 30.54799289;
test_point(7).lon = 104.05884573;
test_point(7).name = 'P36';
test_point(7).effect_color = c_bad;
%
test_point(8).lat = 30.54796584;
test_point(8).lon = 104.05884599;
test_point(8).name = 'P37';
test_point(8).effect_color = c_good;
%
test_point(9).lat = 30.54796561;
test_point(9).lon = 104.05881472;
test_point(9).name = 'P38';
test_point(9).effect_color = c_perfect;
%
test_point(10).lat = 30.54796591;
test_point(10).lon = 104.05877148;
test_point(10).name = 'P39';
test_point(10).effect_color = c_bad;
%
test_point(11).lat = 30.54796615;
test_point(11).lon = 104.05874022;
test_point(11).name = 'P40';
test_point(11).effect_color = c_bad;
%
test_point(12).lat = 30.54796638;
test_point(12).lon = 104.05870895;
test_point(12).name = 'P41';
test_point(12).effect_color = c_bad;
%
test_point(13).lat = 30.54792074;
test_point(13).lon = 104.05884642;
test_point(13).name = 'P42';
test_point(13).effect_color = c_bad;
%
test_point(14).lat = 30.54792052;
test_point(14).lon = 104.05881516;
test_point(14).name = 'P43';
test_point(14).effect_color = c_good;
%
test_point(15).lat = 30.54792082;
test_point(15).lon = 104.05877192;
test_point(15).name = 'P44';
test_point(15).effect_color = c_bad;
%
test_point(16).lat = 30.54792105;
test_point(16).lon = 104.05874065;
test_point(16).name = 'P45';
test_point(16).effect_color = c_bad;
%
test_point(17).lat = 30.54792129;
test_point(17).lon = 104.05870939;
test_point(17).name = 'P46';
test_point(17).effect_color = c_bad;
%
test_point(18).lat = 30.54792199;
test_point(18).lon = 104.05861559;
test_point(18).name = 'P47';
test_point(18).effect_color = c_bad;


tcf('sketch');
figure('name', 'sketch', 'color', 'w');

coef = 0.00001;
line_color = 'k';

plot([beacon(1).lon - coef, beacon(1).lon - coef], [beacon(1).lat - coef, beacon(2).lat + coef], [line_color, '-']);
hold on;

plot([beacon(1).lon - coef, beacon(4).lon + coef], [beacon(2).lat + coef, beacon(2).lat + coef], [line_color, '-']);
hold on;

plot([beacon(4).lon + coef, beacon(4).lon + coef], [beacon(2).lat + coef, beacon(1).lat - coef], [line_color, '-']);
hold on;

plot([beacon(1).lon - coef, beacon(4).lon + coef], [beacon(1).lat - coef, beacon(1).lat - coef], [line_color, '-']);
hold on;

for i = 1:length(beacon)
    plot(beacon(i).lon, beacon(i).lat, 'bd');
    t = text(beacon(i).lon, beacon(i).lat, beacon(i).name, 'Color', 'k', ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    hold on;
end

% for i = 1:length(point)
%     plot(point(i).lon, point(i).lat, 'go');
%     t = text(point(i).lon, point(i).lat, point(i).name, 'Color', 'k', ...
%         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
%     hold on;
% end

for i = 1:length(test_point)
    scatter(test_point(i).lon, test_point(i).lat, 'MarkerEdgeColor', test_point(i).effect_color, ...
        'MarkerFaceColor', test_point(i).effect_color);
    t = text(test_point(i).lon, test_point(i).lat, test_point(i).name, 'Color', 'k', ...
        'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    hold on;
end

xlabel('lon');
ylabel('lat');
