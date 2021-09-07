function static_raw_data_analysis(frame, true_pos)
    frame_len = length(frame);

    ap = [];
    
    for i = 1:frame_len
        cur_frame = frame{i};
        cur_frame_len = length(cur_frame);
        
        for j = 1:cur_frame_len
            cur_ap = cur_frame(j);
            ap_len = length(ap);
            new_ap_flag = 1;
            for k = 1:ap_len
                if ~strcmp(ap(k).name, cur_ap.name)
                    continue;
                end
                
                ap(k).rssi(length(ap(k).rssi) + 1) = cur_ap.rssi;
                
                new_ap_flag = 0;
                
                break;
            end
            
            if new_ap_flag
                ap(ap_len + 1).name = cur_ap.name;
                ap(ap_len + 1).rssi = cur_ap.rssi;
                ap(ap_len + 1).true_dist = 0;
                ap(ap_len + 1).calc_dist = [];
                ap(ap_len + 1).dist_error = [];
            end
        end
    end
    
    beacon = hlk_beacon_location();
        
    beacon = point_to_beacon_dist(true_pos, beacon);
    
    ap_len = length(ap);
    beacon_len = length(beacon);
    for i = 1:ap_len
        ap(i).name = strrep(ap(i).name, '_', ' ');
        cur_ap = ap(i);
        
        for j = 1:beacon_len
            if strcmp(beacon(j).name, cur_ap.name)
                ap(i).true_dist = beacon(j).dist;
            end 
        end
    end
    
    dist_calc_param.logarithmic.loss_coef = -3;
    id = zeros(ap_len, 1);
    
    for i = 1:ap_len
        rssi_len = length(ap(i).rssi);
        
        for j = 1:rssi_len
            tmp_ap.name = strrep(ap(i).name, ' ', '_');
            tmp_ap.rssi = ap(i).rssi(j);
            tmp_ap = prev_dist_calc(tmp_ap, 'redefined_model', dist_calc_param);
            ap(i).calc_dist(j) = tmp_ap.dist;
            ap(i).dist_error(j) = abs(ap(i).calc_dist(j) - ap(i).true_dist);
        end
        
%         [~,remain] = strtok(ap(i).name);
%         id(i) = str2num(remain);
        str = regexp(ap(i).name, '(?<=\w+)\d+', 'match');
        id(i) = str2double(str{1});
    end  
    
    [~, idx] = sort(id);
    
    ap = ap(idx);
    
    h1 = figure();
    set(h1, 'name', '原始rssi统计图');
    color = ['r', 'g', 'b', 'y', 'm', 'c'];
    for i = 1:ap_len
        subplot(3, 2, i);
        plot(ap(i).rssi, [color(i), '*-']);
        hold on;
        title(ap(i).name);
        ylabel('rssi值');
        ylim([-90, -40]);
    end
    
    h2 = figure();
    set(h2, 'name', '原始距离转换统计图');
    color = ['r', 'g', 'b', 'y', 'm', 'c'];
    for i = 1:ap_len
        subplot(3, 2, i);
        plot(ap(i).calc_dist, [color(i), '*-']);
        hold on;
        title([ap(i).name, '-实际距离：', num2str(ap(i).true_dist), 'm']);
        ylabel('距离：m');
        ylim([0, 25]);
    end
   
    h3 = figure();
    set(h3, 'name', '原始距离转换误差统计图');
    color = ['r', 'g', 'b', 'y', 'm', 'c'];
    for i = 1:ap_len
        subplot(3, 2, i);
        plot(ap(i).dist_error, [color(i), '*-']);
        hold on;
        title(ap(i).name);
        ylabel('误差：m');
        ylim([0, 15]);
    end
end