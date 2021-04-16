function env_feat = tencent_lib_environment(varargin)
    %���ܣ���ȡ��Ѷ����ʵ�黷������λ��
    %���壺env_feat = tencent_lib_environment()
    %������
    %
    %�����
    %    env_feat��������λ����Ϣ,ϸ������,ÿ��ϸ����ʾһ����������������Ϊ�ṹ��,
    %              ����������ʾ��
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

    env_num = 0;

    %��������Եλ��
    env_num = env_num + 1;
    lat{env_num} = [30.548043749; 30.548043749; 30.547877313; 30.547877313];
    lon{env_num} = [104.058569922; 104.058749827; 104.058749827; 104.05856896];
    type{env_num} = 'closed_cycle';

    if true
        %��������һ��������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.547955238; 30.547965822; 30.547965822; 30.547955238];
        lon{env_num} = [104.058653621; 104.058653621; 104.05866709; 104.05866709];
        type{env_num} = 'closed_cycle';
    end
    
    if false
        %��������һ��������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.548043749; 30.548043749; 30.548034128; 30.548034128];
        lon{env_num} = [104.058653621; 104.058663242; 104.058663242; 104.058653621];
        type{env_num} = 'closed_cycle';

        %��������һ��������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.547877313; 30.547877313; 30.547885019; 30.547885009];
        lon{env_num} = [104.058653621; 104.058661318; 104.058661318; 104.058653621];
        type{env_num} = 'closed_cycle';

        %�������ڶ���������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.547953315; 30.547963898; 30.547963898; 30.547953315];
        lon{env_num} = [104.058749827; 104.058749827; 104.058739244; 104.058739244];
        type{env_num} = 'closed_cycle';

        %�������ڶ���������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.548036052; 30.548043749; 30.548043749; 30.548036052];
        lon{env_num} = [104.058740206; 104.058740206; 104.058749827; 104.058749827];
        type{env_num} = 'closed_cycle';

        %�������ڶ���������λ��
        env_num = env_num + 1;
        lat{env_num} = [30.547885009; 30.547877313; 30.547877312; 30.547885009];
        lon{env_num} = [104.058749827; 104.058749827; 104.058740207; 104.058740206];
        type{env_num} = 'closed_cycle';

    end

    %�������������
    env_num = env_num + 1;
    lat{env_num} = [30.548022583; 30.547999494; 30.547999494; 30.548022583];
    lon{env_num} = [104.05862957; 104.05862957; 104.058642076; 104.058642076];
    type{env_num} = 'closed_cycle';

    %�������һ�����
    env_num = env_num + 1;
    lat{env_num} = [30.547946581; 30.547903288; 30.547903288; 30.547946581];
    lon{env_num} = [104.058642076; 104.058642076; 104.058628608; 104.058628608];
    type{env_num} = 'closed_cycle';

    if false
        %���޵�һ����칫��
        env_num = env_num + 1;
        lat{env_num} = [30.547985063; 30.547985063; 30.54803509; 30.54803509];
        lon{env_num} = [104.058685369; 104.058701724; 104.058701724; 104.058685369];
        type{env_num} = 'closed_cycle';

        %���޵�һ���Ұ칫��
        env_num = env_num + 1;
        lat{env_num} = [30.547951391; 30.547888857; 30.547888857; 30.547951391];
        lon{env_num} = [104.058685369; 104.058685369; 104.058700762; 104.058700762];
        type{env_num} = 'closed_cycle';

        %���޵ڶ�����칫��
        env_num = env_num + 1;
        lat{env_num} = [30.547984101; 30.54803509; 30.54803509; 30.547984101];
        lon{env_num} = [104.058720003; 104.058720003; 104.058736358; 104.058736358];
        type{env_num} = 'closed_cycle';

        %���޵ڶ����Ұ칫��
        env_num = env_num + 1;
        lat{env_num} = [30.547951391; 30.547888857; 30.547888857; 30.547951391];
        lon{env_num} = [104.058736358; 104.058736358; 104.058720003; 104.058720003];
        type{env_num} = 'closed_cycle';
    end

    %�����ſ�
    env_num = env_num + 1;
    lat{env_num} = [30.547941771; 30.54793215; 30.54793215; 30.547941771];
    lon{env_num} = [104.058569922; 104.058569922; 104.058567998; 104.058568078];
    type{env_num} = 'closed_cycle';

    %�����ſ�
    env_num = env_num + 1;
    lat{env_num} = [30.547998532; 30.547998532; 30.548011039; 30.548011039];
    lon{env_num} = [104.058569922; 104.058567998; 104.05856792; 104.058569922];
    type{env_num} = 'closed_cycle';

    %
    env_feat = cell(0); % �������ƺ������ŵ��������ı���仯����Ԥ�����ڴ棬����������ٶȡ�

    for i = 1:env_num
        key_point_num = length(lat{i});
        env_feat{i}.type = type{i};

        for j = 1:key_point_num
            env_feat{i}.position(j).lat = lat{i}(j);
            env_feat{i}.position(j).lon = lon{i}(j);
            % ī����ͶӰ
            [cur_x, cur_y, ~] = latlon_to_xy(lat{i}(j), lon{i}(j));
            env_feat{i}.position(j).x = cur_x;
            env_feat{i}.position(j).y = cur_y;
        end

    end

    if any(strcmp(varargin,'showschmer'))
        min_x = -2^61;
        min_y = -2^61;
        tcf('tencentenv');
        figure('name','tencentenv','color','w');
        
    end
end
