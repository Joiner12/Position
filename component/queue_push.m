function queue = queue_push(queue, data)
%���ܣ���Ԫ�ؼ������
%���壺queue = queue_push(queue, data)
%������ 
%    queue���Ѿ���ʼ���õĶ���
%    data����������е�Ԫ��
%�����
%    queue�����º�Ķ���

    if queue.len_limit > 0
        if length(queue.data) >= queue.len_limit
            %������Ԫ���Ѿ��ﵽ���ޣ�����ͷ������Ԫ�أ�����β����ӦԪ�س�����
            new_data = cell(length(queue.data) + 1, 1);
            new_data{1} = data;
            if ~isempty(queue.data)
                new_data(2:end) = queue.data;
            end
            new_data = new_data(1:queue.len_limit);
            queue.data = new_data;
        else
            %������Ԫ�ظ���δ�ﵽ���ޣ�ֱ�ӽ�Ԫ�ؼ������
            new_data = cell(length(queue.data) + 1, 1);
            new_data{1} = data;
            if ~isempty(queue.data)
                new_data(2:end) = queue.data;
            end
            queue.data = new_data;
        end
    elseif queue.len_limit == 0
        %���в�����Ԫ�ظ�����ֱ�ӽ�Ԫ�ؼ������
        new_data = cell(length(queue.data) + 1, 1);
        new_data{1} = data;
        if ~isempty(queue.data)
            new_data(2:end) = queue.data;
        end
        queue.data = new_data;
    else
        %����Ԫ������ֵ�쳣
        error('���г��������쳣,����ֵΪ:%d,�����ô���0��ֵ', len_limit);
    end
end