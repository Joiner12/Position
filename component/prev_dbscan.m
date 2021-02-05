function cluster_res = prev_dbscan(ap, param)
%功能：DBSCAN聚类
%定义：cluster_res = prev_dbscan(ap, param)
%参数： 
%    ap：ap数据（本算法使用每个ap中的经纬度信息）
%    param：函数参数,具体如下
%           param.radius：核心点邻域半径
%           param.min_points：核心点邻域半径内点数最小值
%输出：
%    cluster_res：聚类结果（其中0表示噪声点，各个值对应ap中各个点，即
%                 cluster_res(1)为ap(1)聚类结果，cluster_res(2)为ap(2)聚类结果...
%                 cluster_res(n)为ap(n)聚类结果）

    ap_num = length(ap); %ap个数
    cluster_res = zeros(ap_num, 1); %初始化所有点聚类号为0（0表示其为非核心点）
    radius = param.radius;
    min_points = param.min_points;
    
    %距离矩阵，存放每个点与所有点之间的距离，矩阵具体形式如下：
    %            p1                 p2             ...   pn
    %             |                  |                    |
    %   p1 --- dist11(p1与p1距离) dist12(p1与p2距离)...dist1n(p1与pn距离)
    %   p2 --- dist21(p2与p1距离) dist22(p2与p2距离)...dist2n(p2与pn距离)
    %   ...        ...                ...          ...    ...
    %   pn --- distn1(pn与p1距离) distn2(pn与p2距离)...distnn(pn与pn距离)
    dist_matrix = zeros(ap_num, ap_num);
    
    %邻域点矩阵，存放每个点的邻域点（邻域半径radius内的点，每个点的邻域内的点的
    %个数可能不一致），矩阵具体形式如下：
    %           idx1                  idx2                ... idxn
    %            |                     |                       |
    %   p1 ---   3(第3点在点1邻域内)    5(第5点在点1邻域内)      0(预留位置)
    %   p2 ---   7(第7点在点2邻域内)    8(第8点在点2邻域内)      0(预留位置)
    %   ...        ...                   ...              ...    ...
    %   pn ---   1(第1点在点n邻域内)    0(预留位置)              0(预留位置)
    neighborhood_matrix = zeros(ap_num, ap_num);
    
    %各个点的邻域内点的个数
    neighborhood_count = zeros(ap_num, 1);
    
    %计算各个点间的距离
    for i = 1:ap_num
        for j = 1:ap_num
            dist_matrix(i, j) = utm_distance(ap(i).lat, ap(i).lon,...
                                             ap(j).lat, ap(j).lon);
        end
    end
    
    %找出各个点的邻域内的所有点及邻域内点的个数
    for i = 1:ap_num
        for j = 1:ap_num
           if (i ~= j) && (dist_matrix(i, j) <= radius)
               neighborhood_count(i) = neighborhood_count(i) + 1;
               neighborhood_matrix(i, neighborhood_count(i)) = j;
           end
        end
    end
    
    %将密度相连的点聚为一类（当前算法有缺陷，会导致聚类不完善，若min_points不为0时，
    %密度相连的点中边界点会被分为噪声点）
    for i = 1:ap_num
        if neighborhood_count(i) >= min_points %判断是否为核心点
            if cluster_res(i) == 0 %当前点初始化为了非核心点，需要初始化核心点类号
                cluster_res(i) = i;
            end
            
            %遍历当前点邻域内所有点，若其也为核心点，归为一类
            for j = 1:neighborhood_count(i)
                if neighborhood_count(neighborhood_matrix(i, j)) >= min_points
                    cluster_res(neighborhood_matrix(i, j)) = cluster_res(i);
                end
            end
        end
    end
end