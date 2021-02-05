function dist = prev_dist_gauss(rssi, param)
%���ܣ�rssi�����˹ģ��
%���壺dist = prev_dist_gauss(rssi, param)
%������ 
%    rssi����ת�������rssi
%    param����������,��������
%           param.a����˹ģ�Ͳ���a
%           param.b����˹ģ�Ͳ���b
%           param.c����˹ģ�Ͳ���c
%�����
%    dist����˹ģ�;�������˫���ȴ洢����λ��m

    a = param.a;
    b = param.b;
    c = param.c;

    dist = a * exp(-((rssi - b) / c)^2);
end