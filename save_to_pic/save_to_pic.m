%% matlab save figures
%%
clc;
f1 = openfig('test-1.fig');
saveas(f1, 'test-1.png');
imwrite(frame2im(getframe(gcf)), 'test-2.png');
fileId = fopen('test.html', 'w');
% head
fprintf(fileId, '%s\n', '<body style="text-align:center">');
fprintf(fileId, '%s\n', ['<h1>', string(datetime('now', 'Format', 'y-MM-dd H:mm:ss')), '</h1>']);
template_temp = '<div><img src="test-1.png" style="zoom:110%%;" />\n<p style="color:blue;font-size:30px;">label</p></div><hr>\n';
template_temp = strrep(template_temp, 'label', strcat('location-', num2str(1)));
fprintf(fileId, template_temp);
template_temp = '<div><img src="test-2.png" style="zoom:110%%;" />\n<p style="color:blue;font-size:30px;">label</p></div><hr>\n';
template_temp = strrep(template_temp, 'label', strcat('location-', num2str(2)));
fprintf(fileId, template_temp);
fprintf(fileId, '\n');
fprintf(fileId, '%s\n', '</body>');

fclose(fileId);
close(f1)
