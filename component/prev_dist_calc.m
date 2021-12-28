function ap = prev_dist_calc(ap, calctype, param)
    %功能：计算距离
    %定义：ap = prev_dist_calc(ap, calctype, param)
    %参数：
    %    ap：ap数据，依据各个ap数据的rssi计算对应的距离
    %    calctype：转换方式，支持模式为'logarithmic'、'gausslog'、'piecewise_logarithm'、'quadratic_polynomial'
    %    param：距离计算参数，不同模式需要设置不同的参数，具体如下
    %           经典距离对数模型 -- 'logarithmic'：
    %               param.logarithmic.rssi_reference：信号传播参考距离d0(d0=1m)后产生的路径损耗,即d0处rssi
    %               param.logarithmic.loss_coef：路径损耗系数,一般取2~3之间
    %           距离高斯对数模型 -- 'gausslog'：
    %               param.gausslog.rssi_thr：高斯模型计算的rssi阈值
    %               param.logarithmic.rssi_reference：信号传播参考距离d0(d0=1m)后产生的路径损耗,即d0处rssi
    %               param.logarithmic.loss_coef：路径损耗系数,一般取2~3之间
    %               param.gauss.a：高斯模型参数a
    %               param.gauss.b：高斯模型参数b
    %               param.gauss.b：高斯模型参数c
    %输出：
    %    ap：距离计算后更新的ap数据，更新部分为各自的dist字段，距离单位：m

    for i = 1:length(ap)

        switch calctype
            case 'logarithmic'
                param.logarithmic.rssi_reference = ap(i).rssi_reference;
                ap(i).dist = prev_dist_logarithmic(ap(i).rssi, ...
                    param.logarithmic);
            case 'gausslog'

                if ap(i).rssi < param.gausslog.rssi_thr
                    param.logarithmic.rssi_reference = ap(i).rssi_reference;
                    ap(i).dist = prev_dist_logarithmic(ap(i).rssi, ...
                        param.logarithmic);
                else
                    ap(i).dist = prev_dist_gauss(ap(i).rssi, ...
                        param.gauss);
                end

                % 使用分段拟合对数模型rssi-dist转换
            case 'redefined_model'
                % 2021-12-28 16:34 Wh
                %{
                    说明:
                    1.对数模型加入方差作为距离辅助判断;
                    2.对多径效应下RSSI方差统计分析有如下结论:
                        2.1 RSSI相同,距离越远方差越大.
                    3.方差阈值设定为2.5,RSSI方差小于阈值,距离小于10m,则输出距离按照1.5倍速计算;
                %}
                ap(i).dist = calc_distance_based_on_rssi(ap(i));
                if ap(i).std_rssi~=0 && ap(i).dist <= 10
                    ap(i).dist = 1.5*ap(i).dist;
                end
                
            otherwise
                error('选择的距离计算方式错误,没有%s的计算方式', type);
        end

    end

end
