function create_heatmap(varargin)
    % create heat map
    dist = randi([0, 10], 1, 1000);
    t_d = tabulate(dist);
    t_value = t_d(:, 1);
    t_dp = t_d(:, 3);
    t_pdf = zeros(size(t_dp));

    for k = 1:1:length(t_dp)
        t_pdf(k) = sum(t_dp(1:k));
    end

    tcf('heat-map');
    figure('name', 'heat-map', 'color', 'white');
    hold on
    
    area(t_value, t_pdf,'FaceColor',[0 0.75 0.75])
    plot(t_value, t_pdf, 'Marker', '*', 'Color', 'r', 'LineWidth', 4)
    set(get(gca, 'XLabel'), 'String', 'æ‡¿Î/m');
    set(get(gca, 'YLabel'), 'String', '’º±»/%');
end
