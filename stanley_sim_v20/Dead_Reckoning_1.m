clear; clc;
load('DeadReckoning_data.mat');
RL = exp1_014.Y(4).Data; % left back wheel speed
RR = exp1_014.Y(5).Data; % right back wheel speed
% 바퀴 속도 가져옴
% 바퀴속도를 이용하여 나머지를 계산

Yaw_rate = exp1_014.Y(9).Data;
Time = exp1_014.X.Data;
%% calc yaw_drift
yaw_mean = mean(Yaw_rate(1:5944));
%% initial Variable

% 필요한 정보를 수식을 통해 가져옴
x(1) = 0; y(1) = 0;
th(1) = deg2rad(230);
vk = (RL+RR)/2/3.6; % transform to m/s
wk = deg2rad(Yaw_rate-yaw_mean); % remove drift
Ts(1) = 0.001;
for i = 2:length(Time)
Ts(i) = Time(i) - Time(i-1);
end

%% Dead Reckoning Using Euler

x_1(1) = 0; y_1(1) = 0;
th_1(1) = deg2rad(230);
% 초기 각도 = 230도 를 radian으로 변경

vk_1 = (RL+RR)/2/3.6; % transform to m/s
wk_1 = deg2rad(Yaw_rate-yaw_mean); % remove drift
for k = 1:length(Time)
x_1(k+1) = x_1(k) + vk_1(k)*Ts(k)*cos(th_1(k));
y_1(k+1) = y_1(k) + vk_1(k)*Ts(k)*sin(th_1(k));
th_1(k+1) = th_1(k) + (wk_1(k)*Ts(k));
end

%% Dead Reckoning Using 2nd Order Runge-Kutta

x_2(1) = 0; y_2(1) = 0;
th_2(1) = deg2rad(230);
vk_2 = (RL+RR)/2/3.6; % transform to m/s
wk_2 = deg2rad(Yaw_rate-yaw_mean); % remove drift
for k = 1:length(Time)
x_2(k+1) = x_2(k) + vk_2(k)*Ts(k)*cos(th_2(k) + (wk_2(k)*Ts(k)/2));
y_2(k+1) = y_2(k) + vk_2(k)*Ts(k)*sin(th_2(k) + (wk_2(k)*Ts(k)/2));
th_2(k+1) = th_2(k) + (wk_2(k)*Ts(k));
end

%% Dead Reckoning Using Exact Method

x_3(1) = 0;
y_3(1) = 0;
th_3(1) = deg2rad(230);
vk_3 = (RL+RR)/2/3.6; % transform to m/s
wk_3 = deg2rad(Yaw_rate-yaw_mean); % remove drift
for k = 1:length(Time)
th_3(k+1) = th_3(k) + (wk_3(k)*Ts(k));
x_3(k+1) = x_3(k) + vk(k)/wk(k)*(sin(th_3(k+1)) - sin(th_3(k)));
y_3(k+1) = y_3(k) - vk(k)/wk(k)*(cos(th_3(k+1)) - cos(th_3(k)));
end
%% 그래프 그리기

subplot(211);
hold on; 
yyaxis left
ylabel('x Difference(mm)');
plot((x_3-x_1)*10^3,'-b','Linewidth', 2); 
plot((x_3-x_2)*10^3,'-k','Linewidth', 1); 
yyaxis right
plot([0 vk-1],'-r','Linewidth', 1);
title('DR differences between Exact-Euler & Exack-RK')
xlabel('Sample Number')
ylabel('x Difference (mm)')
ylabel('Velocity (m/s)')

subplot(212);
hold on; 
yyaxis left
ylabel('y Difference(mm)');
plot((y_3-y_1)*10^3,'-b','Linewidth', 2); 
plot((y_3-y_2)*10^3,'-k','Linewidth', 1); 
yyaxis right
plot([0 vk-1],'-r','Linewidth', 1); 
xlabel('Sample Number')
ylabel('y Difference (mm)')
ylabel('Velocity (m/s)')
hold off;
