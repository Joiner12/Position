%%
clc;
load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\cur_frame.mat');
%%
clc;
ap_selector = init_ap_selector(10);

for i = 1:1:length(cur_frame)
    [trilateration_ap, ap_selector] = pre_statistics_ap_selector(cur_frame, ap_selector);
end
