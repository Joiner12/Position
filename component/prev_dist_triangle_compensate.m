function ap_new = prev_dist_triangle_compensate(ap, meter)
%功能：距离三角补偿
%定义：pos_res = location_least_squares(ap)
%参数： 
%    ap：参考点信息
%    meter：补偿的高度（单位：米）,参考信息中用于补偿的距离单位为米
%输出：
%    ap_new：距离补偿后的参考点信息,补偿后的距离单位为米

    ap_new = ap;
    ap_num = length(ap_new);
    
    for i = 1:ap_num
        ap_new(i).dist = sqrt(abs(ap_new(i).dist^2 - meter^2));
    end
end