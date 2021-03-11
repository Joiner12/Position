function ap_msg = extract_frame_ap_msg(frame_data)
%功能：提取各帧信标数据
%参数：
%    frame_data：各帧数据（blu_data_file_parsing提取出的单文件的原始数据）
%输出：
%    ap_msg：提取出的各帧的信标数据,细胞数组,各个细胞表示各帧的信标数据

    frame_num = length(frame_data);
    ap_msg = cell(frame_num, 1);
    
    for i = 1:frame_num
        data = frame_data{i};
        
        if isempty(data)
            continue;
        end
        
        %存在信标信息字段时提取信标信息
        fileds = fieldnames(data);
        if ismember('ap_msg', fileds)
            ap_msg{i} = data.ap_msg;
        end
    end
end