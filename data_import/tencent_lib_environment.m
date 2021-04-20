function env_feat = tencent_lib_environment(varargin)
    %功能：获取腾讯大厦实验环境特征位置
    %定义：env_feat = tencent_lib_environment()
    %参数：
    %
    %输出：
    %    env_feat：各区域位置信息,细胞数组,每个细胞表示一个环境区域，其数据为结构体,
    %              具体如下所示：
    %              env_feat{i}.type：环境特征绘制方式,具体如下所示：
    %                                'closed_cycle'：绘制闭环图线
    %                                'not_closed'：绘制非闭环图线
    %              env_feat{i}.position：关键点的位置信息,结构体数组,绘图时会将该
    %                                    区域关键点位连接起来,连接顺序按
    %                                    env_feat{i}.position顺序,即
    %                                    env_feat{i}.position(1)为第一个点,
    %                                    env_feat{i}.position(2)为第二个点,
    %                                    以此类推,具体元素如下：
    %                                    env_feat{i}.position(j).lat：纬度
    %                                    env_feat{i}.position(j).lon：经度

    env_num = 0;

    %试验区边缘位置
    env_num = env_num + 1;
    lat{env_num} = [30.548043749; 30.548043749; 30.547877313; 30.547877313];
    lon{env_num} = [104.058569922; 104.058749827; 104.058749827; 104.05856896];
    type{env_num} = 'closed_cycle';

    if true
        %靠厕所第一排中柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.547955238; 30.547965822; 30.547965822; 30.547955238];
        lon{env_num} = [104.058653621; 104.058653621; 104.05866709; 104.05866709];
        type{env_num} = 'closed_cycle';
    end
    
    if false
        %靠厕所第一排左柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.548043749; 30.548043749; 30.548034128; 30.548034128];
        lon{env_num} = [104.058653621; 104.058663242; 104.058663242; 104.058653621];
        type{env_num} = 'closed_cycle';

        %靠厕所第一排右柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.547877313; 30.547877313; 30.547885019; 30.547885009];
        lon{env_num} = [104.058653621; 104.058661318; 104.058661318; 104.058653621];
        type{env_num} = 'closed_cycle';

        %靠厕所第二排中柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.547953315; 30.547963898; 30.547963898; 30.547953315];
        lon{env_num} = [104.058749827; 104.058749827; 104.058739244; 104.058739244];
        type{env_num} = 'closed_cycle';

        %靠厕所第二排左柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.548036052; 30.548043749; 30.548043749; 30.548036052];
        lon{env_num} = [104.058740206; 104.058740206; 104.058749827; 104.058749827];
        type{env_num} = 'closed_cycle';

        %靠厕所第二排右柱子位置
        env_num = env_num + 1;
        lat{env_num} = [30.547885009; 30.547877313; 30.547877312; 30.547885009];
        lon{env_num} = [104.058749827; 104.058749827; 104.058740207; 104.058740206];
        type{env_num} = 'closed_cycle';

    end

    %靠厕所左会议桌
    env_num = env_num + 1;
    lat{env_num} = [30.548022583; 30.547999494; 30.547999494; 30.548022583];
    lon{env_num} = [104.05862957; 104.05862957; 104.058642076; 104.058642076];
    type{env_num} = 'closed_cycle';

    %靠厕所右会议桌
    env_num = env_num + 1;
    lat{env_num} = [30.547946581; 30.547903288; 30.547903288; 30.547946581];
    lon{env_num} = [104.058642076; 104.058642076; 104.058628608; 104.058628608];
    type{env_num} = 'closed_cycle';

    if false
        %靠厕第一排左办公桌
        env_num = env_num + 1;
        lat{env_num} = [30.547985063; 30.547985063; 30.54803509; 30.54803509];
        lon{env_num} = [104.058685369; 104.058701724; 104.058701724; 104.058685369];
        type{env_num} = 'closed_cycle';

        %靠厕第一排右办公桌
        env_num = env_num + 1;
        lat{env_num} = [30.547951391; 30.547888857; 30.547888857; 30.547951391];
        lon{env_num} = [104.058685369; 104.058685369; 104.058700762; 104.058700762];
        type{env_num} = 'closed_cycle';

        %靠厕第二排左办公桌
        env_num = env_num + 1;
        lat{env_num} = [30.547984101; 30.54803509; 30.54803509; 30.547984101];
        lon{env_num} = [104.058720003; 104.058720003; 104.058736358; 104.058736358];
        type{env_num} = 'closed_cycle';

        %靠厕第二排右办公桌
        env_num = env_num + 1;
        lat{env_num} = [30.547951391; 30.547888857; 30.547888857; 30.547951391];
        lon{env_num} = [104.058736358; 104.058736358; 104.058720003; 104.058720003];
        type{env_num} = 'closed_cycle';
    end

    %厕所门口
    env_num = env_num + 1;
    lat{env_num} = [30.547941771; 30.54793215; 30.54793215; 30.547941771];
    lon{env_num} = [104.058569922; 104.058569922; 104.058567998; 104.058568078];
    type{env_num} = 'closed_cycle';

    %货梯门口
    env_num = env_num + 1;
    lat{env_num} = [30.547998532; 30.547998532; 30.548011039; 30.548011039];
    lon{env_num} = [104.058569922; 104.058567998; 104.05856792; 104.058569922];
    type{env_num} = 'closed_cycle';

    %
    env_feat = cell(0); % “变量似乎会随着迭代次数改变而变化，请预分配内存，以提高运行速度”

    for i = 1:env_num
        key_point_num = length(lat{i});
        env_feat{i}.type = type{i};

        for j = 1:key_point_num
            env_feat{i}.position(j).lat = lat{i}(j);
            env_feat{i}.position(j).lon = lon{i}(j);
            % 墨卡托投影
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
