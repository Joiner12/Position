function pos_res = final_scope_filter(cur_pos, ...
        prev_pos, ...
        param)
    %���ܣ���Χ�˲������ݾ�γ�ȷ�Χ�����˵�ǰ��λ���
    %���壺pos_res = final_scope_filter(cur_pos,...
    %                                   prev_pos,...
    %                                   param)
    %������
    %    cur_pos����ǰ��λ���
    %    prev_pos��ǰһ֡��λ���
    %    param����������,��������
    %           param.lat_max��γ�����ֵ
    %           param.lat_min��γ����Сֵ
    %           param.lon_max���������ֵ
    %           param.lon_min��������Сֵ
    %�����
    %    pos_res���˲���λ���������Ϊ�ṹ�壬����Ԫ�����£�
    %             pos_res.lat��γ��
    %             pos_res.lon������

    if isempty(fieldnames(cur_pos))
        %��ǰδ��λ�����
        if isempty(fieldnames(prev_pos))
            %û��ǰһ֡����
            pos_res = struct();
        else
            %��ǰһ֡���ݣ����ǰһ֡����
            pos_res = prev_pos;
        end

    else
        lat_max = param.lat_max;
        lat_min = param.lat_min;
        lon_max = param.lon_max;
        lon_min = param.lon_min;
        %��ǰ��λ�����
        if (cur_pos.lat >= lat_min) && (cur_pos.lat <= lat_max) ...
                && (cur_pos.lon >= lon_min) && (cur_pos.lon <= lon_max)
            %��γ���ھ�γ���޶���Χ��
            pos_res = cur_pos;
        else
            %��γ�ȳ����޶���Χ
            if isempty(fieldnames(prev_pos))
                % û��ǰһ֡���ݴ˴�Ӧ������Ϊ��
                pos_res = struct();
            else
                % ��ǰһ֡���ݣ����ǰһ֡����
                pos_res = prev_pos;
            end

        end

    end

end
