function ap = prev_dist_calc(ap, calctype, param)
    %���ܣ��������
    %���壺ap = prev_dist_calc(ap, calctype, param)
    %������
    %    ap��ap���ݣ����ݸ���ap���ݵ�rssi�����Ӧ�ľ���
    %    calctype��ת����ʽ��֧��ģʽΪ'logarithmic'��'gausslog'��'piecewise_logarithm'��'quadratic_polynomial'
    %    param����������������ͬģʽ��Ҫ���ò�ͬ�Ĳ�������������
    %           ����������ģ�� -- 'logarithmic'��
    %               param.logarithmic.rssi_reference���źŴ����ο�����d0(d0=1m)�������·�����,��d0��rssi
    %               param.logarithmic.loss_coef��·�����ϵ��,һ��ȡ2~3֮��
    %           �����˹����ģ�� -- 'gausslog'��
    %               param.gausslog.rssi_thr����˹ģ�ͼ����rssi��ֵ
    %               param.logarithmic.rssi_reference���źŴ����ο�����d0(d0=1m)�������·�����,��d0��rssi
    %               param.logarithmic.loss_coef��·�����ϵ��,һ��ȡ2~3֮��
    %               param.gauss.a����˹ģ�Ͳ���a
    %               param.gauss.b����˹ģ�Ͳ���b
    %               param.gauss.b����˹ģ�Ͳ���c
    %�����
    %    ap������������µ�ap���ݣ����²���Ϊ���Ե�dist�ֶΣ����뵥λ��m

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

                % ʹ�÷ֶ���϶���ģ��rssi-distת��
            case 'piecewise_logarithm'
                ap(i).dist = calc_distance_based_on_rssi(ap(i));

            case 'quadratic_polynomial'
                ap(i).dist = calc_distance_based_on_rssi(ap(i));
            otherwise
                error('ѡ��ľ�����㷽ʽ����,û��%s�ļ��㷽ʽ', type);
        end

    end

end
