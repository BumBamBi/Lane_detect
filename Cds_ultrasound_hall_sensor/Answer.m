%%
%초기화

close all;
clc;
clear;

%%
%데이터 불러오기
A0_ultra = load('첨부파일1_cds&초음파센서.txt')';
hall = load('첨부파일2_hall센서.txt')';

%%
%데이터를 계산하기 쉽게 가공하기

A0 = A0_ultra(1,:);
ultra = A0_ultra(2,:);
% A0와 ultra 데이터를 구분함

size_A0_ultra = size(A0_ultra);
%A0와 ultrasound 데이터의 사이즈를 구함

size_hall = size(hall);
%hall데이터의 사이즈를 구함

%%
%1번 

V2 = 5*(A0/1023);   % V1 = 5-V2 를 이용
V1 = 5- V2;

x_1 = 0:0.05:(0.05*size_A0_ultra(1,2)-0.05);
% 0.05초마다 값을 표시할 x축 생성

figure
plot(x_1,V1);
title('A1. V1 Voltage');
xlabel('시간(s)')
ylabel('Voltage(V)')

%%
%2번

%0.5s 마다 측정된 값이므로 120배 하면 RPM이 나오는점을 이용

x_2 = 0:0.5:(0.5*size_hall(1,2)-0.5);
% 0.5초마다 값을 표시할 x축 생성

figure
hold on;

plot(x_2,120*hall);
title('A2. hall RPM');
xlabel('시간(s)')
ylabel('RPM')
axis([0 inf 550 1000])
%RPM을 보여주는 그래프

t = size(x_2);
mean_RPM = ones(1,t(2)).* mean(nonzeros(hall)*120);
%hall 데이터중, 0이 아닌값을 제외하고, RPM평균을 구함
plot(x_2, mean_RPM);
%RPM을 평균내어서, 진행시간동안 RPM의 평균을 보여주는 그래프
hold off;
%%
%3번

R1 = 50000*ones(1,size_A0_ultra(1,2));
R1 = R1./V2 - 10000;
% 전압분배법칙을 이용하여, V2에 대하여 R1값(cds의 저항값)을 구함

mean_R1 = zeros(1,max(ultra));
% 출력할 값(각 거리마다 나타나는 저항의 평균)을 저장할 배열을 만듬

cnt_ultra = zeros(1,max(ultra));
%몇개의 값이 들어갔는지 카운트해주는 배열을 생성

for i = 1 : size_A0_ultra(1,2)
    mean_R1(ultra(i)) = mean_R1(ultra(i)) + R1(i);
    cnt_ultra(ultra(i)) = cnt_ultra(ultra(i)) + 1;
end
mean_R1 = mean_R1./cnt_ultra;
%각 거리에 해당하는 저항의 평균을 구함

x_3 = 1:max(ultra);
%거리에 해당하는 x축 생성

figure
plot(x_3,mean_R1);
title('A3. 거리에 따른 cds의 저항값 평균');
xlabel('거리(cm)')
ylabel('저항(Ω)')

%%
%4번-1

ultra_speed_a = ultra;
%utra_speed_a라는 배열 생성

for i = 2:size_A0_ultra(1,2)
    ultra_speed_a(1,(i-1)) = ultra(1,i) - ultra(1,(i-1));
    %현재값을 직전값에서 빼서 거리 변화를 구함
end
ultra_speed_a(1,size_A0_ultra(1,2)) = 0;
%마지막은 속도변화를 구할 수 없으니 0으로 둠

ultra_speed_a = ultra_speed_a/0.05;
%"거리/시간 = 속도" 공식을 이용하여 속도를 구함

x_4 = 0:0.05:(0.05*size_A0_ultra(1,2)-0.05);
% 0.05초마다 값을 표시할 x축 생성

figure
plot(x_4,ultra_speed_a);
title('A4-1. ultrasound data');
xlabel('시간(s)')
ylabel('속도(cm/s)')

%미묘하게 핸드폰이 흔들리는 점
%시간축이 너무 짧고 조금만 움직여도 값 변화가 크게 나와서
%그래프가 직관적으로 출력되지않음

%%
%4번-2
%위의 문제를 해결하기 위해, 5개씩 끊어서 (0.25초 마다) 계산

block = 5;
y_ultra_speed_5 = zeros(1,size_A0_ultra(1,2)/block);
%5개씩 덩어리로 묶어서 계산할 배열 y_ultra_speed_5을 만듬

size_y_ultra_speed_5 = size(y_ultra_speed_5);
% y_ultra_speed_5배열의 사이즈를 알기위해 size_y_ultra_speed_5생성

mean_ultra_temp = reshape(ultra,[block,size_y_ultra_speed_5(1,2)])';
% 기존의 ultra데이터를 121*5 형태를 지닌 mean_ultra_temp로 만들기 위해 reshape와 ' 를 이용함

mean_ultra = mean(mean_ultra_temp,2)';
% mean_ultra_temp배열을 행마다 평균을 구하고 1xN차원 배열로 만들어서
% 이를 mean_ultra배열에 저장

speed = zeros(1,size_y_ultra_speed_5(1,2));
% 5개씩 묶어서 평균을 구한 배열 mean_ultra 에서
% 직전값 - 현재값을 이용해 이동거리를 구하고 이를 저장할 speed 생성

for i = 2:size_y_ultra_speed_5(1,2)
    speed(i-1) = mean_ultra(i-1) - mean_ultra(i);
    % 직전값 - 현재값을 이용해 이동거리를 구함
end
speed(size_y_ultra_speed_5(1,2)) = 0;
%마지막값은 0으로 가정

speed = speed/0.25;
%속도 = 이동거리/시간 를 이용해서 속도를 구함

x_5 = 0:(0.05*block):((0.05*block)*size_y_ultra_speed_5(1,2)-(0.05*block));
% 0.25초마다 값을 표시할 x축 생성

figure
plot(x_5,speed);
title('A4-2. ultrasound speed data');
xlabel('시간(s)')
ylabel('속도(cm/s)')