function ap_select = prev_rssi_ap_selector(cur_ap, param)
%功能：依据rssi选择ap
%定义：ap_select = prev_rssi_ap_selector(cur_ap, select_len)
%参数： 
%    cur_ap：当前待选择的所有ap数据
%    param：函数参数,具体如下
%           param.select_len：选取的ap个数
%输出：
%    ap_select：选择后的ap数据 

    ap_select = [];
    if isempty(cur_ap)
        return;
    end
    
    select_len = param.select_len;
    
    cur_ap_num = length(cur_ap);
    rssi = zeros(cur_ap_num, 1);
    for i = 1:cur_ap_num
        rssi(i) = cur_ap_num(i).rssi;
    end
    
    %将rssi按降序进行排序
    [rssi_sorted, rssi_idx] = sort(rssi, 'descend');
    
    %选取信号最强的前select_len个ap，若ap个数不足select_len个，则选择全部ap
    if cur_ap_num > select_len
        ap_select = cur_ap(rssi_idx(1:select_len));
    else
        ap_select = cur_ap;
    end
end 