function queue = queue_clear(queue)
%功能：清空队列元素
%定义：queue = queue_clear(queue)
%参数： 
%    queue：已经初始化好的队列
%输出：
%    queue：清空后的队列

    queue.data = cell(0);
end