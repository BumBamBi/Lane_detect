
%% 초기 차량 위치 그리기
clear; clc;
figure(1);
hold on;

% 주차장 배경을 그리기위한 초기값
background_t = 0:0.01:20;
background_x = [2.5 2.5 5 5 5 7.5 7.5 7.5 10 10 10 12.5 12.5 12.5 15 15 15 17.5 17.5 17.5 20 ]; 
background_y = [0   5   5 0 5 5   0   5   5  0  5  5    0    5    5  0  5  5    0    5    5  ];
background_y2 = 5*ones(1,2001);

% 주차장 선 및 색깔 
bc1 = area(background_t,background_y2+5.5);
bc1(1).FaceColor = [0.5 0.5 0.5];
bc1 = area(background_t,background_y2);
bc1.FaceColor = [1 1 1];
plot(background_t,background_y2,'k','LineWidth',2);
line(background_x,background_y,'Color','k','LineWidth',1);
line(background_x,background_y+10.5,'Color','k','LineWidth',1);
plot(background_t,background_y2+5.5,'k','LineWidth',2);
plot(background_t,background_y2+10.5,'k','LineWidth',2);
plot(background_t,background_y2+2.5,'--y','LineWidth',1);

% 차의 최초 위치값
carx = [12.5+0.35 12.5+0.35 15-0.35 15-0.35 12.5+0.35];
cary = [0.43 5-0.43 5-0.43 0.43 0.43];
F_x = 12.5+1.25; F_y = 5 - 0.43 - 0.935;
B_x = 12.5+1.25; B_y = 0.43+0.935;
line(carx,cary,'Color','b','LineWidth',3);
line([F_x B_x],[F_y B_y],'Color','g','LineWidth',3);
%% 출차
% 초기값, 바퀴간 거리, 속도, 시간
L = 2.7; 
v=0.5;
dt=0.01;
t=0:dt:20;

% 임의의 핸들 조정값(delta)생성
for i=1:150 %처음에 -10도 만큼 돌다가
delta(i)=(-10/150*i)*(pi/180);
end
for i=151:300 %다시 핸들을 돌리고
delta(i)=(-10+(10/150*(i-150)))*(pi/180);
end
for i=301:400 % 오른쪽으로 20도만큼 돌리고
delta(i)=(20/300*i)*(pi/180);
end
for i=401:500 % 다시 제자리로 돌아옴
delta(i)=(20+(-20/100*(i-400)))*(pi/180);
end
for i=501:900 %핸들을 다시 왼쪽으로 점차 최대각도만큼 꺽고
delta(i)=(-40.95/400*(i-500))*(pi/180);
end
for i=901:1700 %최대각도에서 회전함
delta(i)=-40.95*(pi/180);
end
for i=1701:1900 %그리고 다시 점차 핸들을 풀고
delta(i)=(-40.95+(40.25/200*(i-1700)))*(pi/180);
end
for i=1901:2000 % 직진하며 일자모습을 보여줌
delta(i)=0; 
end


% 바퀴의 초기 위치값
Front_x(1) = 12.5 + 1.25;
Front_y(1) =  5 - 0.43 - 0.935;
Back_x(1) = 12.5 + 1.25;
Back_y(1) = 0.43 + 0.935;

% theta의 초기값 설정
theta =  v * tan(delta(1))/L * dt;

% 출력
for i=1:2000
    theta(i+1)=theta(i)+ (v * tan(delta(i)))/L*dt;
    % 앞바퀴
    Front_x(i+1)=Front_x(i)+(v*sin(delta(i)+theta(i))*dt);
    Front_y(i+1)=Front_y(i)+(v*cos(delta(i)+theta(i))*dt);
    
    % 뒷바퀴
    Back_x(i+1)=Back_x(i)+v*0.8*sin(theta(i))*dt;
    Back_y(i+1)=Back_y(i)+v*0.9*cos(theta(i))*dt;
    
    
    hold on;
    plot(Front_x(i),Front_y(i),'ro');   
    plot(Back_x(i),Back_y(i),'ko');
    car_body_center=line([Front_x(i) Back_x(i)],[Front_y(i) Back_y(i)]);
    grid on; axis on;
    
     if mod(i,20) == 0
        pause(0.1);
     end
     if i~=2000
        delete(car_body_center);
     end
end
axis([0 20 0 15.5]);