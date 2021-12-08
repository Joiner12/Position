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
    ap_selector.RECVRSSI = zeros([1, scope]);
    ap_selector.LAT = 0;
    ap_selector.LON = 0;
    ap_selector.RSSI = 0;
    ap_selector.RSSI_REF = 0;
    % �������
    rssi_clustering_scope = 21; % ���ھ���RSSI���ڴ�С

    if any(strcmpi(varargin, 'clustering_scope'))
        rssi_clustering_scope = varargin{find(strcmpi(varargin, 'clustering_scope')) + 1};
    end

    n_cluster = 3; % ����Ŀ
    ap_selector.RSSI_FOR_CLUSTERING = zeros([1, rssi_clustering_scope]);

    if any(strcmpi(varargin, 'n_cluster'))
        n_cluster = varargin{find(strcmpi(varargin, 'n_cluster')) + 1};
    end

    % ������
    ap_selector.CLUTERING = zeros([1, n_cluster]);
end
