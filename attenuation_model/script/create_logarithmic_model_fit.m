function [fitresult, gof] = create_logarithmic_model_fit (dist, rssi,varargin)
% 功能:
% 定义:
% 输入:
% 输出:


%% Fit
% Set up fittype and options.
if any(strcmpi(varargin,'fitmode'))
    [xData, yData] = prepareCurveData(dist,rssi);
    
    ft = fittype( 'a+10.*b.*log10(x)', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.25 0.570509218154426];
    opts.Algorithm = 'Levenberg-Marquardt';
else
    %% fit selection
    [xData, yData] = prepareCurveData(rssi,dist);
    ft = fittype( 'power(10,(a-x)/10/b)', 'independent', 'x', 'dependent', 'y' );
    %     excludedPoints = excludedata( xData, yData, 'Indices', [8 10 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 49 50 51 52 53 54 55 56 57 58 59 60 62 63 64 66 67 68 69 71 72] );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.212349416111205 0.997100843108267];
    %     opts.Exclude = excludedPoints;
    
    %% Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    fcof = coeffvalues(fitresult);
    %     fy = fcof(1)+10.*fcof(2).*log10(dist);
    fy = power(10,(fcof(1) - rssi)/10/fcof(2));
    fy = reshape(fy,size(dist));
    f_err = fy - dist;
    
    %% Plot fit with data.
    % tcf('fitmodel');
    figure('Name','fitmodel','Color','w');
    subplot(2,1,1)
    h = plot(fitresult,xData, yData );
    hold on
    plot(rssi,fy,'g*')
    % errorbar(dist,fy,f_err,'*b','LineWidth',1','MarkerSize',8)
    legend(h,'原始数据','拟合结果','拟合点',  'Location', 'NorthEast' );
    xlabel rssi
    ylabel dist
    grid on
    set(get(gca, 'Title'), 'String', '拟合结果');
    % 拟合模型下，不同距离下，相同RSSI波动对距离结果估计的影响
    subplot(2,1,2)
    rssi_c = linspace(min(rssi)-2,max(rssi)+5,50);
    rssi_c_plus_5db = rssi_c + 10;
    rssi_c_dec_5db = rssi_c - 10;
    dist_plus = power(10,(fcof(1) - rssi_c_plus_5db)/10/fcof(2));
    dist_dec = power(10,(fcof(1) - rssi_c_dec_5db)/10/fcof(2));
    dist_c = power(10,(fcof(1) - rssi_c)/10/fcof(2));
    plot_py(rssi_c,dist_c);
    hold on
    errorbar(rssi_c,dist_c,[],dist_plus,...
        [],[],'Marker','*','CapSize',10);
    hold on
    errorbar(rssi_c,dist_c,dist_dec,[],...
        [],[],'Marker','*','CapSize',10);
    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'dist/m');
    grid on
    temp = sprintf('不同距离相同RSSI波动%.0f下距离误差',10);
    set(get(gca, 'Title'), 'String', temp);
end
end