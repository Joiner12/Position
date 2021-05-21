function lgmf_val = like_gaussian_filter(src_data, half_ksize, mode, varargin)
    %���ܣ����˹��ֵ�˲���
    %���壺lgmf_val = like_gaussian_median_filter(src_data,half_ksize,varargin)
    %������
    %    src_data�����˲���ʸ��ʸ�����ݣ�����Ϊʵ��ʸ��,����ֵ�����յ���ʱ����Զ�������
    %                           ���,����t1ʱ�̴�ŵ�src_data(1),��������t2ʱ�̴��
    %                           ��src_data(2)��
    %    half_ksize: �����˹�ں˴�С��ksize = half_ksize*2 + 1;
    %    mode: �˲���ʽѡ��'median':��ֵ�˲���'mean':��ֵ�˲�
    %    varargin: ��˹ģ����������(miu��sigma)
    %�����
    %    lgmf_val�����˹��ֵ�˲�������

    %%
    if half_ksize <= 0
        error('half_ksize:%.0f ����Ϊ������', half_ksize);
    end

    src_data_len = length(src_data);
    ksize = half_ksize * 2 + 1;

    % ��˹�ֲ�ģ�ͼ���
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
