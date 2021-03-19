function [ap_msg, true_pos] = extract_files_apmsg_truepos(files_data, null_val)
%功能：提取各文件的信标数据及真值
%定义：[ap_msg, true_pos] = extract_files_apmsg_truepos(files_data, null_val)
%参数：
%    files_data：各个文件数据（data_import提取出的各个文件的原始数据）
%    null_val：经纬度无效值,经纬度数据为此值时表示其数据无效,例如true_pos{i}(j)
%              中经度或纬度为此值表示true_pos{i}(j)的经纬度无效
%输出：
%    ap_msg：提取出的各个文件的信标数据,细胞数组,具体数据结构如下：
%            ap_msg{i}：第i个文件的信标数据
%            ap_msg{i}{j}：第i个文件中第j帧的信标数据
%    true_pos：提取出的各个文件的位置真值,细胞数组,具体数据结构如下：
%            true_pos{i}：第i个文件的位置真值
%            true_pos{i}(j)：第i个文件中第j帧的位置真值
%            true_pos{i}(j).lat：第i个文件中第j帧的位置真值的纬度
%            true_pos{i}(j).lon：第i个文件中第j帧的位置真值的经度

    file_num = length(files_data);
    ap_msg = cell(file_num, 1);
    true_pos = cell(file_num, 1);
    
    for i = 1:file_num
        %提取各帧信标数据
        ap_msg{i} = extract_frame_ap_msg(files_data{i});
        
        %提取各帧的位置真值
        true_pos{i} = extract_frame_true_pos(files_data{i}, null_val);
    end
end