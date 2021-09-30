function debug_info()
    system_config = sys_config();
    fprintf('**************************************Debug Info****************************************\n');
    fprintf('origin data:%s\n', system_config.origin_data_file);

    fprintf('true position name:%s\n', system_config.cur_true_pos.name);

    if system_config.save_position_error_statistics_pic
        fprintf('position error statistics:%s\n', system_config.position_error_statistics_pic);
    end

end
