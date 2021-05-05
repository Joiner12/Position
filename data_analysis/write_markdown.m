%% write file to markdown file
% ![location-19](img/location-18.png)
% D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位误差分析.md
clc;
fileId = fopen('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc\定位误差分析.md', 'w');
% <img src="img/location-14.png" alt="location-14" style="zoom:150%;" />
for k = 1:1:44
    fprintf(fileId, 'location error analysis-%s\n', num2str(k));
    % fprintf(fileId, sprintf('![location-%s](img/location-%s.png)\n\n', num2str(k), num2str(k)));
    fprintf(fileId, '%s\n', ...
        sprintf('<img src="img/location-temp%s.png" alt="location-%s" style="zoom:150%%;" />\n\n', ...
        num2str(k), num2str(k)));
end
% location-temp38
winopen('D:\Code\BlueTooth\pos_bluetooth_matlab\Doc');
fclose(fileId);