function [m_vals,v_vals,k_vals,s_vals] = get_global_std_statistics(parse_data,varargin)
% 功能：
%       从解析的标准RSSI测试数据中提取不同距离的统计数据数据结果；
% 定义：
%       [m_vals,v_vals,k_vals,s_vals] = get_global_std_statistics(parse_data,varargin)
% 输入：
%       parse_data(cell):采集std-rssi解析数据；
% 输出：
%       m_vals:与距离对应的rssi均值(dB);
%       v_vals:与距离对应的rssi方差(dB^2);
%       k_vals:...............峰度
%       s_vals:...............偏度
%       varargin:
%       'apfilter':节点滤波器
% example:
% [~,~,~,~] = get_global_std_statistics(_,'apfilter',{'HLK_1'})
% 获取AP种包含HLK_1的数据信息


%% 输入参数检查
if ~isa(parse_data,'cell')
    error("输入参数错误");
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

dist_temp = zeros(0); % 距离
% rssi_cell_temp = cell(size(parse_data_len)); %

m_vals = zeros(0);
v_vals = zeros(0);
k_vals = zeros(0);
s_vals = zeros(0);
%% 按照距离对数据进行重排序
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