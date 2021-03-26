%% 
clc;
tcf('GMap');
figure('Name','GMap','Color','w');
% rectangle
hold on
rectangle('Position',[0,0,16,8],'FaceColor','none','EdgeColor','r',...
    'LineWidth',2,'LineStyle','-')
% access points
ap = [1,1;8,1;15,1;15,4;15,7;8,7;1,7;1,4];
plot(ap(:,1),ap(:,2))
scatter(ap(:,1),ap(:,2),'r*','LineWidth',1)
for c_i = 1:1:length(ap)
circles(ap(c_i,1),ap(c_i,2),rand()*2,...
    'facecolor','none','linewidth',1,'linestyle','-');
end
plot(randi(15),randi(7),'>','MarkerSize',10)
set(get(gca, 'Title'), 'String', 'BLE Position Map');
hold off
axis('equal');grid('minor');box('on');
