function different_ap = extract_different_ap_info(data)
%���ܣ���ȡ��ɨ�赽�����������и�����ͬap����Ϣ��
%      ����ÿ��ap��ɨ�赽��rssi��ʱ��˳�����У�ɨ���֡��
%������
%data��ɨ�赽��ÿ֡������
%�����
%different_ap����ȡ���ĸ���ap����Ϣ

    different_ap = [];
    different_ap_num = 0;

    %��ȡ��֡�����е�ap��Ϣ
    frame_num = length(data);
    ap_msg = cell(frame_num, 1);
    
    for i = 1:frame_num
        if isempty(data{i})
            continue;
        end
        
        %�����ű���Ϣ�ֶ�ʱ��ȡ�ű���Ϣ
        fileds = fieldnames(data{i});
        
        if ismember('ap_msg', fileds)
            ap_msg{i} = data{i}.ap_msg;
        end
    end
    
    for i = 1:length(ap_msg)
        if isempty(ap_msg{i}) %ȷ����ǰ֡ɨ�赽�ű�����
           continue; 
        end

        frame_ap = ap_msg{i};
        frame_different_ap = [];
        frame_different_ap_num = 0;
        
        %��ȡÿ֡�е���ͬap���ݣ���ǰ֡��
        for j = 1:length(frame_ap)    
            ap = frame_ap(j);
            
            %ȷ��ɨ�赽���ֺ�rssi������ɨ�赽���ֺ�rssi��ap���д���
            if isempty(ap.rssi) && isempty(ap.name)
                continue;
            end
            
            %���Ѿ��ҵ��Ĳ�ͬap��Ѱ�ң��жϴ�ap�Ƿ�Ϊδɨ�������ap
            %��Ϊ��ap����ӵ�ap�б���
            %��ap�б����Ѵ��ڴ�ap�������б��д�ap��rssi
            new_ap_flag = 1;
            for k = 1:length(frame_different_ap)
                %�������ж���������Ϊ������ַ��Ϊpublic����ʱ����Ψһ�����豸
                if strcmp(frame_different_ap(k).name, ap.name) 
                    %�ж���ͬ���ֵ�ap��mac��ַ�Ƿ���ͬ
                    if ~strcmp(frame_different_ap(k).mac, ap.mac)
                        warning(['ͬһ�����֣�%s ��ap���ֲ�ͬ�ĵ�ַ��%s��%s,',...
                                 '��ַ����Ϊ %s\n'],...
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
                %Ϊ��ap����ӵ�ap�б���
                frame_different_ap_num = frame_different_ap_num + 1;
                frame_different_ap(frame_different_ap_num).name = ap.name;
                frame_different_ap(frame_different_ap_num).mac = ap.mac;
                frame_different_ap(frame_different_ap_num).rssi(1) = ap.rssi;
            else
                %ap�б����Ѵ��ڴ�ap�������б��д�ap��rssi
                frame_different_ap(k).rssi(length(frame_different_ap(k).rssi) + 1) =...
                                                                   ap.rssi;
            end
        end
        
        %����ͬ֡�����ͬap����
        for j = 1:length(frame_different_ap)
            ap = frame_different_ap(j);

            %ȷ��ɨ�赽���ֺ�rssi������ɨ�赽���ֺ�rssi��ap���д���
            if isempty(ap.rssi) && isempty(ap.name)
                continue;
            end

            %���Ѿ��ҵ��Ĳ�ͬap��Ѱ�ң��жϴ�ap�Ƿ�Ϊδɨ�������ap
            %��Ϊ��ap����ӵ�ap�б���
            %��ap�б����Ѵ��ڴ�ap�������б��д�ap��rssi
            new_ap_flag = 1;
            for k = 1:length(different_ap)
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
                different_ap(different_ap_num).rssi{1} = ap.rssi;
            else
                %ap�б����Ѵ��ڴ�ap�������б��д�ap��rssi
                different_ap(k).rssi{length(different_ap(k).rssi) + 1} =...
                                                                   ap.rssi;
            end
        end
    end
    
    %�����֡ap��rssi��ֵ
    for i = 1:length(different_ap)
        ap_scan_frame_num = length(different_ap(i).rssi);
        
        different_ap(i).frame_rssi_mean = zeros(1, ap_scan_frame_num);
        
        for j = 1:ap_scan_frame_num
            different_ap(i).frame_rssi_mean(j) = mean(different_ap(i).rssi{j});
        end
    end
end