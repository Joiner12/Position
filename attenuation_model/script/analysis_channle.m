%% 分析不同距离信道的特征
clc;
files_data = cell(0);
% D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\ch39-1m.txt
file_head = 'D:\Code\BlueTooth\pos_bluetooth_matlab\attenuation_model\data\单信道测试-CH39\ch39-';

for j = 1:18
    full_file_name = strcat(file_head, num2str(j), 'm.txt');
    files_data{j} = get_std_detail_from_file(full_file_name);
end

files_data = reshape(files_data, [length(files_data), 1]);
% get_std_detail_from_file(strcat(file_head,num2str(j),'m.txt'));

%% transport and receive
clc;
%-----------Parameters Setting------------
LightSpeedC = 3e8;
BlueTooth = 2400 * 1000000; %hz
Zigbee = 915.0e6; %hz
Freq = BlueTooth;
TXAntennaGain = 0.5; %db
RXAntennaGain = 1; %db
PTx = 0.001; %watt
sigma = 6; %Sigma from 6 to 12 %Principles of communication systems simulation with wireless application P.548
mean = 0;
PathLossExponent = 2; %Line Of sight

%------------ FRIIS Equation --------------
% Friis free space propagation model:
%        Pt * Gt * Gr * (Wavelength^2)
%  Pr = --------------------------
%        (4 *pi * d)^2 * L

pr_set = [];

for Dref = 0:1:1000
    Wavelength = LightSpeedC / Freq;
    PTxdBm = 10 * log10(PTx * 1000);
    M = Wavelength / (4 * pi * Dref);
    Pr0 = PTxdBm + TXAntennaGain + RXAntennaGain - (20 * log10(1 / M));
    pr_set = [pr_set, Pr0];
end

%% get std data from file,transfer into structs.
function std_data = get_std_detail_from_file(full_file_name)
    std_data = struct();
    % std_data = cell(0);
    data_out = data_import('datafile', full_file_name);
    % 一个原始数据
    data_out = data_out{1, 1};
    valid_data_cnt = 0;

    for k = 1:length(data_out)

        if ~isempty(data_out{k})
            valid_data_cnt = valid_data_cnt + 1;
            data_temp = data_out{k};
            std_data(valid_data_cnt).name = data_temp.ap_msg.name;
            std_data(valid_data_cnt).rssi = data_temp.ap_msg.rssi;
        end

    end

end
