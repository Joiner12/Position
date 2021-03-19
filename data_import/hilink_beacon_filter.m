function files_data_filtering = hilink_beacon_filter(files_data, beacon_id)
%���ܣ�HLK�忨�ű�����
%���壺files_data_filtering = hilink_beacon_filter(files_data, beacon_id)
%������
%    files_data�������˵ĸ����ļ�������
%    beacon_id����Ҫ���˵��ű��id��,����
%�����
%    files_data_filtering�����˵�beacon_id���ű��ĸ��ļ�����

    files_data_filtering = files_data;
    
    if isempty(beacon_id)
        return;
    end
    
    %��ȡ�����ű������
    beacon_num = length(beacon_id);
    filter_beacon_name = cell(beacon_num, 1);
    name_feature = 'one_pos_HLK_';
    for i = 1:beacon_num
       filter_beacon_name{i} = [name_feature, num2str(beacon_id(i))]; 
    end
    
    %����ļ�����
    file_num = length(files_data);
    for i = 1:file_num
        %��֡����
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