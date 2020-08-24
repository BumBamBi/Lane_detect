%% 차량의 x, y, 세타에 맞게 3D 라이다 데이터를 변환
function tf_lidar = transform_Lidar(lidar_1, x,y,th)
% lidar_1 : 회전 변환 하기전에 original 3D Lidar pointcloud data(x,y,z)
% x,y,th : dead reckoning의 결과로 추정된 차량의 x,y,theta
x_1 = 0.94; y_1 = 0.49; z_1 = 1.76;
roll_1= 0.0; pitch_1 = 0.0; yaw_1 = -0.017453;
% 차량의 상태에 맞게 Rotation and Translation matrix 변화
x_1 = x_1 + x; y_1 = y_1 + y; yaw_1 = yaw_1 + th;
cos_r_1 = cos(roll_1); sin_r_1 = sin(roll_1);
cos_p_1 = cos(pitch_1); sin_p_1 = sin(pitch_1);
cos_y_1 = cos(yaw_1); sin_y_1 = sin(yaw_1);
r_matrix_1 = [1 0 0 0; 0 cos_r_1 -sin_r_1 0;
0 sin_r_1 cos_r_1 0; 0 0 0 1 ];
p_matrix_1 = [cos_p_1 0 sin_p_1 0; 0 1 0 0;
-sin_p_1 0 cos_p_1 0; 0 0 0 1 ];
y_matrix_1 = [cos_y_1 -sin_y_1 0 0; sin_y_1 cos_y_1 0 0;
0 0 1 0; 0 0 0 1 ];
tl_matrix_1 = [1 0 0 x_1; 0 1 0 y_1;
0 0 1 z_1; 0 0 0 1];
tf_matrix_1 = tl_matrix_1 * y_matrix_1 * p_matrix_1 * r_matrix_1;
tf_lidar = zeros(length(lidar_1),3);
for i = 1:length(lidar_1)
temp = [lidar_1(i,1); lidar_1(i,2); lidar_1(i,3); 1];
temp_2 = tf_matrix_1 * temp;
tf_lidar(i,:) = [temp_2(1,1) temp_2(2,1) temp_2(3,1)];
end
end