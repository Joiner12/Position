function different_ap = settle_different_file_ap_in_dist(file_ap_info)
%���ܣ��������ļ���ap��Ϣ����ͬap��������ͬʱ��������ݰ��վ����������
%������
%file_ap_info�������ļ����������������
%�����
%different_ap����ȡ���ĸ���ap����Ϣ

    file_num = length(file_ap_info);
    different_ap = [];
    different_ap_num = 0;
    
    %����ļ���������
    for i = 1:file_num
        ap_info = file_ap_info(i);
        ap_num = length(ap_info.ap_info);
        dist = ap_info.dist;
        frame_num_total = ap_info.frame_num_total;
        
        if frame_num_total <= 0
            error('����Ϊ%d���ļ���������֡������ %d', dist, frame_num_total);
        end
        
        %���ap��������
        for j = 1:ap_num
            ap = ap_info.ap_info(j);
            
            %���Ѿ��ҵ��Ĳ�ͬap��Ѱ�ң��жϴ�ap�Ƿ�Ϊδɨ�������ap
            %��Ϊ��ap����ӵ�ap�б���
            %��ap�б����Ѵ��ڴ�ap�������б��д�ap��rssi
            new_ap_flag = 1;
            for k = 1:different_ap_num
                %�������ж���������Ϊ������ַ��ı�
                if strcmp(different_ap(k).name, ap.name)
                    %�ж���ͬ���ֵ�ap��mac��ַ�Ƿ���ͬ
                    if ~strcmp(different_ap(k).mac, ap.mac)
                        warning(['ͬһ�����֣�%s ��ap���ֲ�ͬ�ĵ�ַ��%s��%s,',...
                                 '��ַ����Ϊ %s\n'],...
                                different_ap(k).name, different_ap(k).mac,...
                                ap.mac, ap.mac);
                        different_ap(k).mac = ap.mac;
                    end

                    new_ap_flag = 0;
                    break;
                end
            end
            
            if new_ap_flag
                %Ϊ��ap����ӵ�ap�б���
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
                %ap�б����Ѵ��ڴ�ap�������б��д�ap��d��Ϣ
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
    
    %�ж��Ƿ�����ͬ�����ϲɼ��˶������
    for i = 1:different_ap_num
        different_dist = unique(different_ap(i).dist);
        count = histc(different_ap(i).dist, different_dist);
        idx = find(count ~= 1);
        
        if ~isempty(idx) && (dist(idx) ~= 0)
            error('�ھ���%d�Ͻ�����������ݣ��ݲ�֧�ִ�����ͬ�����µĶ������',...
                  different_dist(idx));
        end
    end
    
    %������ap��dist��rssi���ݰ������ɽ���Զ��������
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