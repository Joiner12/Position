%% check ap info
clc;
ap_name = ["onepos_HLK_1", "onepos_HLK_3", ...
            "onepos_HLK_7", "onepos_HLK_8"];

HLK_1 = struct();
HLK_3 = HLK_1;
HLK_7 = HLK_1;
HLK_8 = HLK_1;
HLK_cnt_1 = 0;
HLK_cnt_3 = 0;
HLK_cnt_7 = 0;
HLK_cnt_8 = 0;

% 读取原始文件
all_lines = cell(0);
line_cnt = 0;
% file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\动态-1-fast-m.txt';
file = 'D:\Code\BlueTooth\pos_bluetooth_matlab\data\动态-2-slow-m.txt';
fileId = fopen(file);

while ~feof(fileId)
    all_lines{line_cnt + 1} = fgetl(fileId);
    line_cnt = line_cnt + 1;
end

fclose(fileId);

%% 拆分数据
for j = 1:1:length(all_lines)
    cur_line = all_lines{j};

    if ~isempty(cur_line)
        line_split = strsplit(cur_line, ' ');

        switch line_split{2}
            case 'onepos_HLK_1'
                HLK_1(HLK_cnt_1 + 1).lat = str2double(line_split{5});
                HLK_1(HLK_cnt_1 + 1).lon = str2double(line_split{6});
                HLK_1(HLK_cnt_1 + 1).mac = line_split{3};
                HLK_cnt_1 = HLK_cnt_1 + 1;
            case 'onepos_HLK_3'
                HLK_3(HLK_cnt_3 + 1).lat = str2double(line_split{5});
                HLK_3(HLK_cnt_3 + 1).lon = str2double(line_split{6});
                HLK_3(HLK_cnt_3 + 1).mac = line_split{3};
                HLK_cnt_3 = HLK_cnt_3 + 1;
            case 'onepos_HLK_7'
                HLK_7(HLK_cnt_7 + 1).lat = str2double(line_split{5});
                HLK_7(HLK_cnt_7 + 1).lon = str2double(line_split{6});
                HLK_7(HLK_cnt_7 + 1).mac = line_split{3};
                HLK_cnt_7 = HLK_cnt_7 + 1;
            case 'onepos_HLK_8'
                HLK_8(HLK_cnt_8 + 1).lat = str2double(line_split{5});
                HLK_8(HLK_cnt_8 + 1).lon = str2double(line_split{6});
                HLK_8(HLK_cnt_8 + 1).mac = line_split{3};
                HLK_cnt_8 = HLK_cnt_8 + 1;
        end

    end

end

%%
for k1 = 1:1:length(HLK_1)
    judge_flag = [~isequal(HLK_1(k1).lat, HLK_1(1).lat), ...
                ~isequal(HLK_1(k1).lon, HLK_1(1).lon), ...
                ~isequal(HLK_1(k1).mac, HLK_1(1).mac)];

    if any(judge_flag)
        disp('1 really diff in some thing');
        find(judge_flag)
        break;
    end

end

for k1 = 1:1:length(HLK_3)
    judge_flag = [~isequal(HLK_3(k1).lat, HLK_3(1).lat), ...
                ~isequal(HLK_3(k1).lon, HLK_3(1).lon), ...
                ~isequal(HLK_3(k1).mac, HLK_3(1).mac)];

    if any(judge_flag)
        disp('3 really diff in some thing');
        find(judge_flag)
        break;
    end

end

for k1 = 1:1:length(HLK_7)
    judge_flag = [~isequal(HLK_7(k1).lat, HLK_7(1).lat), ...
                ~isequal(HLK_7(k1).lon, HLK_7(1).lon), ...
                ~isequal(HLK_7(k1).mac, HLK_7(1).mac)];

    if any(judge_flag)
        disp('7 really diff in some thing');
        find(judge_flag)
        break;
    end

end

for k1 = 1:1:length(HLK_8)
    judge_flag = [~isequal(HLK_8(k1).lat, HLK_8(1).lat), ...
                ~isequal(HLK_8(k1).lon, HLK_8(1).lon), ...
                ~isequal(HLK_8(k1).mac, HLK_8(1).mac)];

    if any(judge_flag)
        disp(' 8 really diff in some thing');
        find(judge_flag)
        break;
    end

end

disp('finished')