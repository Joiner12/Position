%% ��̬����
overview_origin_rssi_trends();
draw_base_map()

%% 
a = [ 0.35165951,0.91719366,0.38044585,0.53079755;
		0.83082863,0.28583902,0.56782164,0.77916723;
		0.58526409,0.75720023,0.07585429,0.93401068;
		0.54972361,0.75372909,0.05395012,0.12990621 ];

fprintf('\n');
det(a);
disp('A:')
disp(a)
disp('inv(A):')
disp(inv(a))

%% 
a = [0,1,3;3,0,9;7,8,0]
det(a)