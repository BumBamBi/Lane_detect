function [car_re] = transform_car(x,y,theta)
% car_data : 회전 변환 하기전에 original 3D car data
% x,y,th : dead reckoning의 결과로 추정된 차량의 x,y,theta
persistent car_data car_x car_y car_z car
persistent firstRun
if isempty(firstRun) % 함수가 종료되어도 데이터 유지
    car_data=load('car.mat');
    car_x = car_data.car_X;
    car_y = car_data.car_Y;
    car_z = car_data.car_Z;
    car = [car_x;car_y;car_z;ones(1,length(car_x))];
    firstRun=1;
end
R_car_yaw=[cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0; 0 0 0 1];
T_car=[1 0 0 x; 0 1 0 y; 0 0 1 0; 0 0 0 1];
car_re= T_car * R_car_yaw *car;
% clear; clc; close all;
end