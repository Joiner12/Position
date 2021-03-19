function data = init_rssi_reference(files_data, rssi_reference)
%功能：初始化1米处rssi值
%定义：data = init_rssi_reference(files_data, rssi_reference)
%参数：
%    files_data：通过数据导入函数（data_import）导入的各个文件的数据
%    rssi_reference：初始化的1米处rssi值
%输出：
%    data：加入1米处rssi值（rssi_reference）后的数据

    data = files_data;
    file_num = length(data);
    for i = 1:file_num
        for j = 1:length(data{i})
            if isempty(data{i}{j})
                continue;
            end

            %存在信标信息字段时写入1米处rssi值
            fileds = fieldnames(data{i}{j});
            if ismember('ap_msg', fileds)
                for k = 1:length(data{i}{j}.ap_msg)
                    data{i}{j}.ap_msg(k).rssi_reference = rssi_reference;
                end
            end
        end
    end
end