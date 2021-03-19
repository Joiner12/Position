function true_pos = extract_frame_true_pos(frame_data, null_val)
%功能：提取各帧的位置真值
%定义：true_pos = extract_frame_true_pos(frame_data, null_val)
%参数：
%    frame_data：各帧数据（blu_data_file_parsing提取出的单文件的原始数据）
%    null_val：经纬度无效值,经纬度数据为此值时表示其数据无效,例如true_pos(i)中
%              经度或纬度为此值表示true_pos(i)的经纬度无效
%输出：
%    true_pos：提取出的各帧的位置真值据,结构体数组,各个结构体表示各帧的位置真值,
%              具体结构体如下：
%              true_pos(i).lat：纬度
%              true_pos(i).lon：经度

    frame_num = length(frame_data);
    true_pos = repmat(struct('lat', null_val, 'lon', null_val), frame_num, 1);
    
    for i = 1:frame_num
        data = frame_data{i};
        
        if isempty(data)
            continue;
        end
        
        %存在真值字段时保存真值
        fileds = fieldnames(data);
        if ismember('true_pos', fileds)
            true_pos(i) = data.true_pos;
        end
    end
end