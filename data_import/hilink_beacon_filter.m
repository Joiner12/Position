function files_data_filtering = hilink_beacon_filter(files_data, beacon_id)
%功能：HLK板卡信标点过滤
%定义：files_data_filtering = hilink_beacon_filter(files_data, beacon_id)
%参数：
%    files_data：待过滤的各个文件的数据
%    beacon_id：需要过滤的信标的id号,数组
%输出：
%    files_data_filtering：过滤掉beacon_id内信标后的个文件数据

    files_data_filtering = files_data;
    
    if isempty(beacon_id)
        return;
    end
    
    %获取过滤信标的名称
    beacon_num = length(beacon_id);
    filter_beacon_name = cell(beacon_num, 1);
    name_feature = 'one_pos_HLK_';
    for i = 1:beacon_num
       filter_beacon_name{i} = [name_feature, num2str(beacon_id(i))]; 
    end
    
    %逐个文件过滤
    file_num = length(files_data);
    for i = 1:file_num
        %逐帧过滤
        frame_data = files_data{i};
        frame_num = length(frame_data);
        filter_flag = zeros(frame_num, 1);
        
        for j = 1:frame_num
            if ismember(frame_data(j), filter_beacon_name)
                filter_flag(j) = 1;
            end
        end
        
        filter_frame = find(filter_flag);
        frame_data{filter_frame} = [];
        files_data{i} = frame_data;
    end
end