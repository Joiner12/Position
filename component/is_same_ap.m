function bool = is_same_ap(type, name1, name2, addr1, addr2)
%功能：判断两个ap是否为同一个ap
%定义：bool = is_same_ap(name1, name2, addr1, addr2)
%参数： 
%    type：判断方式,支持模式为'addr'、'name'
%    name1：第一个ap名字
%    name2：第二个ap名字
%    addr1：第一个ap地址
%    addr2：第二个ap地址
%输出：
%    true：两个ap相同
%    false：两个ap不同
%备注：
%    判断ap是否相等可使用名字或者地址，具体使用哪个由函数中type决定，依据具体
%    场景设置，此种设置是由于唯一表征ap的特征值依据具体场景而定，可能为名称也可能
%    为地址（mac地址或蓝牙public类型地址）

    switch type
        case 'addr'
            bool = strcmp(addr1, addr2);
        case 'name'
            bool = strcmp(name1, name2);
        otherwise
            error('比较方式设置错误,没有%s的比较方式', type);
    end
end 