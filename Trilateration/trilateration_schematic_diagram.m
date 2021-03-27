function trilateration_schematic_diagram(x,y,r,real_x,real_y)
% 功能:
%       三边定位示意图(trilateration schematic diagram)
% 定义:
%       trilateration_schematic_diagram(x,y,r,real_x,real_y)
% 输入:
%       access_points(接入点信息[x,y,r])
%       x:圆心x坐标
%       y:圆心y坐标
%       r:圆半径
%       real_x:定位结果x
%       real_y:定位结果y
% 输出:
%       none


% access points
% access_points = [20,10;70,0;45,80]; % for debug
data_len = length(x);

% 画圆
for i_circle = 1:1:data_len
    circles(x(i_circle),y(i_circle),r(i_circle),'facecolor','none',...
        'edgecolor',[254, 97, 0]./255,'linewidth',2,... 
        'LineStyle','-.');
    
    hold on
    line_x_temp = [x(i_circle) real_x];
    line_y_temp = [y(i_circle) real_y];
    line(line_x_temp,line_y_temp,'LineStyle',':','LineWidth',1.5)
end
hold on
scatter(x,y,'Marker','*');
hold on 
% 质心
centroid_x = mean(x);
centroid_y = mean(y);
plot(centroid_x,centroid_y,'Marker','v','MarkerSize',6,... 
    'MarkerFaceColor','blue');
hold on
plot(real_x,real_y,'Marker','^','MarkerSize',6,... 
    'MarkerFaceColor','red');

% str_centroid = sprintf('质心坐标:[%0.2f,%0.2f]',centroid_x,centroid_y);
% str_real = sprintf('真实坐标:[%0.2f,%0.2f]',real_x,real_y);
% text(centroid_x,real_y,str_centroid);
% text(real_x,real_y,str_real);
fprintf('估计点到质心距离:%.4f\n',norm([real_x-centroid_x,real_y-centroid_y]));
axis equal
grid minor
box on
end