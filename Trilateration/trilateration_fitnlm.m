function [est_pos_nlm] = trilateration_fitnlm(x_tr, y_tr, d_tr, varargin)
    % 功能:
    %       matlab自带fitnlm模块
    % 定义:
    %       [est_pos_nlm] = trilateration_fitnlm(x_tr, y_tr, d_tr, varargin)
    % 参数:
    %       x_tr,x轴坐标;
    %       y_tr,y轴坐标;
    %       d_tr,距离;
    %       varargin,保留参数;
    % 输出:
    %       est_pos_nlm,定位结果(x,y);

    % create a table with X and d
    X = [reshape(x_tr, [length(x_tr), 1]), reshape(y_tr, [length(y_tr), 1])];
    d = reshape(d_tr, [length(d_tr), 1]);
    tbl = table(X, d);
    weights = ones([length(X), 1]);
    centroid = [mean(X(:, 1)), mean(X(:, 2))];

    % define the weights. Equals to 1 over the square of the distance
    if any(strcmp(varargin, 'centroid'))
        d_weights = X - centroid;
        weights = 1 ./ (d_weights(:, 1).^2 + d_weights(:, 2).^2);
    else
        d = d.^2;
        %     d = 10.^d;
        weights = d.^(-1);
        weights = transpose(weights);
    end

    % approximated middle coordinates of dataset
    beta0 = centroid;

    % define the model
    % modelfun = @(b, X)(abs(b(1) - X(:, 1)).^2 + abs(b(2) - X(:, 2)).^2).^(1/2);
    modelfun = @(b, X)(sqrt((b(1) - X(:, 1)).^2 + (b(2) - X(:, 2)).^2));
    % fit the data to the model
    mdl = fitnlm(tbl, modelfun, beta0, 'Weights', weights);

    %estimated position
    b = mdl.Coefficients{1:2, {'Estimate'}};
    est_pos_nlm = b;
end
