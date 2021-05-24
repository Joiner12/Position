function [fitresult, gof] = create_model_fit_advanced(dist, rssi, varargin)
    % ����: ����ʽ���f(rssi) = d
    % ����: [fitresult, gof] = create_model_fit_advanced(dist, rssi, varargin)
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

    % ������Ϻ���
    ft = fittype('p1*x^2 + p2*x + p3', 'independent', 'x', 'dependent', 'y');
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.StartPoint = rand(3, 1);

    % ȫ�����
    [xData, yData] = prepareCurveData(rssi, dist);
    % Fit model to data.
    [fitresult, gof] = fit(xData, yData, ft, opts);
    fcof = coeffvalues(fitresult);

    %% Plot fit with data.
    % tcf('fitmodel');
    figure('Name', 'fitmodel', 'Color', 'w');
    subplot(2, 1, 1)
    p1 = plot(fitresult, xData, yData);
    p1(1).MarkerSize = 10;
    p1(2).LineWidth = 1;
    legend('ԭʼ����', '��Ͻ��', 'Location', 'NorthEast');
    xlabel rssi
    ylabel dist
    grid on
    set(get(gca, 'Title'), 'String', '��Ͻ��-1');
    % ���ģ���£���ͬ�����£���ͬRSSI�����Ծ��������Ƶ�Ӱ��
    subplot(2, 1, 2)
    hold on
    rssi_c = linspace(min(min(rssi) - 2, -90), max(rssi) + 5, 50);
    dist_c = fcof(1) .* (rssi_c.^2) + fcof(2) * rssi_c + fcof(2);
    plot(rssi_c, dist_c, '*', 'Color', 'g');

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

end % function
