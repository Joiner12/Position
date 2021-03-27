function [ b ] = trilateration_calc( X, d, varargin)
% 功能: Estimates the actual position based on previously estimated
%       distances
% 定义: [ b ] = trilateration_calc( X, d, real1, real2, min_X, max_X, min_Y, max_Y )
% 参数:
%       X - Matrix containing the coordinates for each AP position
%       d - Estimated distances to each AP, respectively
% 输出: Estimated position (x, y)
% varargin(key:value)
% 'real_pos':[real_x,real_y]
% real_x - x coordinate of the known position
% real_y - y coordinate of the known position


% create a table with X and d
tbl = table(X, d);

% define the weights. Equals to 1 over the square of the distance
d = d.^2;
weights = d.^(-1);
weights = transpose(weights);

% approximated middle coordinates of dataset
beta0 = [mean(X(:,1)),mean(X(:,2))];

% define the model
modelfun = @(b,X)(abs(b(1)-X(:,1)).^2+abs(b(2)-X(:,2)).^2).^(1/2);

% fit the data to the model
mdl = fitnlm(tbl,modelfun,beta0, 'Weights', weights);

%estimated position
b = mdl.Coefficients{1:2,{'Estimate'}};

end