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
            case 'redefined_model'
                % 2021-12-28 16:34 Wh
                %{
                    ˵��:
                    1.����ģ�ͼ��뷽����Ϊ���븨���ж�;
                    2.�ԶྶЧӦ��RSSI����ͳ�Ʒ��������½���:
                        2.1 RSSI��ͬ,����ԽԶ����Խ��.
                    3.������ֵ�趨Ϊ2.5,RSSI����С����ֵ,����С��10m,��������밴��1.5���ټ���;
                %}
                ap(i).dist = calc_distance_based_on_rssi(ap(i));
                if ap(i).std_rssi~=0 && ap(i).dist <= 10
                    ap(i).dist = 1.5*ap(i).dist;
                end
                
            otherwise
                error('ѡ��ľ�����㷽ʽ����,û��%s�ļ��㷽ʽ', type);
        end

    end

end
