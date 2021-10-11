function dist = calc_distance_based_on_rssi_clustering(rssi_clustering, varargin)
    % ����:
    %       ����RSSI���������о������
    % ����:
    %       dist = calc_distance_based_on_rssi_clustering(rssi_clustering, varargin)
    % ����:
    %       rssi_clustering,rssi��������(3)
    %       varargin:��������
    % ���:
    %       dist,����(m)
    %%
    dist = -1;
    Beacon_RSSI_Clustering = [-39, -38, -36; ...
                            -45, -44, -41; ...
                            -55, -53, -43; ...
                            -73, -49, -48; ...
                            -55, -47, -44; ...
                            -52, -50, -46; ...
                            -59, -58, -49; ...
                            -55, -53, -51; ...
                            -55, -53, -52; ...
                            -55, -54, -50; ...
                            -62, -59, -58];
    cur_rssi_clustering = sort(rssi_clustering);
    cur_rssi_clustering = reshape(cur_rssi_clustering, [1, size(Beacon_RSSI_Clustering, 2)]);

    if any(cur_rssi_clustering == 0)
        return;
    end

    errs = zeros(size(Beacon_RSSI_Clustering, 1), 1);

    for k = 1:size(Beacon_RSSI_Clustering, 1)
        errs(k) = vecnorm(cur_rssi_clustering - Beacon_RSSI_Clustering(k, :));
    end

    disp(errs);
end
