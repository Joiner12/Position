function draw_trajectory_and_error_diagram(position, ...
                                           null_val, ...
                                           env_feat, ...
                                           beacon_position, ...
                                           draw_type)
%���ܣ����ƹ켣�����ͼ,�����ļ������ݵ�������,���������һ���龰��
%      1����ǰ�ļ���λ����ֵ��Ч�����ƴ���ֵ�켣�Ĺ켣ͼ�����ͼ
%      2����ǰ�ļ���λ����ֵ��Ч�����Ʋ�����ֵ�켣�Ĺ켣ͼ
%      λ����ֵ������������ʱ��Ч,������Ч��
%      1����ֵ�����붨λ���������ͬ
%      2��ÿ֡��������ֵ����γ��ֵ������Чֵ��
%������
%    position�������Ƶ�λ������,ϸ������,����ṹ������ʾ��
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
%    env_feat����������,ϸ������,ÿ��ϸ����ʾһ����������������Ϊ�ṹ��,������ 
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
%                     beacon_position(i).lat��γ��
%                     beacon_position(i).lon������
%    draw_type���켣���Ʒ�ʽ,�������£�
%               'splashes'������ɢ�㣬�����ƹ켣
%               'trajectory'�����ƹ켣���켣����˳��track_position˳��,��
%                             track_position(1)Ϊ��һ�����λ��,track_position(2)
%                             Ϊ�ڶ������λ��,�Դ�����

    file_num = length(position);
    true_pos_valid_flag = 1; %��ֵ��Ч���
    
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
            coordinate_trajectory_in_beacon_space(env_feat, ...
                                                  beacon_position, ...
                                                  pos_res, ...
                                                  draw_type, ...
                                                  'true_value', ...
                                                  true_pos);

             position_error_statistics(pos_res, true_pos);
        else
            %��ֵ��Ч,���ƹ켣ͼ
            coordinate_trajectory_in_beacon_space(env_feat, ...
                                                  beacon_position, ...
                                                  pos_res, ...
                                                  draw_type);
        end
    end
end