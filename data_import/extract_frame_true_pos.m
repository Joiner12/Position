function true_pos = extract_frame_true_pos(frame_data, null_val)
%���ܣ���ȡ��֡��λ����ֵ
%���壺true_pos = extract_frame_true_pos(frame_data, null_val)
%������
%    frame_data����֡���ݣ�blu_data_file_parsing��ȡ���ĵ��ļ���ԭʼ���ݣ�
%    null_val����γ����Чֵ,��γ������Ϊ��ֵʱ��ʾ��������Ч,����true_pos(i)��
%              ���Ȼ�γ��Ϊ��ֵ��ʾtrue_pos(i)�ľ�γ����Ч
%�����
%    true_pos����ȡ���ĸ�֡��λ����ֵ��,�ṹ������,�����ṹ���ʾ��֡��λ����ֵ,
%              ����ṹ�����£�
%              true_pos(i).lat��γ��
%              true_pos(i).lon������

    frame_num = length(frame_data);
    true_pos = repmat(struct('lat', null_val, 'lon', null_val), frame_num, 1);
    
    for i = 1:frame_num
        data = frame_data{i};
        
        if isempty(data)
            continue;
        end
        
        %������ֵ�ֶ�ʱ������ֵ
        fileds = fieldnames(data);
        if ismember('true_pos', fileds)
            true_pos(i) = data.true_pos;
        end
    end
end