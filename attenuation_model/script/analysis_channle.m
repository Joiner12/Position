%% ������ͬ�����ŵ�������
clc;
files_data = cell(0);
% D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\���ŵ�����-CH39\ch39-1m.txt
file_head = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\���ŵ�����-CH39\ch39-';

for j = 1:18
    full_file_name = strcat(file_head, num2str(j), 'm.txt');
    data_temp = get_std_detail_from_file(full_file_name);
    files_data{j} = data_temp;
end

% get_std_detail_from_file(strcat(file_head,num2str(j),'m.txt'));
%% get std data from file,transfer into structs.
function std_data = get_std_detail_from_file(full_file_name)
    % std_data = struct();
    std_data = cell(0);
    data_out = data_import('datafile', full_file_name);
    % һ��ԭʼ����
    data_out = data_out{1, 1};
    valid_data_cnt = 0;

    for k = 1:length(data_out)

        if ~isempty(data_out{k})
            valid_data_cnt = valid_data_cnt + 1;
            std_data{valid_data_cnt} = data_out{k};
        end

    end

end
