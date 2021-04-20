function plotPursuitCurves(P)
    % reference:https://blogs.mathworks.com/steve/2019/02/14/pursuit-curves/?s_tid=blogs_rc_3
    P = reshape(P, 1, []);
    N = length(P);
    d = 0.01;

    for k = 1:1000
        V = P(end, [(2:N) 1]) - P(end, :);
        P(end + 1, :) = P(end, :) + d * V;
    end

    hold on
    Q = P(:, [(2:N) 1]);

    for k = 1:10:size(P, 1)

        for m = 1:N
            T = [P(k, m) Q(k, m)];
            plot(real(T), imag(T), 'LineWidth', 0.5, 'Color', [.8 .8 .8])
        end

    end

    for k = 1:N
        plot(real(P(:, k)), imag(P(:, k)))
    end

    hold off
    axis equal
end
