function Copy_of_blu_data_analyse_dynamic()
%���ܣ���̬���ݷ�����
%��ϸ�����������������ڲ�ͬλ��ɨ�����ݣ���������ɨ�赽�Ĳ�ͬλ�õ����ݰ�ap��ȡ��
%         ����ÿ��ap�ڲ�ͬλ��ɨ�赽��rssi���ݵľ�ֵ������ͼ�У�ͬʱ��ÿ��ap��
%         ��ͬλ�õĶ����ʻ�����ͼ�У��ɷ���ap�ź�������˥������
%��ע���������ļ�����ʽ����Ϊ *_dist���ļ��������һ��_���dist��ʾ���ݲɼ�����

%��ȡ�ļ�
if false
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\data_analysis\apdata.mat');
else
    file_ap_info = struct([]); % struct
    different_ap = struct([]);
    
    % ��file_name : cell
    [file_name, path] = uigetfile('*.*', 'MultiSelect', 'on');
    if ~iscell(file_name)
        tmp = file_name;
        file_name = {''};
        file_name{1} = tmp;
    end
    
    %��ȡÿ���ļ�������
    for i = 1:length(file_name)
        %��ȡ�ļ���
        % file = [path, file_name{i}];
        file = strcat(path,file_name{i});
        
        %�����ļ�����ȡ���ݲɼ��ľ���
        file_split = strsplit(file, '_');
        info = file_split{end};
        
        %�ж��ļ���ʽ�Ƿ���ȷ��*_dist���˴���δ��dist�����жϣ�
        if isempty(info) || (length(file_split) < 2)
            error('�ļ�������%s', file);
        end
        
        %ȥ���ļ����ͣ�.txt .m�ȣ�
        info_split = strsplit(info, '.');
        dist = info_split{1};
        
        %�жϾ�����Ϣ�Ƿ���ȷ��dist�Ƿ�Ϊ��Ч���֣�
        match = regexp(dist, '\d', 'match');
        if isempty(match) || (length(match) ~= length(dist))
            error('�ļ�������%s', file);
        end
        file_ap_info(i).dist = str2double(dist);
        
        % ���ļ����������� data:cell
        [data, file_ap_info(i).frame_num_total] = blu_data_file_parsing(file);
        
        % ��ȡ��ɨ�赽�����������и�����ͬap����Ϣ
        file_ap_info(i).ap_info = extract_different_ap_info(data);
    end
    
    %�������ݲɼ������ap���������ļ�������
    % different_ap:struct
    different_ap = settle_different_file_ap_in_dist(file_ap_info);
    % save('apdata.mat','different_ap','file_ap_info');
    
    %����rssi���������
    different_ap_num = length(different_ap);
    ap_rssi = cell(1, different_ap_num);
    ap_dist = cell(1, different_ap_num);
    ap_frame_lose_rate = cell(1, different_ap_num);
    for i = 1:different_ap_num
        num = 0;
        for j = 1:length(different_ap(i).dist)
            if isempty(different_ap(i).frame_rssi_mean{j}) || ...
                    (different_ap(i).dist(j) == 0)
                continue;
            else
                num = num + 1;
                ap_rssi{i}{num} = different_ap(i).frame_rssi_mean{j};
                ap_dist{i}(num) = different_ap(i).dist(j);
                ap_frame_lose_rate{i}(num) = ...
                    different_ap(i).frame_lose_rate(j);
            end
        end
    end
    save apdata.mat
end
disp('load data finished');
return
%% figure-1 ����rssi�����Ķ�Ӧ��ϵ ��
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    len = length(dist);
    rssi_mean = zeros(1, len);
    for j = 1:len
        rssi_mean(j) = mean(rssi{j});
    end
    % targ = [different_ap(i).name, 'rssi�����Ķ�Ӧ��ϵ'];
    targ = strcat(different_ap(i).name, 'rssi�����Ķ�Ӧ��ϵ');
    draw_rssi_correspondence_distance(dist,rssi_mean,targ)
end

%% figure-2���ƶ����������ı仯����ͼ ��
for i = 1:different_ap_num
    frame_lose_rate = ap_frame_lose_rate{i};
    dist = ap_dist{i};
    targ = strcat(different_ap(i).name, '�����������ı仯����');
    draw_packet_loss_rate(dist,frame_lose_rate,targ)
end

%% ��Ϲ���cftool
for i = 1:different_ap_num
    rssi = ap_rssi{i};
    dist = ap_dist{i};
    targ = strcat(different_ap(i).name, '�������������ı仯����');
    draw_parameter_fitting(dist,rssi,targ)
end

end