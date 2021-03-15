function frame_ap_info = reverse_rssi_basis_log(frame_ap_info, loss_coef)
%功能：依据对数模型和计算的距离逆推rssi
%定义：frame_ap_info = reverse_rssi_basis_log(frame_ap_info, loss_coef)
%参数： 
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).rssi：点位接收到的第i个信标的rssi
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%                   frame_ap_info(i).rssi_reference：第i个信标的1米处rssi
%    loss_coef：路径损耗系数
%输出：
%    frame_ap_info：当前帧各个ap的信息,结构体数组,具体形式如下：
%                   frame_ap_info(i).dist：第i个信标与点位的计算距离,单位：m
%                   frame_ap_info(i).rssi：点位接收到的第i个信标的rssi
%                   frame_ap_info(i).rssi_reference：第i个信标的1米处rssi
%                   frame_ap_info(i).reverse_log_rssi：第i个信标依据对数模型逆推的rssi
%                   frame_ap_info(i).log_rssi_error：第i个信标逆推的rssi与真实rssi的误差
%备注：frame_ap_info(i)元素可多于说明中所提到的元素,但说明中所提到的元素必须存在

    ap_num = length(frame_ap_info);
    
    for i = 1:ap_num
        frame_ap_info(i).reverse_log_rssi = 10 * loss_coef * ...
                                            log10(frame_ap_info(i).dist) + ...
                                            frame_ap_info(i).rssi_reference;
        
        frame_ap_info(i).log_rssi_error = abs(frame_ap_info(i).reverse_log_rssi - ...
                                              frame_ap_info(i).rssi);
    end
end