function lgmf_val = like_gaussian_filter(src_data, half_ksize, mode, varargin)
    %功能：类高斯均值滤波器
    %定义：lgmf_val = like_gaussian_median_filter(src_data,half_ksize,varargin)
    %参数：
    %    src_data：待滤波的矢量矢量数据（必须为实数矢量,各个值按接收到的时间由远到近向后
    %                           存放,例如t1时刻存放到src_data(1),接下来的t2时刻存放
    %                           到src_data(2)）
    %    half_ksize: 单向高斯内核大小，ksize = half_ksize*2 + 1;
    %    mode: 滤波方式选择，'median':中值滤波，'mean':均值滤波
    %    varargin: 高斯模型描述参数(miu、sigma)
    %输出：
    %    lgmf_val：类高斯中值滤波后数据

    %%
    if half_ksize <= 0
        error('half_ksize:%.0f 必须为正整数', half_ksize);
    end

    src_data_len = length(src_data);
    ksize = half_ksize * 2 + 1;

    % 高斯分布模型计算
    miu = 0;
    sigma = 1;

    switch nargin
        case 3
            miu = mean(src_data);
            sigma = std(src_data);
        case 5
            miu = varargin{1};
            sigma = varargin{2};
    end

    if src_data_len > ksize
        src_data_lg = src_data(src_data >= miu - half_ksize * sigma & src_data <= miu + half_ksize * sigma);

        if strcmp(mode, 'mean')
            lgmf_val = mean(src_data_lg);
        else
            lgmf_val = median(src_data_lg);
        end

    else
        lgmf_val = src_data_len(end);
    end

end
