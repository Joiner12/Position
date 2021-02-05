function queue = queue_push(queue, data)
%功能：新元素加入队列
%定义：queue = queue_push(queue, data)
%参数： 
%    queue：已经初始化好的队列
%    data：待加入队列的元素
%输出：
%    queue：更新后的队列

    if queue.len_limit > 0
        if length(queue.data) >= queue.len_limit
            %队列内元素已经达到上限，队列头加入新元素，队列尾将相应元素出队列
            new_data = cell(length(queue.data) + 1, 1);
            new_data{1} = data;
            if ~isempty(queue.data)
                new_data(2:end) = queue.data;
            end
            new_data = new_data(1:queue.len_limit);
            queue.data = new_data;
        else
            %队列内元素个数未达到上限，直接将元素加入队列
            new_data = cell(length(queue.data) + 1, 1);
            new_data{1} = data;
            if ~isempty(queue.data)
                new_data(2:end) = queue.data;
            end
            queue.data = new_data;
        end
    elseif queue.len_limit == 0
        %队列不限制元素个数，直接将元素加入队列
        new_data = cell(length(queue.data) + 1, 1);
        new_data{1} = data;
        if ~isempty(queue.data)
            new_data(2:end) = queue.data;
        end
        queue.data = new_data;
    else
        %队列元素限制值异常
        error('队列长度设置异常,设置值为:%d,请设置大于0的值', len_limit);
    end
end