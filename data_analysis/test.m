% a = [2.345,0,2.234,23;0,3.4354,0,0;0,0,7.625,32;0,0,0,5.2658];
% b = MatrixInv_gauss(a);
% c = inv(a);

a = [2,0,2,4;...
     3,0,5,8;...
     3,2,0,9;...
     2,4,1,7];
b = det(a)
c = inv(a)
d = MatrixInv_gauss(a)