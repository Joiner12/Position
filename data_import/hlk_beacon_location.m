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

    %%

    % ap_name = ["ope_0", "ope_1", ...
        %             "ope_6", "ope_7", ...
        %             "ope_8", "ope_9"];
    % ap_name = ap_name';

    % ap_lat = [...
    %         30.547877612483, 30.547875431340, ...
    %         30.547876651150, 30.547945498556, ...
    %         30.547947060736, 30.547945509288];
    % ap_lat = ap_lat';
    % ap_lon = [104.058650814333, 104.058567434469, ...
    %         104.058731202370, 104.058571531249, ...
    %         104.058652885008, 104.058730246223];
    % ap_lon = ap_lon';
    %% update 2021-09-07 15:25
    ap_name = ["Beacon 4", "Beacon 1", ...
                "Beacon 2", "Beacon 3", ...
                "Beacon 5", "Beacon 6", ...
                "Beacon 7", "Beacon 8", ...
                "Beacon 9", "Beacon 0"];

    ap_name = ap_name';
    %

    ap_lat = [30.5478776, 30.5478754, ...
            30.5479455, 30.5479471, ...
            30.5479172, 30.5480148, ...
            30.5480188, 30.5480195, ...
            30.5478747, 30.5478767];

    ap_lat = ap_lat';
    ap_lon = [104.0586508, 104.0585674, ...
            104.0585715, 104.0586529, ...
            104.0586144, 104.0585672, ...
            104.0587308, 104.0588953, ...
            104.0588892, 104.0587312];
    beacon = zeros(0);
    ap_num = length(ap_lon); %ap����

    for i = 1:ap_num
        beacon(i).name = ap_name(i);
        beacon(i).id = i;
        beacon(i).lat = ap_lat(i);
        beacon(i).lon = ap_lon(i);
        [x, y, ~] = latlon_to_xy(ap_lat(i), ap_lon(i));
        beacon(i).x = x;
        beacon(i).y = y;
    end
    % check
    if false
        tcf('check for location');
        figure('name', 'check for location');
        geoplot(ap_lat, ap_lon)
        text(ap_lat, ap_lon, ap_name)
    end

end
