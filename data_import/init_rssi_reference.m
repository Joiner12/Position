function data = init_rssi_reference(files_data, rssi_reference)
%���ܣ���ʼ��1�״�rssiֵ
%���壺data = init_rssi_reference(files_data, rssi_reference)
%������
%    files_data��ͨ�����ݵ��뺯����data_import������ĸ����ļ�������
%    rssi_reference����ʼ����1�״�rssiֵ
%�����
%    data������1�״�rssiֵ��rssi_reference���������

    data = files_data;
    file_num = length(data);
    for i = 1:file_num
        for j = 1:length(data{i})
            if isempty(data{i}{j})
                continue;
            end

            %�����ű���Ϣ�ֶ�ʱд��1�״�rssiֵ
            fileds = fieldnames(data{i}{j});
            if ismember('ap_msg', fileds)
                for k = 1:length(data{i}{j}.ap_msg)
                    data{i}{j}.ap_msg(k).rssi_reference = rssi_reference;
                end
            end
        end
    end
end