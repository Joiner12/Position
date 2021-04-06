%%
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\cur_frame.mat');
%%
clc;
ap_selector = init_ap_selector(10);
[trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector);

%% 
clc;
a = {"one",'pos','d','a'};
str = ["Mary Ann Jones","Paul Jay Burns","John Paul Smith"]
b = strcmp(str,"Mary Ann Jones")
% if strcmp()