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
lat_e = [30.5479562, 30.5479558, 30.5480210, 30.5480286];
lon_e = [104.0587338, 104.0585699, 104.0585709, 104.0587327];

tcf('hs');
figure('name', 'hs', 'color', 'w');
subplot(311)
plot(x - min(x), y - min(y), '*')
text(x - min(x), y - min(y), name)
subplot(312)
geoplot(lat, lon);
text(lat, lon, name);
hold on
geoplot(lat_e, lon_e,'*');
subplot(313)
geoplot(lat_e, lon_e);
text(lat_e, lon_e, name_e);
