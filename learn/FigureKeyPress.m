%% matlab figure keypressdown callback use
clc;
tcf();
figure('name', 'deserado', 'color', 'w', 'KeyPressFcn', @isEscPressDown);
text(0, 0, 'desperado,why don''t you come to your senses,come down your fences');
axis([-1, 40, -1, 1])

for k = 1:1:100
    pause(0.1);
    if strcmpi(get(gcf, 'CurrentCharacter'),char(27))
        disp('esc pressdown');
        break;
    end
end
disp('function break down');

%% callback function
function isEscPressDown(src, event)
    fprintf('%s\n', get(gcf, 'CurrentCharacter'));
end


