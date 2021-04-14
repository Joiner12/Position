% function anchor_tb = get_ble_anchor()
% 功能:
%       获取蓝牙信标坐标(latitude longitude height)
% 定义:
%       function get_ble_anchor()
% 输入:
%       none
% 输出:
%       anchor_tb:信标坐标(table)

%%
anchor_tb = table();
load('D:\Code\BlueTooth\pos_bluetooth_matlab\TotalStation\datallh.mat');
ap_index = linspace(1, 8, 8);
name = ['onepos_HLK_1', 'onepos_HLK_2', 'onepos_HLK_3', ...
        'onepos_HLK_4', 'onepos_HLK_5', 'onepos_HLK_6', ...
        'onepos_HLK_7', 'onepos_HLK_8'];
% lat = bt_tab.lat;
% lon = bt_tab.lon;
% anchor_tb.name = name(ap_index);
% anchor_tb.lat = lat(ap_index);
% anchor_tb.lon = lon(ap_index);

position = {cursor_info_1.Position, cursor_info_2.Position, ...
            cursor_info_3.Position, cursor_info_4.Position, ...
            cursor_info_5.Position, cursor_info_6.Position, ...
            cursor_info_7.Position, cursor_info_8.Position};

for k = 1:1:length(position)
    temp = position{k};
    fprintf('******BLE:%.0f******\n',k);
    fprintf('lat:%0.12f\nlon:%0.12f\n',temp(1),temp(2));
    
    % disp(position{k});
end

% end
