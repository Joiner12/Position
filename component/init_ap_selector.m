function ap_selector = init_ap_selector(scope, varargin)
    % ����:
    %       ��ʼ��AP SELECTOR���ݱ�
    % ���壺
    %       ap_selcetor = init_ap_selector(scope,varargin)
    % ���룺
    %       scope:���ڴ�С
    %       varargin:��չ����
    % ���:
    %       ap_selector:ap selector ��

    %%
    ap_selector = table();
    ap_selector.NAME = string;
    ap_selector.MAC = string;
    ap_selector.RECVRSSI = zeros([1,scope]);
    ap_selector.LAT = 0;
    ap_selector.LON = 0;
    ap_selector.RSSI = 0;
    ap_selector.RSSI_REF = 0;
    ap_selector.ACTIVTION = 0; % �����
end