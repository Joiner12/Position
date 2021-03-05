function position_error_statistics(position, true_position)
%���ܣ�λ�����ͳ��
%������
%    position����ͳ�Ƶ�λ����Ϣ,�ṹ������,����Ԫ�����£�
%              position(i).lat��γ��
%              position(i).lon������
%    true_position��position�и������ʵλ����Ϣ,�ṹ������,������ÿ���ṹ��Ϊ
%                   position�ж�Ӧλ�ýṹ���ʾ��λ�õ���ֵ,��true_position(i)
%                   Ϊposition(i)����ʵֵ,�����鳤�ȱ�����positionһ��,����Ԫ��
%                   ���£�
%                   true_position(i).lat��γ��
%                   true_position(i).lon������

    if length(position) ~= length(true_position)
        flag = ['λ����Ϣ������ֵ������ͬ, position:', num2str(length(position)), ...
                ', true_position: ', num2str(length(true_position))];
        error(flag);
    end

    %% �������ͳ��
    %ͳ�Ƹ����λ�����������С�����ı�׼����ķ�����ľ�����
    num = length(position);
    dist = zeros(num, 1);
    
    for i = 1:num
        dist(i) = utm_distance(position(i).lat, position(i).lon, ...
                               true_position(i).lat, true_position(i).lon);
    end
    
    max_dist = max(dist);
    min_dist = min(dist);
    std_dist = std(dist);
    var_dist = var(dist);
    rms_dist = sqrt(sum(dist.^2) / length(dist));
    
    %ͳ�Ƹ������䷶Χ��λ�õ����,ͳ�Ƶ����ݷ�Χ���£�
    %[0, 5]��,(5, 10]��,(10, 15]��,(15, 20]��,(20, ~]��
    dist_num = zeros(5, 1);
    dist_rate = zeros(5, 1);
    dist_num(1) = length(find(dist <= 5));
    dist_num(2) = length(find((dist > 5) & (dist <= 10)));
    dist_num(3) = length(find((dist > 10) & (dist <= 15)));
    dist_num(4) = length(find((dist > 15) & (dist <= 20)));
    dist_num(5) = length(find(dist > 20));
    
    dist_all = length(dist);
    for i = 1:5
        dist_rate(i) = dist_num(i) / dist_all;
    end
    
    %% �������ͳ��ͼ
    handle = figure();
    set(handle, 'name', 'λ�����ͳ��ͼ');
    
    %���Ƹ���������
    subplot(2, 1, 1);
    plot(dist, 'b*-');
    hold on;
    plot([1, length(dist)], [max_dist, max_dist], 'r--');
    hold on;
    plot([1, length(dist)], [min_dist, min_dist], 'g--');
    hold on;
    plot([1, length(dist)], [std_dist, std_dist], 'c--');
    hold on;
    plot([1, length(dist)], [var_dist, var_dist], 'm--');
    hold on;
    plot([1, length(dist)], [rms_dist, rms_dist], 'k--');
    hold on;
%     str = {['�����', num2str(max_dist), '��'], ...
%            ['��С��', num2str(min_dist), '��'],  ...
%            ['���ı�׼�', num2str(std_dist)], ...
%            ['���ķ��', num2str(var_dist)], ...
%            ['���ľ�������', num2str(rms_dist)]};
% 
%     dim = [.6, .8, .2, .2];       
%     annotation('textbox', dim, 'String',str,'FitBoxToText','on');   
    
%     str = ['�����', num2str(max_dist), '��', newline, ...
%            '��С��', num2str(min_dist), '��', newline, ...
%            '���ı�׼�', num2str(std_dist), newline, ...
%            '���ķ��', num2str(var_dist), newline, ...
%            '���ľ�������', num2str(rms_dist)];
    legend('���', ...
           ['�����', num2str(max_dist), '��'], ...
           ['��С��', num2str(min_dist), '��'], ...
           ['���ı�׼�', num2str(std_dist)], ...
           ['���ķ��', num2str(var_dist)], ...
           ['���ľ�������', num2str(rms_dist)]);
    
    title('����λ�õ�����λ���ף�');
    ylabel('����');
    axis auto;
    
    %������Χ�ֲ�ͼ
    subplot(2, 1, 2);
    bar(1:length(dist_rate), dist_rate);
    set(gca,'XTickLabel',{'[0, 5]��','(5, 10]��','(10, 15]��','(15, 20]��','(20, ~]��'});
    
    for i = 1:length(dist_rate)
        str = [num2str(dist_rate(i) * 100, 3), '%(', num2str(dist_num(i)), ')'];
        text(i, dist_rate(i), str, 'HorizontalAlignment','center', 'VerticalAlignment','bottom');
    end
    
    title('��Χ�ֲ�ͳ��');
    ylabel('��������ٷֱ�');
    axis auto;
    
end