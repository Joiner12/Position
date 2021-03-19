function ap = prev_dist_subsection_log_calc(ap, param)
%功能：分段计算距离,依据rssi阈值,不同范围的rssi在对数模型中使用不同的环境参数
%定义：ap = prev_dist_calc(ap, calctype, param)
%参数： 
%    ap：ap数据，依据各个ap数据的rssi计算对应的距离
%    param：距离计算参数,具体如下
%           param.rssi_thr：环境参数分段rssi阈值
%           param.close_range_loss_coef：近距离环境参数
%           param.remote_loss_coef：远距离环境参数
%输出：
%    ap：距离计算后更新的ap数据，更新部分为各自的dist字段，距离单位：m
    
    for i = 1:length(ap)
        if ap(i).rssi >= param.rssi_thr
            %小于rssi阈值,使用近距离的环境参数
            calc_param.rssi_reference = ap(i).rssi_reference;
            calc_param.loss_coef = param.close_range_loss_coef;
            ap(i).dist = prev_dist_logarithmic(ap(i).rssi, calc_param);
        else
            %大于rssi阈值,使用远距离的环境参数
            calc_param.rssi_reference = ap(i).rssi_reference;
            calc_param.loss_coef = param.remote_loss_coef;
            ap(i).dist = prev_dist_logarithmic(ap(i).rssi, calc_param);
        end
    end
end