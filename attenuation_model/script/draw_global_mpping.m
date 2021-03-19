%% 
clc;
tcf('GMap');
figure('Name','GMap','Color','w');
% rectangle
rectangle('Position',[0,0,16,8],'FaceColor',[0 .5 .5],'EdgeColor','b',...
    'LineWidth',3,'Curvature',.05)
% access points
ap = [1,1;8,1;15,1;15,4;15,7;8,7;1,7;1,4];
hold on
scatter(ap(:,1),ap(:,2),'r*','LineWidth',1)
hold on
for c_i = 1:1:length(ap)
circles(ap(c_i,1),ap(c_i,2),randi(4),'edgecolor',rand(1,3),...
    'facecolor','none','linewidth',2,'linestyle','-.');
hold on
end
plot(randi(15),randi(7),'>','MarkerSize',10)
set(get(gca, 'Title'), 'String', 'BLE Position Map');
axis equal off