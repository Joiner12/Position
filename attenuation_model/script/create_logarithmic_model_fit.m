function [fitresult, gof] = create_logarithmic_model_fit (dist, rssi,varargin)
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
% example:
% create_logarithmic_model_fit(__,'piecewise_rssi',-55);
% ��Ϻ�������-55db��Ϊ�ֶε����ݣ������ݽض�Ϊ�����ֽ��зֱ���ϣ����ֱ������Ͻ����



%% ��������
rssi_fluctuation = 5;
if isempty(any(strcmpi(varargin,'rssi_fluctuation')))
    rssi_fluctuation = varargin(find(strcmpi(varargin,'rssi_fluctuation'))+1);
end

%% ������Ϻ���
ft = fittype('power(10,(a-x)/10/b)', 'independent', 'x', 'dependent', 'y' );
%     excludedPoints = excludedata( xData, yData, 'Indices', [8 10 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 49 50 51 52 53 54 55 56 57 58 59 60 62 63 64 66 67 68 69 71 72] );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.212349416111205 0.997100843108267];
%     opts.Exclude = excludedPoints;

%% ��Ϸ�ʽ
if isempty(any(strcmpi(varargin,'piecewise_rssi')))
    %% ȫ�����
    [xData, yData] = prepareCurveData(rssi,dist);
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
    plot(fitresult,xData, yData );
    hold on
    plot(rssi,fy,'g*')
    % errorbar(dist,fy,f_err,'*b','LineWidth',1','MarkerSize',8)
    legend('ԭʼ����','��Ͻ��','��ϵ�',  'Location', 'NorthEast' );
    xlabel rssi
    ylabel dist
    grid on
    set(get(gca, 'Title'), 'String', '��Ͻ��');
    % ���ģ���£���ͬ�����£���ͬRSSI�����Ծ��������Ƶ�Ӱ��
    subplot(2,1,2)
    rssi_c = linspace(min(rssi)-2,max(rssi)+5,50);
    rssi_c_plus_5db = rssi_c + rssi_fluctuation;
    rssi_c_dec_5db = rssi_c - rssi_fluctuation;
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
    temp = sprintf('��ͬ������ͬRSSI����%.0f�¾������',10);
    set(get(gca, 'Title'), 'String', temp);
else
    %% �ֶ����
    piecewise_rssi = varargin(find(strcmpi(varargin,'piecewise_rssi'))+1);
    rssi_part_1 = rssi(rssi >= piecewise_rssi); % ���ݶ�I
    dist_part_1 = dist(rssi >= piecewise_rssi);
    
    rssi_part_2 = rssi(rssi < piecewise_rssi); % ���ݶ�II
    dist_part_2 = dist(rssi < piecewise_rssi);
    
    [xData_1, yData_1] = prepareCurveData(rssi_part_1,dist_part_1);
    [xData_2, yData_2] = prepareCurveData(rssi_part_2,dist_part_2);
    %% ���
    [fitresult_1, gof_1] = fit( xData_1, yData_1, ft, opts );
    [fitresult_2, gof_2] = fit( xData_2, yData_2, ft, opts );
    fcof_1 = coeffvalues(fitresult_1);
    fcof_2 = coeffvalues(fitresult_2);
    
    %% ������Ͻ������RSSI�����Բ���Ӱ��
    fy_1 = power(10,(fcof_1(1) - rssi)/10/fcof_1(2));
    fy_2 = power(10,(fcof_2(1) - rssi)/10/fcof_2(2));
    
    fy = reshape(fy,size(dist));
    f_err = fy - dist;
    rssi_c = linspace(min(rssi)-2,max(rssi)+5,50);

    rssi_c_plus_fluc_1 = rssi_c + rssi_fluctuation;
    rssi_c_dece_fluc_1 = rssi_c - rssi_fluctuation;
    % dist_plus = power(10,(fcof(1) - rssi_c_plus_5db)/10/fcof(2));
    % dist_dec = power(10,(fcof(1) - rssi_c_dec_5db)/10/fcof(2));
    % dist_c = power(10,(fcof(1) - rssi_c)/10/fcof(2));
    

    %% ��ͼ
    figure('Name','fitmodel','Color','w');
    subplot(2,1,1)
    plot(fitresult_1,rssi, dist);
    hold on
    plot(fitresult_2,rssi, dist);
    legend('ԭʼ����','��Ͻ��-1','ԭʼ����','��Ͻ��-2',  'Location', 'NorthEast' );
    set(get(gca, 'XLabel'), 'String', 'rssi');
    set(get(gca, 'YLabel'), 'String', 'dist');
    grid on
    set(get(gca, 'Title'), 'String', '��Ͻ��');
    
    % ���ģ���£���ͬ�����£���ͬRSSI�����Ծ��������Ƶ�Ӱ��
    subplot(2,1,2)
    plot_py(rssi_c,dist_c);
    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'dist/m');
    grid on
    temp = sprintf('��ͬ������ͬRSSI����%.0f�¾������',10);
    set(get(gca, 'Title'), 'String', temp);
end

end % function