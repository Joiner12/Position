function dist = prev_dist_logarithmic(rssi, param)
%���ܣ�rssi����������ģ��
%���壺dist = prev_dist_logarithmic(rssi, param)
%������ 
%    rssi����ת�������rssi
%    param����������,��������
%           param.rssi_reference���źŴ����ο�����d0(d0=1m)�������·�����,��d0��rssi
%           param.loss_coef��·�����ϵ��,һ��ȡ2~3֮��
%�����
%    dist���������ģ�;�������˫���ȴ洢����λ��m

    const = 10; %����ģ�ͳ���
    rssi_reference = param.rssi_reference;
    loss_coef = param.loss_coef;

    dist = const^(abs(rssi - rssi_reference) / (10 * loss_coef));
end 