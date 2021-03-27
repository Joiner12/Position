function [ x_ans ] = least_squares_gaussian_newton_method( xi, yi, ri)
% 功能: 高斯牛顿法求解最小二乘(least squares by gaussian newton method)
% 定义: [ x_ans ] = least_squares_gaussian_newton_method(obj,args)
% 参数: x = the x vector of 3 points
%       y = the y vector of 3 points
%       r = the radius vector of 3 circles
% 输出: x_ans = the best answer


% 误差函数f(x)
r1 = @(x, y) sqrt((x-xi(1))^2+(y-yi(1))^2) - ri(1);
r2 = @(x, y) sqrt((x-xi(2))^2+(y-yi(2))^2) - ri(2);
r3 = @(x, y) sqrt((x-xi(3))^2+(y-yi(3))^2) - ri(3);
% Jacobian 矩阵
Dr = @(x) [(x(1) - xi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2)), (x(2) - yi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2));
    (x(1) - xi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2)), (x(2) - yi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2));
    (x(1) - xi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2)), (x(2) - yi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2))];
% f(x0) 矩阵
r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
x0 = [mean(xi), mean(yi)]; % 初始化搜索点
while 1
    A = Dr(x0);
    delta_x = (A' * A) \ (- A' * r(x0));
    x1 = x0 + delta_x';
    norm(x1-x0)
    if norm(x1-x0)<1e-6 % 截至条件
        break;
    end
    x0 = x1;
end
x_ans = x1;
end