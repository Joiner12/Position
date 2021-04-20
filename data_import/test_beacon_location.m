clc;
beacon = hlk_beacon_location();
x = zeros(0);
y = zeros(0);
name = cell(0);
lat = zeros(0);
lon = zeros(0);

for k = 1:1:length(beacon)
    x(k) = beacon(k).x;
    y(k) = beacon(k).y;
    lat(k) = beacon(k).lat;
    lon(k) = beacon(k).lon;
    name{k} = beacon(k).name;
end

name_e = {'HLK_1', 'HLK_3', 'HLK_7', 'HLK_8'};
lat_e = [30.5480384, 30.5478864, 30.5478867, 30.5480210];
lon_e = [104.0586489, 104.0586441, 104.0585689, 104.0585709];

%厕所门口
lat_tolit = [30.547941771; 30.54793215; 30.54793215; 30.547941771; 30.547941771];
lon_tolit = [104.058569922; 104.058569922; 104.058567998; 104.058568078; 104.058569922];

%货梯门口
lat_lift = [30.547998532; 30.547998532; 30.548011039; 30.548011039; 30.547998532];
lon_lift = [104.058569922; 104.058567998; 104.05856792; 104.058569922; 104.058569922];

tcf('hs');
figure('name', 'hs', 'color', 'w');
subplot(311)
plot(x - min(x), y - min(y), '*')
text(x - min(x), y - min(y), name)

subplot(312)
geoplot(lat, lon);
text(lat, lon, name);
hold on
geoplot(lat_e, lon_e, '*');
hold on
geoplot(lat_tolit, lon_tolit, 'g')
text(lat_tolit(1), lon_tolit(1), 'toilet')

hold on
geoplot(lat_lift, lon_lift, 'r')
text(lat_lift(1), lon_lift(1), 'lift')

subplot(313)
geoplot(lat_e, lon_e);
text(lat_e, lon_e, name_e);
hold on
geoplot(lat_tolit, lon_tolit, 'g')
text(lat_tolit(1), lon_tolit(1), 'toilet')

hold on
geoplot(lat_lift, lon_lift, 'r')
text(lat_lift(1), lon_lift(1), 'lift')

% figure
% geoplot(lat, lon);
% text(lat, lon, name);
% hold on
% geoplot(lat_e, lon_e, '*');
% hold on
% geoplot(lat_tolit, lon_tolit, 'g')
% text(lat_tolit(1), lon_tolit(1), 'toilet')
% 
% hold on
% geoplot(lat_lift, lon_lift, 'r')
% text(lat_lift(1), lon_lift(1), 'lift')
