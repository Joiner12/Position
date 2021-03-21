function [m_vals,v_vals,k_vals,s_vals] = get_global_std_statistics(parse_data,varargin)
% ���ܣ�
%       �ӽ����ı�׼RSSI������������ȡ��ͬ�����ͳ���������ݽ����
% ���壺
%       [m_vals,v_vals,k_vals,s_vals] = get_global_std_statistics(parse_data,varargin)
% ���룺
%       parse_data(cell):�ɼ�std-rssi�������ݣ�
% �����
%       m_vals:������Ӧ��rssi��ֵ(dB);
%       v_vals:������Ӧ��rssi����(dB^2);
%       k_vals:...............���
%       s_vals:...............ƫ��
%       varargin:
%       'apfilter':�ڵ��˲���
% example:
% [~,~,~,~] = get_global_std_statistics(_,'apfilter',{'HLK_1'})
% ��ȡAP�ְ���HLK_1��������Ϣ


%% ����������
if ~isa(parse_data,'cell')
    error("�����������");
end

%% todo: varargin 
ap_filter = cell(0);
if any(strcmpi(varargin,'apfilter'))
    ap_temp = varargin{find(any(strcmpi(varargin,'apfilter')))+1};
    if isa(ap_temp,'char')
        ap_filter{1,1}  = ap_temp;
    else
        ap_filter = ap_temp;
    end
end


parse_data_len = length(parse_data);
parse_data_temp = parse_data;
parse_data_temp = reshape(parse_data_temp,[parse_data_len,1]);

dist_temp = zeros(0); % ����
% rssi_cell_temp = cell(size(parse_data_len)); %

m_vals = zeros(0);
v_vals = zeros(0);
k_vals = zeros(0);
s_vals = zeros(0);
%% ���վ�������ݽ���������
for i=1:1:parse_data_len
    temp = parse_data_temp{i,1};
    dist_temp(i,1) = temp.distance;
end
dist = sort(dist_temp);

for j = 1:1:parse_data_len
    cur_dist = dist(j);
    for k=1:1:parse_data_len
        if isequal(cur_dist,parse_data_temp{k,1}.distance)
            rssi_temp = parse_data_temp{k,1}.RSSI;
            % [m_val,v_val,k_val,s_val] = get_rssi_statistics(rssi,varargin)
            [m_val,v_val,k_val,s_val] = get_rssi_statistics(rssi_temp);
            m_vals(j,1) = m_val;
            v_vals(j,1) = v_val;
            k_vals(j,1) = k_val;
            s_vals(j,1) = s_val;
            break;
        end
    end
end
end