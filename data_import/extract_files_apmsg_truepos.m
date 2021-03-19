function [ap_msg, true_pos] = extract_files_apmsg_truepos(files_data, null_val)
%���ܣ���ȡ���ļ����ű����ݼ���ֵ
%���壺[ap_msg, true_pos] = extract_files_apmsg_truepos(files_data, null_val)
%������
%    files_data�������ļ����ݣ�data_import��ȡ���ĸ����ļ���ԭʼ���ݣ�
%    null_val����γ����Чֵ,��γ������Ϊ��ֵʱ��ʾ��������Ч,����true_pos{i}(j)
%              �о��Ȼ�γ��Ϊ��ֵ��ʾtrue_pos{i}(j)�ľ�γ����Ч
%�����
%    ap_msg����ȡ���ĸ����ļ����ű�����,ϸ������,�������ݽṹ���£�
%            ap_msg{i}����i���ļ����ű�����
%            ap_msg{i}{j}����i���ļ��е�j֡���ű�����
%    true_pos����ȡ���ĸ����ļ���λ����ֵ,ϸ������,�������ݽṹ���£�
%            true_pos{i}����i���ļ���λ����ֵ
%            true_pos{i}(j)����i���ļ��е�j֡��λ����ֵ
%            true_pos{i}(j).lat����i���ļ��е�j֡��λ����ֵ��γ��
%            true_pos{i}(j).lon����i���ļ��е�j֡��λ����ֵ�ľ���

    file_num = length(files_data);
    ap_msg = cell(file_num, 1);
    true_pos = cell(file_num, 1);
    
    for i = 1:file_num
        %��ȡ��֡�ű�����
        ap_msg{i} = extract_frame_ap_msg(files_data{i});
        
        %��ȡ��֡��λ����ֵ
        true_pos{i} = extract_frame_true_pos(files_data{i}, null_val);
    end
end