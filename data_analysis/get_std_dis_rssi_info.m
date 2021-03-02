function std_dis_rssi = get_std_dis_rssi_info()
% ����:
%       ��������������׼����-RSSI�����ļ�
% ����:
%       std_dis_rssi = get_std_dis_rssi_info(file)
% file��
%       none
% ���:
%       [RSSI]
src_folder = ['D:\Code\BlueTooth\',... 
    'pos_bluetooth_matlab\data\',... 
    '����˥��ģ�ͱ�׼����-data-PartI - ����\'];
for i = 1:1:9
    file_name = fullfile(src_folder,sprintf('��׼����-%dm.txt',i));
    if ~isfile(file_name)
        error('no such file');
    end
    cur_file_id = fopen(file_name,'r');
    if isequal(cur_file_id,0)
        break;
    end
    rssi = zeros(0);
    rssi_cnt = 1;
    % valid file
    while(~feof(cur_file_id))
        cur_line_temp = fgetl(cur_file_id);
        % valid data line
        if contains(cur_line_temp,'APMSG')
            regout = regexp(cur_line_temp,'\s*','split');
            val_temp = regout{4};
            rssi(rssi_cnt) = str2double(val_temp);
            rssi_cnt = rssi_cnt + 1;
        end
    end
    rssi = reshape(rssi,[length(rssi),1]);
    std_dis_rssi = rssi;
    fclose(cur_file_id);
    eval([strcat('m_',num2str(i)),'=std_dis_rssi;']);
    clearvars -except m_* src_folder
    load('D:\Code\BlueTooth\pos_bluetooth_matlab\data\����˥��ģ�ͱ�׼����-data-PartI\std_rssi.mat');
    save('D:\Code\BlueTooth\pos_bluetooth_matlab\data\����˥��ģ�ͱ�׼����-data-PartI\std_rssi.mat',... 
        'm_*','-append');
end
end