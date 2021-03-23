function happyEmoji()
fig = figure('MenuBar','none','Color', [0 .62 .376]);  % Shamrock green
ax = axes(fig,'Units','Normalized','Position',[0 0 1 1]);
axis(ax,'off')
axis(ax,'equal')
hold(ax,'on')
xlim(ax,[-1,1]); ylim(ax,[-1,1])
% text(ax, 0, 0, char(9752), 'VerticalAlignment','middle','HorizontalAlignment','center','FontSize', 200)
text(ax, 0, 0, char([55357 56424 8205]), 'VerticalAlignment','middle','HorizontalAlignment','center','FontSize', 200)
man_1 = char([55357 56424 8205]);
str = {man_1,man_1,man_1,man_1};
str = num2cell(str);
th = linspace(-pi/2,pi/2,numel(str)); 
txtHandle = text(ax,sin(th)*.8, cos(th)*.8, str, 'VerticalAlignment','middle','HorizontalAlignment','center','FontSize', 25);
set(txtHandle,{'rotation'}, num2cell(rad2deg(-th')))
thr = 0.0017;
rotateCCW = @(xyz)([cos(thr) -sin(thr) 0; sin(thr), cos(thr), 0; 0 0 1]*xyz.').';
while all(isvalid(txtHandle))
    newposition = rotateCCW(vertcat(txtHandle.Position)); 
    set(txtHandle,{'position'}, mat2cell(newposition,ones(numel(txtHandle),1),3), ...
        {'rotation'}, num2cell([txtHandle.Rotation].'+thr*180/pi))
    drawnow()
end
end