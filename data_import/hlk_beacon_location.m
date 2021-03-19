function beacon = hlk_beacon_location()
%���ܣ���ȡ�ű�λ��
%���壺beacon = hlk_beacon_location()
%������
%
%�����
%    beacon�������ű��λ����Ϣ,�ṹ������,������ʽ���£�
%           beacon(i).name���ű�����
%           beacon(i).id���ű�ID��
%           beacon(i).lat���ű�γ��
%           beacon(i).lon���ű꾭��

    beacon = [];
    ap_num = 8; %ap����
    ap_name = 'onepos_HLK_'; %apͳһ���Ʊ��

    %��apγ��
    ap_lat = [30.5478867; 30.5479558; 30.5480210; 30.5480384; ...
              30.5480286; 30.5479562; 30.5478838; 30.5478864];
    
    %��ap����
    ap_lon = [104.0585689; 104.0585699; 104.0585709; 104.0586489; ...
              104.0587327; 104.0587338; 104.0587162; 104.0586441];
          
    for i = 1:ap_num
        beacon(i).name = [ap_name, num2str(i)];
        beacon(i).id = i;
        beacon(i).lat = ap_lat(i);
        beacon(i).lon = ap_lon(i);
    end
end