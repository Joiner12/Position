function draw_trajectory_and_error_diagram(position, ...
                                           null_val, ...
                                           env_feat, ...
                                           beacon_position, ...
                                           draw_type, ...
                                           varargin)
%���ܣ����ƹ켣�����ͼ,�����ļ������ݵ�������,���������һ���龰��
%      1����ǰ�ļ���λ����ֵ��Ч�����ƴ���ֵ�켣�Ĺ켣ͼ�����ͼ
%      2����ǰ�ļ���λ����ֵ��Ч�����Ʋ�����ֵ�켣�Ĺ켣ͼ
%      λ����ֵ������������ʱ��Ч,������Ч��
%      1����ֵ�����붨λ���������ͬ
%      2��ÿ֡��������ֵ����γ��ֵ������Чֵ��
%���壺draw_trajectory_and_error_diagram(position, ...
%                                        null_val, ...
%                                        env_feat, ...
%                                        beacon_position, ...
%                                        draw_type, ...
%                                        varargin)
%������
%    position�������Ƶ�λ������,Ԫ������,����ṹ������ʾ��
%              position{i}����i���ļ��Ĵ���������
%              position{i}.pos_res����i���ļ��Ķ�λ���
%              position{i}.true_pos����i���ļ���λ����ֵ
%              position{i}.pos_res{j}����i���ļ���j֡�Ķ�λ���
%              position{i}.pos_res{j}.lat����i���ļ���j֡�Ķ�λ�����γ��
%              position{i}.pos_res{j}.lon����i���ļ���j֡�Ķ�λ����ľ���
%              position{i}.true_pos(j)����i���ļ���j֡��λ����ֵ
%              position{i}.true_pos(j).lat����i���ļ���j֡��λ����ֵ��γ��
%              position{i}.true_pos(j).lon����i���ļ���j֡��λ����ֵ�ľ���
%    null_val����γ����Чֵ,��γ������Ϊ��ֵʱ��ʾ��������Ч,����position{i}.true_pos(j)
%              �о��Ȼ�γ��Ϊ��ֵ��ʾposition{i}.true_pos(j)�ľ�γ����Ч
%    env_feat����������,Ԫ������,ÿ��Ԫ����ʾһ����������������Ϊ�ṹ��,������ 
%              ����ʾ��
%              env_feat{i}.type�������������Ʒ�ʽ,����������ʾ��
%                                'closed_cycle'�����Ʊջ�ͼ��
%                                'not_closed'�����ƷǱջ�ͼ��
%              env_feat{i}.position���ؼ����λ����Ϣ,�ṹ������,��ͼʱ�Ὣ��
%                                    ����ؼ���λ��������,����˳��
%                                    env_feat{i}.position˳��,��
%                                    env_feat{i}.position(1)Ϊ��һ����,
%                                    env_feat{i}.position(2)Ϊ�ڶ�����,
%                                    �Դ�����,����Ԫ�����£�
%                                    env_feat{i}.position(j).lat��γ��
%                                    env_feat{i}.position(j).lon������
%    beacon_position���ű�λ����Ϣ,�ṹ������,����Ԫ�����£�
%                     beacon_position(i).id���ű���
%                     beacon_position(i).lat��γ��(latitude)
%                     beacon_position(i).lon������(longitude)
%    draw_type���켣���Ʒ�ʽ,�������£�
%               'splashes'������ɢ�㣬�����ƹ켣
%               'trajectory'�����ƹ켣���켣����˳��track_position˳��,��
%                             track_position(1)Ϊ��һ�����λ��,track_position(2)
%                             Ϊ�ڶ������λ��,�Դ�����
%�ɱ������
%    ���鴫��,�����͸���˳��������,�����������ݸ�ʽ�����ϸ����[type, param]
%    ��ʽ,��֧�ֵĸ��鹦�����£�
%    ��һ�飺
%          ��ʽ��'filter_point', filter_points
%          ����˵����
%          'filter_point'����λ����
%          filter_points�����˵ĵ�λ,Ԫ������,��ʾ�����ļ����˵ĵ�λ,��
%                         filter_points{i}��ʾ��i���ļ�Ҫ���˵ĵ�λ,���˵ĵ�λ                           
%                         ��ʾ��ʽΪ�±��, ��filter_points{i} = [1, 2, 3]
%                         ��ʾ���˵�position{i}.pos_res{1}��position{i}.pos_res{2}��
%                         position{i}.pos_res{3}��ʾ�ĵ�λ,������ĵ�λ�д��ڵ㲻��
%                         λ�ü���,������ʱ����,��ֻ������λ�ü��е��ǲ��ֵ�λ

    file_num = length(position);
    true_pos_valid_flag = 1; %��ֵ��Ч���
    
    %����ɱ��
    filter_flag = 0;
    if ~isempty(varargin)
        var_num = length(varargin);
        
        if mod(var_num, 2) ~= 0
            error('�ɱ�δ����������');
        end
        
        var_type = cell(var_num / 2, 1);
        var_param = cell(var_num / 2, 1);
        var_type(:) = varargin(1:2:end);
        var_param(:) = varargin(2:2:end);
        
        for i = 1:(var_num / 2)
            switch var_type{i}
                case 'filter_point'
                    filter_flag = 1;
                    filter_points = var_param{i};
                otherwise
                    error(['��֧��', var_type{i}, '���͵Ĺ���']);
            end
        end
    end
    
    for i = 1:file_num
        %��ȡ��ǰ�ļ��Ķ�λ�������ֵ
        pos_res_num = length(position{i}.pos_res);
        true_pos_num = length(position{i}.true_pos);
        pos_res = repmat(struct('lat', null_val, 'lon', null_val), pos_res_num, 1);
        true_pos = position{i}.true_pos;

        for j = 1:pos_res_num
            pos_res(j) = position{i}.pos_res{j};
        end

        %�жϵ�ǰ��ֵ�Ƿ���Ч,������������ʱ��Ч,������Ч
        %1����ֵ�����붨λ���������ͬ
        %2��ÿ֡��������ֵ����γ��ֵ������Чֵ��
        if pos_res_num ~= true_pos_num
            true_pos_valid_flag = 0;
        end

        for j = 1:true_pos_num
            if (true_pos(j).lat == null_val) || (true_pos(j).lon == null_val)
                true_pos_valid_flag = 0;
                break;
            end
        end

        if true_pos_valid_flag
            %��ֵ��Ч,���ƹ켣ͼ�����ͼ
            if filter_flag
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'true_value', ...
                                                      true_pos, ...
                                                      'filter_point', ...
                                                      filter_points{i});

                 position_error_statistics(pos_res, ...
                                           true_pos, ...
                                           'filter_point', ...
                                           filter_points{i});
            else
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'true_value', ...
                                                      true_pos);

                 position_error_statistics(pos_res, true_pos);
            end
        else
            %��ֵ��Ч,���ƹ켣ͼ
            if filter_flag
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type, ...
                                                      'filter_point', ...
                                                      filter_points{i});
            else
                coordinate_trajectory_in_beacon_space(env_feat, ...
                                                      beacon_position, ...
                                                      pos_res, ...
                                                      draw_type);
            end
        end
    end
end