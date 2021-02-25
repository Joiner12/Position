function different_ap = extract_different_ap_info(data)
%功能：提取出扫描到的所有数据中各个不同ap的信息，
%      其中每个ap的扫描到的rssi按时间顺序排列（扫描的帧序）
%参数：
%data：扫描到的每帧的数据
%输出：
%different_ap：提取出的各个ap的信息

    different_ap = [];
    different_ap_num = 0;

    %提取各帧数据中的ap信息
    frame_num = length(data);
    ap_msg = cell(frame_num, 1);
    
    for i = 1:frame_num
        if isempty(data{i})
            continue;
        end
        
        %存在信标信息字段时提取信标信息
        fileds = fieldnames(data{i});
        
        if ismember('ap_msg', fileds)
            ap_msg{i} = data{i}.ap_msg;
        end
    end
    
    for i = 1:length(ap_msg)
        if isempty(ap_msg{i}) %确定当前帧扫描到信标数据
           continue; 
        end

        frame_ap = ap_msg{i};
        frame_different_ap = [];
        frame_different_ap_num = 0;
        
        %提取每帧中的相同ap数据（当前帧）
        for j = 1:length(frame_ap)    
            ap = frame_ap(j);
            
            %确定扫描到名字和rssi，仅对扫描到名字和rssi的ap进行处理
            if isempty(ap.rssi) && isempty(ap.name)
                continue;
            end
            
            %在已经找到的不同ap中寻找，判断此ap是否为未扫描过的新ap
            %若为新ap，添加到ap列表中
            %若ap列表中已存在此ap，更新列表中此ap的rssi
            new_ap_flag = 1;
            for k = 1:length(frame_different_ap)
                %以名字判断蓝牙，因为蓝牙地址不为public类型时不能唯一表征设备
                if strcmp(frame_different_ap(k).name, ap.name) 
                    %判断相同名字的ap的mac地址是否相同
                    if ~strcmp(frame_different_ap(k).mac, ap.mac)
                        warning(['同一个名字：%s 的ap出现不同的地址：%s和%s,',...
                                 '地址更新为 %s\n'],...
                                frame_different_ap(k).name, ...
                                frame_different_ap(k).mac,...
                                ap.mac, ap.mac);
                        frame_different_ap(k).mac = ap.mac;
                    end

                    new_ap_flag = 0;
                    break;
                end
            end

            if new_ap_flag
                %为新ap，添加到ap列表中
                frame_different_ap_num = frame_different_ap_num + 1;
                frame_different_ap(frame_different_ap_num).name = ap.name;
                frame_different_ap(frame_different_ap_num).mac = ap.mac;
                frame_different_ap(frame_different_ap_num).rssi(1) = ap.rssi;
            else
                %ap列表中已存在此ap，更新列表中此ap的rssi
                frame_different_ap(k).rssi(length(frame_different_ap(k).rssi) + 1) =...
                                                                   ap.rssi;
            end
        end
        
        %整理不同帧间的相同ap数据
        for j = 1:length(frame_different_ap)
            ap = frame_different_ap(j);

            %确定扫描到名字和rssi，仅对扫描到名字和rssi的ap进行处理
            if isempty(ap.rssi) && isempty(ap.name)
                continue;
            end

            %在已经找到的不同ap中寻找，判断此ap是否为未扫描过的新ap
            %若为新ap，添加到ap列表中
            %若ap列表中已存在此ap，更新列表中此ap的rssi
            new_ap_flag = 1;
            for k = 1:length(different_ap)
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
                different_ap(different_ap_num).rssi{1} = ap.rssi;
            else
                %ap列表中已存在此ap，更新列表中此ap的rssi
                different_ap(k).rssi{length(different_ap(k).rssi) + 1} =...
                                                                   ap.rssi;
            end
        end
    end
    
    %计算各帧ap的rssi均值
    for i = 1:length(different_ap)
        ap_scan_frame_num = length(different_ap(i).rssi);
        
        different_ap(i).frame_rssi_mean = zeros(1, ap_scan_frame_num);
        
        for j = 1:ap_scan_frame_num
            different_ap(i).frame_rssi_mean(j) = mean(different_ap(i).rssi{j});
        end
    end
end