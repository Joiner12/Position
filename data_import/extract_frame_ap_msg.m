function ap_msg = extract_frame_ap_msg(frame_data)
%���ܣ���ȡ��֡�ű�����
%������
%    frame_data����֡���ݣ�blu_data_file_parsing��ȡ���ĵ��ļ���ԭʼ���ݣ�
%�����
%    ap_msg����ȡ���ĸ�֡���ű�����,ϸ������,����ϸ����ʾ��֡���ű�����

    frame_num = length(frame_data);
    ap_msg = cell(frame_num, 1);
    
    for i = 1:frame_num
        data = frame_data{i};
        
        if isempty(data)
            continue;
        end
        
        %�����ű���Ϣ�ֶ�ʱ��ȡ�ű���Ϣ
        fileds = fieldnames(data);
        if ismember('ap_msg', fileds)
            ap_msg{i} = data.ap_msg;
        end
    end
end