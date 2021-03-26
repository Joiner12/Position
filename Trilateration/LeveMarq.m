function [ x_ans ] = LeveMarq( ti, yi, x_guess, lmd)
% input : t = the x vector of 5 points
%         y = the y vector of 5 points
%         x_guess = the guess vector of x_ans
% output : x_ans = the best answer
    % set up r matrix
    r = @(x) [x(1) * exp(-x(2)*(ti(1) - x(3))^2) - yi(1);
              x(1) * exp(-x(2)*(ti(2) - x(3))^2) - yi(2);
              x(1) * exp(-x(2)*(ti(3) - x(3))^2) - yi(3);
              x(1) * exp(-x(2)*(ti(4) - x(3))^2) - yi(4);
              x(1) * exp(-x(2)*(ti(5) - x(3))^2) - yi(5)];
    % set up Dr matrix
    Dr = @(x) [exp(-x(2)*(ti(1)-x(3))^2), -x(1)*(ti(1)-x(3))^2*exp(-x(2)*(ti(1)-x(3))^2), 2*x(1)*x(2)*(ti(1)-x(3))*exp(-x(2)*(ti(1)-x(3))^2);
               exp(-x(2)*(ti(2)-x(3))^2), -x(1)*(ti(2)-x(3))^2*exp(-x(2)*(ti(2)-x(3))^2), 2*x(1)*x(2)*(ti(2)-x(3))*exp(-x(2)*(ti(2)-x(3))^2);
               exp(-x(2)*(ti(3)-x(3))^2), -x(1)*(ti(3)-x(3))^2*exp(-x(2)*(ti(3)-x(3))^2), 2*x(1)*x(2)*(ti(3)-x(3))*exp(-x(2)*(ti(3)-x(3))^2);
               exp(-x(2)*(ti(4)-x(3))^2), -x(1)*(ti(4)-x(3))^2*exp(-x(2)*(ti(4)-x(3))^2), 2*x(1)*x(2)*(ti(4)-x(3))*exp(-x(2)*(ti(4)-x(3))^2);
               exp(-x(2)*(ti(5)-x(3))^2), -x(1)*(ti(5)-x(3))^2*exp(-x(2)*(ti(5)-x(3))^2), 2*x(1)*x(2)*(ti(5)-x(3))*exp(-x(2)*(ti(5)-x(3))^2)];

    x0 = x_guess; % initial guess
    while 1
       A = Dr(x0);
       M_A = A' * A + lmd .* diag(diag(A' * A));
       M_b = - A' * r(x0);
       v0 = M_A \ M_b;
       x1 = x0 + v0';
       if norm(x1-x0)<1e-6 % break squest
           break;
       end
       x0 = x1;
    end
    x_ans = x1;
end