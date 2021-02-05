function different_ap = settle_different_file_ap_in_dist(file_ap_info)
%功能：将各个文件的ap信息按不同ap进行整理，同时整理的数据按照距离递增排序
%参数：
%file_ap_info：各个文件解析整理出的数据
%输出：
%different_ap：提取出的各个ap的信息

    file_num = length(file_ap_info);
    different_ap = [];
    different_ap_num = 0;
    
    %逐个文件整理数据
    for i = 1:file_num
        ap_info = file_ap_info(i);
        ap_num = length(ap_info.ap_info);
        dist = ap_info.dist;
        frame_num_total = ap_info.frame_num_total;
        
        if frame_num_total <= 0
            error('距离为%d的文件解析的总帧数错误： %d', dist, frame_num_total);
        end
        
        %逐个ap整理数据
        for j = 1:ap_num
            ap = ap_info.ap_info(j);
            
            %在已经找到的不同ap中寻找，判断此ap是否为未扫描过的新ap
            %若为新ap，添加到ap列表中
            %若ap列表中已存在此ap，更新列表中此ap的rssi
            new_ap_flag = 1;
            for k = 1:different_ap_num
                %以名字判断蓝牙，因为蓝牙地址会改变
                if strcmp(different_ap(k).name, ap.name)
                    %判断相同名字的ap的mac地址是否相同
                    if ~strcmp(different_ap(k).mac, ap.mac)
                        warning(['同一个名字：%s 的ap出现不同的地址：%s和%s,',...
                                 '地址更新为 %s\n'],...
                                different_ap(k).name, different_ap(k).mac,...
                                ap.mac, ap.mac);
                        different_ap(k).mac = ap.mac;
                    end

                    new_ap_flag = 0;
                    break;
                end
            end
            
            if new_ap_flag
                %为新ap，添加到ap列表中
                different_ap_num = different_ap_num + 1;
                different_ap(different_ap_num).name = ap.name;
                different_ap(different_ap_num).mac = ap.mac;
                
                different_ap(different_ap_num).rssi = cell(1, file_num);
                different_ap(different_ap_num).frame_rssi_mean = ...
                                                         cell(1, file_num);
                different_ap(different_ap_num).dist = zeros(1, file_num);
                different_ap(different_ap_num).frame_num_total = ...
                                                        zeros(1, file_num);
                different_ap(different_ap_num).frame_num_scan = ...
                                                        zeros(1, file_num);
                different_ap(different_ap_num).frame_lose_rate = ...
                                                         ones(1, file_num);
                                                     
                different_ap(different_ap_num).rssi{i} = ap.rssi;
                different_ap(different_ap_num).frame_rssi_mean{i} = ...
                                                        ap.frame_rssi_mean;
                different_ap(different_ap_num).dist(i) = dist;
                different_ap(different_ap_num).frame_num_total(i) = ...
                                                        frame_num_total;
                different_ap(different_ap_num).frame_num_scan(i) = ...
                                                           length(ap.rssi);
                different_ap(different_ap_num).frame_lose_rate(i) = ...
                     (frame_num_total - length(ap.rssi)) / frame_num_total;
            else
                %ap列表中已存在此ap，更新列表中此ap的d信息
                different_ap(k).rssi{i} = ap.rssi;
                different_ap(k).frame_rssi_mean{i} = ap.frame_rssi_mean;
                different_ap(k).dist(i) = dist;
                different_ap(k).frame_num_total(i) = frame_num_total;
                different_ap(k).frame_num_scan(i) = length(ap.rssi);
                different_ap(k).frame_lose_rate(i) = ...
                     (frame_num_total - length(ap.rssi)) / frame_num_total;
            end
        end
    end
    
    %判断是否在相同距离上采集了多份数据
    for i = 1:different_ap_num
        different_dist = unique(different_ap(i).dist);
        count = histc(different_ap(i).dist, different_dist);
        idx = find(count ~= 1);
        
        if ~isempty(idx) && (dist(idx) ~= 0)
            error('在距离%d上解析到多份数据，暂不支持处理相同距离下的多份数据',...
                  different_dist(idx));
        end
    end
    
    %将各个ap的dist与rssi数据按距离由近到远重新排序
    for i = 1:different_ap_num
        dist = different_ap(i).dist;
        frame_rssi_mean = different_ap(i).frame_rssi_mean;
        rssi = different_ap(i).rssi;
        frame_num_total = different_ap(i).frame_num_total;
        frame_num_scan = different_ap(i).frame_num_scan;
        frame_lose_rate = different_ap(i).frame_lose_rate;
        len = length(dist);
        
        frame_rssi_mean_sort = cell(1, len);
        rssi_sort = cell(1, len);
        frame_num_total_sort = zeros(1, len);
        frame_num_scan_sort = zeros(1, len);
        frame_lose_rate_sort = ones(1, len);
        [dist_sort, idx] = sort(dist);
        
        for j = 1:len
            frame_rssi_mean_sort{j} = frame_rssi_mean{idx(j)};
            rssi_sort{j} = rssi{idx(j)};
            frame_num_total_sort(j) = frame_num_total(idx(j));
            frame_num_scan_sort(j) = frame_num_scan(idx(j));
            frame_lose_rate_sort(j) = frame_lose_rate(idx(j));
        end
        
        different_ap(i).dist = dist_sort;
        different_ap(i).rssi = rssi_sort;
        different_ap(i).frame_rssi_mean = frame_rssi_mean_sort;
        different_ap(i).frame_num_total = frame_num_total_sort;
        different_ap(i).frame_num_scan = frame_num_scan_sort;
        different_ap(i).frame_lose_rate = frame_lose_rate_sort;
    end
end