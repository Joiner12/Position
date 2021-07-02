function [fitresult, gof] = create_logarithmic_model_fit (dist, rssi, varargin)
    % ����: ���d(rssi)=power(10,(a-rssi)/10/b)���߲���a,b��
    % ����: [fitresult, gof] = create_logarithmic_model_fit (dist, rssi,varargin)
    %
    % ����:
    %       dist:����(m)
    %       rssi:rssi(db)
    %       varargin:����չ����
    % ���:
    %       fitresult:��Ϻ���(fitobject)
    %       gof:��Ͻ��
    % varargin(name,value)
    % 'piecewise_rssi':���÷ֶ����rssi�ض�ֵ(dB)
    % 'rssi_fluctuation':���õ���rssi����ֵ(dB)
    % 'drawpic':��ͼѡ��(bool),Ĭ��Ϊ��ʾ��ͼ
    % example:
    % create_logarithmic_model_fit(__,'piecewise_rssi',-55);
    % ��Ϻ�������-55db��Ϊ�ֶε����ݣ������ݽض�Ϊ�����ֽ��зֱ���ϣ����ֱ������Ͻ����

    %% ��������
    rssi_fluctuation = 5;

    if any(strcmpi(varargin, 'rssi_fluctuation'))
        rssi_fluctuation = varargin{find(strcmpi(varargin, 'rssi_fluctuation')) + 1};
    end

    %% ��ͼѡ��
    draw_pic = true;

    if any(strcmpi(varargin, 'drawpic'))
        draw_pic = varargin{find(strcmpi(varargin, 'drawpic')) + 1};
    end

    %% ������Ϻ���
    ft = fittype('power(10,(a-x)/10/b)', 'independent', 'x', 'dependent', 'y');
    %     excludedPoints = excludedata( xData, yData, 'Indices', [8 10 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 49 50 51 52 53 54 55 56 57 58 59 60 62 63 64 66 67 68 69 71 72] );
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.StartPoint = [0.212349416111205 0.997100843108267];
    %     opts.Exclude = excludedPoints;

    %% ��Ϸ�ʽ
    if ~any(strcmpi(varargin, 'piecewise_rssi'))
        % ȫ�����
        [xData, yData] = prepareCurveData(rssi, dist);
        % Fit model to data.
        [fitresult, gof] = fit(xData, yData, ft, opts);
        fcof = coeffvalues(fitresult);
        %     fy = fcof(1)+10.*fcof(2).*log10(dist);
        fy = power(10, (fcof(1) - rssi) / 10 / fcof(2));
        fy = reshape(fy, size(dist));
        f_err = fy - dist;
        %% Plot fit with data.
        % tcf('fitmodel');
        if any(strcmpi(varargin, 'show-figure'))
            figure('Name', 'fitmodel-log', 'Color', 'w');
            subplot(2, 1, 1)
            plot(fitresult, xData, yData);
            hold on
            plot(rssi, fy, 'g*')
            % errorbar(dist,fy,f_err,'*b','LineWidth',1','MarkerSize',8)
            legend('ԭʼ����', '��Ͻ��', '��ϵ�', 'Location', 'NorthEast');
            xlabel rssi
            ylabel dist
            grid on
            set(get(gca, 'Title'), 'String', '��Ͻ��-1');
            % ���ģ���£���ͬ�����£���ͬRSSI�����Ծ��������Ƶ�Ӱ��
            subplot(2, 1, 2)
            rssi_c = linspace(min(min(rssi) - 2, -90), max(rssi) + 5, 50);
            dist_c = power(10, (fcof(1) - rssi_c) / 10 / fcof(2));
            plot(rssi_c, dist_c, 'marker', '*', 'Color', 'r');
            % 1m����Ͻ��
            ref_rssi = rssi_c(abs(dist_c - 1) - min(abs(dist_c - 1)) == 0);
            text_rssi = rssi_c(int8(length(rssi_c) / 2));
            text_dist = (max(dist_c) - min(dist_c)) / 2;
            text(text_rssi, text_dist, sprintf('dist:1m,rssi:%.1f', ref_rssi), ...
                'FontSize', 14, 'Color', [229, 197, 47] ./ 255);
            set(get(gca, 'XLabel'), 'String', 'rssi/dB');
            set(get(gca, 'YLabel'), 'String', 'dist/m');
            grid on
            set(get(gca, 'Title'), 'String', '��Ͻ��-1');
        end

    else
        % �ֶ����
        piecewise_rssi = varargin{find(strcmpi(varargin, 'piecewise_rssi')) + 1};
        rssi_part_1 = rssi(rssi >= piecewise_rssi); % ���ݶ�I
        dist_part_1 = dist(rssi >= piecewise_rssi);

        rssi_part_2 = rssi(rssi < piecewise_rssi); % ���ݶ�II
        dist_part_2 = dist(rssi < piecewise_rssi);

        [xData_1, yData_1] = prepareCurveData(rssi_part_1, dist_part_1);
        [xData_2, yData_2] = prepareCurveData(rssi_part_2, dist_part_2);
        % ���
        [fitresult_1, gof_1] = fit(xData_1, yData_1, ft, opts);
        [fitresult_2, gof_2] = fit(xData_2, yData_2, ft, opts);
        fcof_1 = coeffvalues(fitresult_1);
        fcof_2 = coeffvalues(fitresult_2);
        temp_1 = sprintf('rssi >= %.0f��Ͻ��:A=%0.2f,n=%0.2f', piecewise_rssi, ...
            fcof_1(1), fcof_1(2));
        temp_2 = sprintf('rssi < %.0f��Ͻ��:A=%0.2f,n=%0.2f', piecewise_rssi, ...
            fcof_2(1), fcof_2(2));
        disp(temp_1);
        disp(fitresult_1);
        disp(temp_2);
        disp(fitresult_2);
        fitresult = {fitresult_1, fitresult_2};
        %%  fitresult_1(x) = power(10,(a-x)/10/b)

        syms x;
        eq = power(10, (fcof_1(1) - x) / 10 / fcof_1(2)) == power(10, (fcof_2(1) - x) / 10 / fcof_2(2));
        intersection_rssi = solve(eq, x);
        fprintf('�ֶ����߽���RSSI:%.2f\n', intersection_rssi);

        % �������-������ͼ
        fh_1 = @(r) power(10, (fcof_1(1) - r) / 10 / fcof_1(2));
        fh_2 = @(r) power(10, (fcof_2(1) - r) / 10 / fcof_2(2));

        %% ��ͼ
        figure('Name', 'fitmodel', 'Color', 'w');
        subplot(2, 1, 1)
        plot(fitresult_1, rssi, dist);
        axeschild = get(gca, 'children');
        axeschild(1).Color = 'c';
        axeschild(1).Color = 'b';
        hold on
        plot(fitresult_2, rssi, dist);
        axeschild = get(gca, 'children');
        axeschild(1).Color = 'c';
        axeschild(1).Color = 'r';

        legend('ԭʼ����', temp_1, 'ԭʼ����', temp_2, 'Location', 'NorthEast');
        set(get(gca, 'XLabel'), 'String', 'rssi/dB');
        set(get(gca, 'YLabel'), 'String', 'dist/m');
        grid on
        set(get(gca, 'Title'), 'String', '��Ͻ��');

        subplot(2, 1, 2)
        x_temp = linspace(intersection_rssi, max(xData_1) + 5, 100);
        yfh_1 = fh_1(x_temp);
        plot(x_temp, yfh_1, 'LineWidth', 1.5);
        hold on
        x_temp = linspace(-90, intersection_rssi, 100);
        yfh_2 = fh_2(x_temp);
        plot(x_temp, yfh_2, 'LineWidth', 1.5)
        hold on
        scatter_py(rssi, dist);
        set(get(gca, 'XLabel'), 'String', 'rssi/dB');
        set(get(gca, 'YLabel'), 'String', 'dist/m');
        grid on
        set(get(gca, 'Title'), 'String', '��Ϸ���');
        legend(temp_1, temp_2, 'ԭʼ����');

    end

end % function
