function trilateration_schematic_diagram(x,y,r,real_x,real_y)
% ����:
%       ���߶�λʾ��ͼ(trilateration schematic diagram)
% ����:
%       trilateration_schematic_diagram(x,y,r,real_x,real_y)
% ����:
%       access_points(�������Ϣ[x,y,r])
%       x:Բ��x����
%       y:Բ��y����
%       r:Բ�뾶
%       real_x:��λ���x
%       real_y:��λ���y
% ���:
%       none


% access points
% access_points = [20,10;70,0;45,80]; % for debug
data_len = length(x);

% ��Բ
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
% ����
centroid_x = mean(x);
centroid_y = mean(y);
plot(centroid_x,centroid_y,'Marker','v','MarkerSize',6,... 
    'MarkerFaceColor','blue');
hold on
plot(real_x,real_y,'Marker','^','MarkerSize',6,... 
    'MarkerFaceColor','red');

% str_centroid = sprintf('��������:[%0.2f,%0.2f]',centroid_x,centroid_y);
% str_real = sprintf('��ʵ����:[%0.2f,%0.2f]',real_x,real_y);
% text(centroid_x,real_y,str_centroid);
% text(real_x,real_y,str_real);
fprintf('���Ƶ㵽���ľ���:%.4f\n',norm([real_x-centroid_x,real_y-centroid_y]));
axis equal
grid minor
box on
end