function bool = is_same_ap(type, name1, name2, addr1, addr2)
%���ܣ��ж�����ap�Ƿ�Ϊͬһ��ap
%���壺bool = is_same_ap(name1, name2, addr1, addr2)
%������ 
%    type���жϷ�ʽ,֧��ģʽΪ'addr'��'name'
%    name1����һ��ap����
%    name2���ڶ���ap����
%    addr1����һ��ap��ַ
%    addr2���ڶ���ap��ַ
%�����
%    true������ap��ͬ
%    false������ap��ͬ
%��ע��
%    �ж�ap�Ƿ���ȿ�ʹ�����ֻ��ߵ�ַ������ʹ���ĸ��ɺ�����type���������ݾ���
%    �������ã���������������Ψһ����ap������ֵ���ݾ��峡������������Ϊ����Ҳ����
%    Ϊ��ַ��mac��ַ������public���͵�ַ��

    switch type
        case 'addr'
            bool = strcmp(addr1, addr2);
        case 'name'
            bool = strcmp(name1, name2);
        otherwise
            error('�ȽϷ�ʽ���ô���,û��%s�ıȽϷ�ʽ', type);
    end
end 