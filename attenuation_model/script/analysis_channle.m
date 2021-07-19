%% 分析不同距离信道的特征
clc;
files_data = cell(0);
% D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\ch39-1m.txt
file_head = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\ch39-';

for j = 1:18
    full_file_name = strcat(file_head, num2str(j), 'm.txt');
    files_data{j} = get_std_detail_from_file(full_file_name);
end

files_data = reshape(files_data, [length(files_data), 1]);
% get_std_detail_from_file(strcat(file_head,num2str(j),'m.txt'));
%% get std data from file,transfer into structs.
function std_data = get_std_detail_from_file(full_file_name)
    std_data = struct();
    % std_data = cell(0);
    data_out = data_import('datafile', full_file_name);
    % 一个原始数据
    data_out = data_out{1, 1};
    valid_data_cnt = 0;

    for k = 1:length(data_out)

        if ~isempty(data_out{k})
            valid_data_cnt = valid_data_cnt + 1;
            data_temp = data_out{k};
            std_data(valid_data_cnt).name = data_temp.ap_msg.name;
            std_data(valid_data_cnt).rssi = data_temp.ap_msg.rssi;
        end

    end

end
