%% main function of trilateration
clc;
% figure
if true
    fig_name = 'trilateration';
    tcf(fig_name);
    figure('name',fig_name,'Color',[1 1 1]);
end
x_t = [20 70 45];
y_t = [10 0 50];
r_t = [18 30 100];
[ x_ans ] = least_squares_gaussian_newton_method( x_t, y_t, r_t);
trilateration_schematic_diagram(x_t,y_t,r_t,x_ans(1),x_ans(2));


%% 
clc;
b=trilateration_calc([x_t',y_t'],r_t')
%% 
trilateration_schematic_diagram(x_t,y_t,r_t,b(1),b(2));