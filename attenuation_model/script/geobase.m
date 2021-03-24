%% Animate Sequence of Latitude and Longitude Coordinates
clc;
data = load('geoSequence.mat');
zoomLevel = 17;
player = geoplayer(data.latitude(1),data.longitude(1),zoomLevel,'HistoryDepth',Inf);
for i = 1:length(data.latitude)
    plotPosition(player,data.latitude(i),data.longitude(i));
    pause(0.01)
end

%% View Position of Vehicle Along Route
% »õÌÝÃÅ¿Ú
clc;
data_door = struct('latitude',...
    [30.547998532,30.547998532,30.548011039,30.548011039],...
    'longitude',...
    [104.058569922, 104.058567998, 104.05856792, 104.058569922]);
name = 'openstreetmap';
url = 'https://a.tile.openstreetmap.org/${z}/${x}/${y}.png';
copyright = char(uint8(169));
attribution = copyright + "OpenStreetMap contributors";
addCustomBasemap(name,url,'Attribution',attribution)
if false
    data = load('geoRoute.mat');
else
    data = data_door;
end
zoomLevel = 12;
player = geoplayer(data.latitude(1),data.longitude(1),zoomLevel);
plotRoute(player,data.latitude,data.longitude);