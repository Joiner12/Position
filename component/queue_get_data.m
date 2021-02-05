function data = queue_get_data(queue)
%功能：获取队列中元素
%定义：data = queue_get_data(queue)
%参数： 
%    queue：队列
%输出：
%    data：获取到的队列中的元素（数据结构为细胞数组，data(1)为队列头，data(end)为队列尾）

    data = queue.data;
end 