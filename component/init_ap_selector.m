function ap_selector = init_ap_selector(scope, varargin)
    % 功能:
    %       初始化AP SELECTOR数据表
    % 定义：
    %       ap_selcetor = init_ap_selector(scope,varargin)
    % 输入：
    %       scope:窗口大小
    %       varargin:扩展参数
    % 输出:
    %       ap_selector:ap selector 表

    %%
    ap_selector = table();
    ap_selector.NAME = string;
    ap_selector.MAC = string;
    ap_selector.RECVRSSI = zeros([1, scope]);
    ap_selector.LAT = 0;
    ap_selector.LON = 0;
    ap_selector.RSSI = 0;
    ap_selector.RSSI_REF = 0;
    % 聚类相关
    rssi_clustering_scope = 21; % 用于聚类RSSI窗口大小

    if any(strcmpi(varargin, 'clustering_scope'))
        rssi_clustering_scope = varargin{find(strcmpi(varargin, 'clustering_scope')) + 1};
    end

    n_cluster = 3; % 簇数目
    ap_selector.RSSI_FOR_CLUSTERING = zeros([1, rssi_clustering_scope]);

    if any(strcmpi(varargin, 'n_cluster'))
        n_cluster = varargin{find(strcmpi(varargin, 'n_cluster')) + 1};
    end

    % 聚类结果
    ap_selector.CLUTERING = zeros([1, n_cluster]);
end
