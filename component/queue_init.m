function queue = queue_init(len_limit)
%���ܣ����г�ʼ��
%���壺queue = queue_init(len_limit)
%������ 
%    len_limit������Ԫ������ֵ�����ƺ����Ԫ�ظ������ᳬ��������ֵ�������ô˺���
%               ʱ��δ�����κβ�������Ĭ�϶���Ԫ�ظ����������ƣ�����������
%�����
%    queue����ʼ���õĶ���

    input_para_num = nargin; %���ô˺���ʱ����Ĳ�������
    
    %��ʼ������
    queue.data = cell(0);
    
    switch input_para_num
        case 0
            %û�в�����������в����ƶ���Ԫ�ظ���
            queue.len_limit = 0;
        case 1
            if len_limit <= 0 
                error('���г��������쳣,����ֵΪ:%d,�����ô���0��ֵ', len_limit);
            end
            %����һ�����������ö���Ԫ�ظ�������ֵ
            queue.len_limit = len_limit;
        otherwise
            error('���г�ʼ������������������쳣');
    end
end