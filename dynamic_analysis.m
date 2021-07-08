%%
clc;
% markdown_tool.batch_remove('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
markdown_tool.write_to_markdown('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位过程分析.md', ...
    'D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\img\temp-location-1');
%% 
clc;
fileId = fopen('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\temp.md', 'w');
fprintf(fileId,'**%s** \r\n',string(datetime('now')));
fclose(fileId);
%% 
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\temp.mat');
distance = calc_distance_based_on_rssi(trilateration_ap(2));
disp(distance)
