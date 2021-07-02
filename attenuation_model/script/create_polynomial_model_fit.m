function [fitresult, gof] = create_polynomial_model_fit(dist, rssi, varargin)
    % 功能: 多项式拟合f(rssi) = d
    % 定义: [fitresult, gof] = create_model_fit_advanced(dist, rssi, varargin)
    %
    % 输入:
    %       dist:距离(m)
    %       rssi:rssi(db)
    %       varargin:可扩展参数
    % 输出:
    %       fitresult:拟合函数(fitobject)
    %       gof 拟合优度统计量

    % 设置拟合函数
    ft = fittype('p1*x^2 + p2*x + p3', 'independent', 'x', 'dependent', 'y');
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.StartPoint = rand(3, 1);

    % 全局拟合
    [xData, yData] = prepareCurveData(rssi, dist);
    % Fit model to data.
    [fitresult, gof] = fit(xData, yData, ft, opts);
    fcof = coeffvalues(fitresult);

    %% Plot fit with data.
    if any(strcmpi(varargin, 'show_figure'))
        tcf('fitmodel-poly');
        figure('Name', 'fitmodel-poly', 'Color', 'w');
        subplot(2, 1, 1)
        p1 = plot(fitresult, xData, yData);
        p1(1).MarkerSize = 10;
        p1(2).LineWidth = 1;
        legend('原始数据', '拟合结果', 'Location', 'NorthEast');
        xlabel rssi
        ylabel dist
        grid on
        set(get(gca, 'Title'), 'String', '拟合结果-1');
        % 拟合模型下，不同距离下，相同RSSI波动对距离结果估计的影响
        subplot(2, 1, 2)
        hold on
        rssi_c = linspace(min(min(rssi) - 2, -90), max(rssi) + 5, 50);
        dist_c = fcof(1) .* (rssi_c.^2) + fcof(2) * rssi_c + fcof(2);
        plot(rssi_c, dist_c, '*', 'Color', 'g');

        % 1m处拟合结果
        ref_rssi = rssi_c(abs(dist_c - 1) - min(abs(dist_c - 1)) == 0);
        text_rssi = rssi_c(int8(length(rssi_c) / 2));
        text_dist = (max(dist_c) - min(dist_c)) / 2;
        text(text_rssi, text_dist, sprintf('dist:1m,rssi:%.1f', ref_rssi), ...
            'FontSize', 14, 'Color', [229, 197, 47] ./ 255);
        set(get(gca, 'XLabel'), 'String', 'rssi/dB');
        set(get(gca, 'YLabel'), 'String', 'dist/m');
        grid on
        set(get(gca, 'Title'), 'String', '拟合结果-1');
    end

end % function
