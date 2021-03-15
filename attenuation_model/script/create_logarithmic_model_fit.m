function [fitresult, gof] = create_logarithmic_model_fit (dist, rssi)
% ����:
% ����:
% ����:
% ���:


%% Fit
[xData, yData] = prepareCurveData( dist, rssi );

% Set up fittype and options.
ft = fittype( 'a+10.*b.*log10(x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.898524721271566 0.570509218154426];
opts.Algorithm = 'Levenberg-Marquardt';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
tcf('fitmodel');
figure('Name','fitmodel','Color','w');
h = plot( fitresult, xData, yData );
legend(h,'ԭʼ����','��Ͻ��',  'Location', 'NorthEast' );
xlabel dist
ylabel rssi
grid on
end