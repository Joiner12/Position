function [ x_ans ] = least_squares_gaussian_newton_method( xi, yi, ri)
% ����: ��˹ţ�ٷ������С����(least squares by gaussian newton method)
% ����: [ x_ans ] = least_squares_gaussian_newton_method(obj,args)
% ����: x = the x vector of 3 points
%       y = the y vector of 3 points
%       r = the radius vector of 3 circles
% ���: x_ans = the best answer


% ����f(x)
r1 = @(x, y) sqrt((x-xi(1))^2+(y-yi(1))^2) - ri(1);
r2 = @(x, y) sqrt((x-xi(2))^2+(y-yi(2))^2) - ri(2);
r3 = @(x, y) sqrt((x-xi(3))^2+(y-yi(3))^2) - ri(3);
% Jacobian ����
Dr = @(x) [(x(1) - xi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2)), (x(2) - yi(1))/(sqrt((x(1) - xi(1))^2+(x(2)-yi(1))^2));
    (x(1) - xi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2)), (x(2) - yi(2))/(sqrt((x(1) - xi(2))^2+(x(2)-yi(2))^2));
    (x(1) - xi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2)), (x(2) - yi(3))/(sqrt((x(1) - xi(3))^2+(x(2)-yi(3))^2))];
% f(x0) ����
r = @(x) [r1(x(1), x(2)); r2(x(1), x(2)); r3(x(1), x(2))];
x0 = [mean(xi), mean(yi)]; % ��ʼ��������
while 1
    A = Dr(x0);
    delta_x = (A' * A) \ (- A' * r(x0));
    x1 = x0 + delta_x';
    norm(x1-x0)
    if norm(x1-x0)<1e-6 % ��������
        break;
    end
    x0 = x1;
end
x_ans = x1;
end