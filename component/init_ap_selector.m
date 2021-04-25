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
    ap_selector.RECVRSSI = zeros([1,scope]);
    ap_selector.LAT = 0;
    ap_selector.LON = 0;
    ap_selector.RSSI = 0;
    ap_selector.RSSI_REF = 0;
end
