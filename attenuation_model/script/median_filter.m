function filter_data = median_filter(origin_data, scope_size, varargin)
    % 功能：
    %       对原始数据(一维数据)进行中值滤波
    % 定义：
    %       filter_data = median_filter(origin_data, scope_size, varargin)
    % 输入：
    %       origin_data,原始数据
    %       scope_size,窗口大小
    %       varargin,可变参数
    % 输出：
    %       filter_data,滤波后数据

    % 参数检查
    if ~isequal(size(origin_data, 1), 1) &&~isequal(size(origin_data, 2), 1)
        error('Parameter check error in median filter');
    end

    if scope_size < 2
        error('Parameter check error in median filter');
    end

    len_data_in = length(origin_data);
    origin_data_in = reshape(origin_data, [len_data_in, 1]);
    filter_data = zeros(size(origin_data_in));

    for k = 1:len_data_in

        if k < scope_size + 1 % 数据量小于窗函数时候取可变窗口大小
            data_temp = origin_data_in(1:k);
            data_temp = sort(data_temp);

            if isequal(mod(k, 2), 0)
                % 线性插值
                filter_data(k) = mean(data_temp(k / 2:k / 2 + 1));
            else
                filter_data(k) = data_temp(ceil(k / 2));
            end

        else
            data_temp = origin_data_in(k - scope_size + 1:k);
            data_temp = sort(data_temp);

            if isequal(mod(scope_size, 2), 0)
                filter_data(k) = data_temp(scope_size / 2:scope_size / 2 + 1);
            else
                filter_data(k) = data_temp(ceil(scope_size / 2));
            end

        end

    end

end
