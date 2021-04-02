%% read file from table
clc;
tb_origin = readtable('../data/¾²Ì¬µã-table.txt',...
    'Delimiter',' ',...
    'TextType', 'string','MultipleDelimsAsOne', true)
%% dot handle
clc;
tb_1 = table();
tb_1.name = {'hlk1';'hlk2'}
tb_1.mac = {1;[1 22 3]}
tb_1.name{1}

tb_examp.MAC = strings([5,1])
tb_examp.NAME = strings([5,1])

