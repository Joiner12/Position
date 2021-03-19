clear;
clc;

restaurant = {'兰州拉面', '忠忠面', '大米先生', '老麻抄手', '猪脚饭', '黄焖鸡米饭', '乡村基', '独当一面', '乌鸡面', '真霸'};

i = randi([1, 10], 1, 1);

disp(restaurant{i}); 