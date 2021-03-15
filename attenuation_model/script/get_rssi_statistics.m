function [m_val,v_val,k_val,s_val] = get_rssi_statistics(rssi,varargin)
% 功能: 分析标准RSSI-Dist统计信息
% 定义: [m_val,v_val,k_val,s_val] = get_rssi_statistics(rssi,varargin)
% 定义: exhibit_std_rssi_analysis
% 输入:
%       rssi:同等距离下RSSI的多次测量值(矩阵)
%       varargin:保留参数
% 输出:
%       m_val:均值
%       v_val:协方差
%       k_val:峰度
%       s_val:偏度

x = linspace(1,length(rssi),length(rssi));
y = rssi;
%{
    统计特性:样本均值、样本方差、偏度、峰度
    偏度(skewness)：
    正态分布（偏度=0），右偏分布（也叫正偏分布，其偏度>0），左偏分布（也叫负偏分布，其偏度<0）
    峰度(kurtosis)：
    正态分布（峰度值=3），厚尾（峰度值>3），瘦尾（峰度值<3）
%}
m_val = mean(y);
v_val = var(y);
k_val = kurtosis(y); % 峰度
s_val = skewness(y); % 偏度

if any(strcmp(varargin,'showfigure'))
    f = figure('Color',[1 1 1]);
    
    subplot(2,2,1)
    histogram(y)
    set(get(gca, 'Title'), 'String', '数据分布-1');
    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'counter');
    modify_axes_label(gca)
    
    subplot(2,2,2)
    scatter(x,y,'Marker','*');
    axis([-10,length(y)+10,min(y)-5,max(y)+5])
    hold on
    plot_py([1,max(x)+10],[m_val,m_val]);
    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'counter');
    set(get(gca, 'Title'), 'String', '数据分布-2');
    legend({'原始数据','均值'});
    modify_axes_label(gca)
    
    
    subplot(2,2,3)
    histfit(y,int32(max(y)-min(y)+2));
    axeschild=get(gca,'children');
    y_1=get(axeschild(1),'YData');
    x_1=get(axeschild(1),'XData');
    set(get(gca, 'Title'), 'String', '分布拟合');
    set(get(gca, 'XLabel'), 'String', 'rssi/dB');
    set(get(gca, 'YLabel'), 'String', 'counter');
    hold on
    plot_py(x_1,y_1);
    modify_axes_label(gca)
    
    % 统计特性:
    subplot(2,2,4)
    %     x_pdf = x_1;
    %     y_pdf = normpdf(x_pdf,m_val,1);
    %     y_pdf = y_pdf./.4*max(y_1);
    %     plot_py(x_pdf,y_pdf);
    %     hold on
    %     plot_py(x_pdf,y_1);
    title_temp_1 = sprintf('样本均值:%.2f', m_val);
    title_temp_2 = sprintf('样本方差:%.2f', v_val);
    title_temp_3 = sprintf('峰度:%.2f', k_val);
    title_temp_4 = sprintf('偏度:%.2f', s_val);
    annotation(f,'textbox',...
        [0.606165263679127 0.14572007720965 0.238392850570381 0.285714277908916],...
        'Color',[0.850980392156863 0.329411764705882 0.101960784313725],...
        'String', {'统计特性',title_temp_1,title_temp_2,title_temp_3,title_temp_4},...
        'FontWeight','bold',...
        'FontSize',15,...
        'FontName','等线',...
        'FitBoxToText','on',...
        'EdgeColor','None');
    box(gca,'on');
    
end

if any(strcmp(varargin,'savefig'))
    saveas(f,'cur.fig')
end

end