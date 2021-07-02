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
    %           beacon(i).x��UTM:x
    %           beacon(i).y��UTM:y

    %% ԭ��������Ϣ���޸�ʱ��2021-05-17 11:46
    %{
    beacon = zeros(0);
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
        [x, y, ~] = latlon_to_xy(ap_lat(i), ap_lon(i));
        beacon(i).x = x;
        beacon(i).y = y;
    end

    %}
    % ԭ��������Ϣ���޸�ʱ�䣺2021-07-02 10:40
    %{
    ap_name = ["oneposHLK 1", "oneposHLK 2", ...
                "oneposHLK 3", "oneposHLK 5", ...
                "oneposHLK 7", "oneposHLK 8"];
    ap_name = ap_name';
    %
    ap_lat = [30.548018797743, 30.548019508539, ...
            30.547880364315, 30.547874726343, ...
            30.547872167734, 30.548014837274];
    ap_lat = ap_lat';
    ap_lon = [104.058730768827, 104.058895271369, ...
            104.058728300713, 104.058889206422, ...
            104.058567643123, 104.058567183453];
    ap_lon = ap_lon';
    %}
    ap_name = ["ope 1", "ope 2", ...
                "ope 3", "ope 5", ...
                "ope 4", "ope 6"];
    ap_name = ap_name';
    %
    ap_lat = [30.547872167734, 30.548014837274, ...
            30.548018797743, 30.548019508539, ...
            30.547874726343, 30.547880364315];
    ap_lat = ap_lat';
    ap_lon = [104.058567643123, 104.058567183453, ...
            104.058730768827, 104.058895271369, ...
            104.058889206422, 104.058728300713];
    ap_lon = ap_lon';
    beacon = zeros(0);
    ap_num = 6; %ap����

    for i = 1:ap_num
        beacon(i).name = ap_name(i);
        beacon(i).id = i;
        beacon(i).lat = ap_lat(i);
        beacon(i).lon = ap_lon(i);
        [x, y, ~] = latlon_to_xy(ap_lat(i), ap_lon(i));
        beacon(i).x = x;
        beacon(i).y = y;
    end

end
