function queue = queue_init(len_limit)
%功能：队列初始化
%定义：queue = queue_init(len_limit)
%参数： 
%    len_limit：队列元素限制值，限制后队列元素个数不会超过此设置值，若调用此函数
%               时，未传入任何参数，则默认队列元素个数不做限制，可无限增加
%输出：
%    queue：初始化好的队列

    input_para_num = nargin; %调用此函数时输入的参数个数
    
    %初始化队列
    queue.data = cell(0);
    
    switch input_para_num
        case 0
            %没有参数输出，队列不限制队列元素个数
            queue.len_limit = 0;
        case 1
            if len_limit <= 0 
                error('队列长度设置异常,设置值为:%d,请设置大于0的值', len_limit);
            end
            %输入一个参数，设置队列元素个数上限值
            queue.len_limit = len_limit;
        otherwise
            error('队列初始化错误，输入参数个数异常');
    end
end