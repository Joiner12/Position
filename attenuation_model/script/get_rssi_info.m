function rssi = get_rssi_info(data_file,varargin)
% 功能:
%       获取蓝牙数据中所有RSSI值
% 定义:
%       rssi = get_dis_rssi_info(data_file)
% 输入：
%       data_file:文件绝对路径(e.g: d:xx\xx\xx\data.txt)
%       varargin{1}:apmsg滤波器(NAME)
% 输出:
%       rssi:数组


%% 参数检查
if ~isfile(data_file)
    error('no such file: %s\n',data_file);
end

cur_file_id = fopen(data_file,'r');
if isequal(cur_file_id,0)
    warning('file open failed');
end

rssi_temp = zeros(0);
rssi_cnt = 1;

filter_name = '';
if isequal(nargin,2)
    filter_name = varargin{1};
end

% valid file
while(~feof(cur_file_id))
    cur_line_temp = fgetl(cur_file_id);
    % valid data line
    if contains(cur_line_temp,'APMSG')
        regout = regexp(cur_line_temp,'\s*','split');
        if ~isempty(filter_name)
            if contains(regout{2},filter_name)
                val_temp = regout{4};
                rssi_temp(rssi_cnt) = str2double(val_temp);
                rssi_cnt = rssi_cnt + 1;
            end
        else
            val_temp = regout{4};
            rssi_temp(rssi_cnt) = str2double(val_temp);
            rssi_cnt = rssi_cnt + 1;
        end
    end
end

fclose(cur_file_id);
rssi = reshape(rssi_temp,[length(rssi_temp),1]);

end