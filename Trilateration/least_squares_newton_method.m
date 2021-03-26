function [ x_ans ] = least_squares_gaussian_newton_method( xi, yi, ri)
% 功能: 高斯牛顿法求解最小二乘(least squares by gaussian newton method)
% 定义: [ x_ans ] = least_squares_gaussian_newton_method(obj,args)
% 参数: x = the x vector of 3 points
%       y = the y vector of 3 points
%       r = the radius vector of 3 circles
% 输出: x_ans = the best answer


% set up r equations
r1 = @(x, y) sqrt((x-xi(1))^2+(y-yi(1))^2) - ri(1);
r2 = @(x, y) sqrt((x-xi(2))^2+(y-yi(2))^2) - ri(2);
r3 = @(x, y) sqrt((x-xi(3))^2+(y-yi(3))^2) - ri(3);
% set up Dr matrix
Dr = @(x) [(x(1) - xi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2)), (x(2) - yi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2));
    (x(1) - xi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2)), (x(2) - yi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2));
    (x(1) - xi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2)), (x(2) - yi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2))];
% set up r matrix
r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
x0 = [0, 0]; % initial guess
while 1
    A = Dr(x0);
    delta_x = (A' * A) \ (- A' * r(x0));
    x1 = x0 + delta_x';
    if norm(x1-x0)<1e-6 % break squest
        break;
    end
    x0 = x1;
end
x_ans = x1;
end