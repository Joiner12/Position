function cluster_res = prev_dbscan(ap, param)
%���ܣ�DBSCAN����
%���壺cluster_res = prev_dbscan(ap, param)
%������ 
%    ap��ap���ݣ����㷨ʹ��ÿ��ap�еľ�γ����Ϣ��
%    param����������,��������
%           param.radius�����ĵ�����뾶
%           param.min_points�����ĵ�����뾶�ڵ�����Сֵ
%�����
%    cluster_res��������������0��ʾ�����㣬����ֵ��Ӧap�и����㣬��
%                 cluster_res(1)Ϊap(1)��������cluster_res(2)Ϊap(2)������...
%                 cluster_res(n)Ϊap(n)��������

    ap_num = length(ap); %ap����
    cluster_res = zeros(ap_num, 1); %��ʼ�����е�����Ϊ0��0��ʾ��Ϊ�Ǻ��ĵ㣩
    radius = param.radius;
    min_points = param.min_points;
    
    %������󣬴��ÿ���������е�֮��ľ��룬���������ʽ���£�
    %            p1                 p2             ...   pn
    %             |                  |                    |
    %   p1 --- dist11(p1��p1����) dist12(p1��p2����)...dist1n(p1��pn����)
    %   p2 --- dist21(p2��p1����) dist22(p2��p2����)...dist2n(p2��pn����)
    %   ...        ...                ...          ...    ...
    %   pn --- distn1(pn��p1����) distn2(pn��p2����)...distnn(pn��pn����)
    dist_matrix = zeros(ap_num, ap_num);
    
    %�������󣬴��ÿ���������㣨����뾶radius�ڵĵ㣬ÿ����������ڵĵ��
    %�������ܲ�һ�£������������ʽ���£�
    %           idx1                  idx2                ... idxn
    %            |                     |                       |
    %   p1 ---   3(��3���ڵ�1������)    5(��5���ڵ�1������)      0(Ԥ��λ��)
    %   p2 ---   7(��7���ڵ�2������)    8(��8���ڵ�2������)      0(Ԥ��λ��)
    %   ...        ...                   ...              ...    ...
    %   pn ---   1(��1���ڵ�n������)    0(Ԥ��λ��)              0(Ԥ��λ��)
    neighborhood_matrix = zeros(ap_num, ap_num);
    
    %������������ڵ�ĸ���
    neighborhood_count = zeros(ap_num, 1);
    
    %����������ľ���
    for i = 1:ap_num
        for j = 1:ap_num
            dist_matrix(i, j) = utm_distance(ap(i).lat, ap(i).lon,...
                                             ap(j).lat, ap(j).lon);
        end
    end
    
    %�ҳ�������������ڵ����е㼰�����ڵ�ĸ���
    for i = 1:ap_num
        for j = 1:ap_num
           if (i ~= j) && (dist_matrix(i, j) <= radius)
               neighborhood_count(i) = neighborhood_count(i) + 1;
               neighborhood_matrix(i, neighborhood_count(i)) = j;
           end
        end
    end
    
    %���ܶ������ĵ��Ϊһ�ࣨ��ǰ�㷨��ȱ�ݣ��ᵼ�¾��಻���ƣ���min_points��Ϊ0ʱ��
    %�ܶ������ĵ��б߽��ᱻ��Ϊ�����㣩
    for i = 1:ap_num
        if neighborhood_count(i) >= min_points %�ж��Ƿ�Ϊ���ĵ�
            if cluster_res(i) == 0 %��ǰ���ʼ��Ϊ�˷Ǻ��ĵ㣬��Ҫ��ʼ�����ĵ����
                cluster_res(i) = i;
            end
            
            %������ǰ�����������е㣬����ҲΪ���ĵ㣬��Ϊһ��
            for j = 1:neighborhood_count(i)
                if neighborhood_count(neighborhood_matrix(i, j)) >= min_points
                    cluster_res(neighborhood_matrix(i, j)) = cluster_res(i);
                end
            end
        end
    end
end