clear; clc;
%% 1번
L = 2700;
t = 1572;

delta_d = [2,5,10,15,20,30];  % delta의 값
delta_r = deg2rad(delta_d);     % degree를 rad로    

R = L./tan(delta_r);               % delta = L/R이므로 R을 구함

% 수식(L^2)/(2R)을 이용하여 off_tracking_distance를 구함
otd = R - R.*cos(delta_r);

figure;
plot(delta_d,otd,'o');

%% 2번 - 5도
clear; clc;
v = 1.0019; L=2.7;
dt = 0.01; tt = 0:dt:20;

% delta는 차가 sin파형으로 움직이므로
% sin을 미분한 값이다.
delta_5 = 5*cos(0.1*pi*tt)*(pi/180);

% 각 앞바퀴 초기값 설정
x_front(1) = 0; y_front(1) = 0; 

% 뒷바퀴 초기값 설정
x_(1) = -L; y_(1) = 0;
x_back(1) = -L; y_back(1) = 0;

% 뒷바퀴의 이동 각도인 세타를 구함
theta_5(1) = v * tan(delta_5(1))/L * dt;

% 각 바퀴의 이동궤적을 표현할 figure
figure(1);
title('Steering Angle 5º일 경우');
xlabel('바퀴의 궤적 x좌표(m)');
ylabel('바퀴의 궤적 y좌표(m)');

% 바퀴와 차체를 표현할 loop문
 for i = 1:1:2000
    % 기존 delta에는 theta값이 포함되어있으니 빼줌
    delta_5(i) =  delta_5(i) - theta_5(i);
    
    % (v * tan(delta_5(i)))/L * dt 이 공식은 변화량이므로,
    % 이전값과 더하면서 누적값을 구해줌
    theta_5(i+1) = theta_5(i) + (v * tan(delta_5(i)))/L * dt;
    
    % 앞바퀴의 궤적을 구함
    % 이때도 변화량이므로, 이전값과 함치며 누적값을 구함
    x_front(i+1)  = x_front(i) + (v * cos(theta_5(i) + delta_5(i)) * dt);
    y_front(i+1)  = y_front(i) + (v * sin(theta_5(i) + delta_5(i)) * dt); 
    
    % 뒷바퀴
    x_back(i+1) = x_(1) * cos(theta_5(i)) - y_(1) * sin(theta_5(i)) + x_front(i);
    y_back(i+1) = x_(1) * sin(theta_5(i)) + y_(1) * cos(theta_5(i)) + y_front(i);
    
    % 바퀴 궤적과 동시에 차체를 보여주기 위해 설정
    hold on;
    a = line([x_front(i) x_back(i)],[y_front(i) y_back(i)], 'Color', 'k', 'LineWidth', 30); % 차체 
    c = line([x_front(i) x_back(i)],[y_front(i) y_back(i)],'Color', 'y');   % 차 축
    a.Color=[0,0,0,0.5];   % 차체의 투명도 조절
    
    % 실시간으로 바퀴의 궤적을 찍음
    plot(x_front(i),y_front(i),'r-o');  
    plot(x_back(i),y_back(i),'b-o');
    grid on; axis on;
    hold off;
    xlim([-3 20]);
    ylim([-1.5 1.5]);
    
    % 50개마다 잠시 pause하며 실시간으로 이동하는것처럼 보이게 함
    if mod(i,50) == 0     
        pause(0.0001);
    end
     
    % 이전에 출력한 차체를 삭제하고 다시 출력하기 위함
    if i~=2000
         delete(a);
         delete(c);
    end
 end
 
 %% 2번 - 20도
clear; clc;
v = 1.0019; L=2.7;
dt = 0.01; tt = 0:dt:20;

% delta는 차가 sin파형으로 움직이므로
% sin을 미분한 값이다.
delta_5 = 20*cos(0.1*pi*tt)*(pi/180);

% 각 앞바퀴 초기값 설정
x_front(1) = 0; y_front(1) = 0; 

% 뒷바퀴 초기값 설정
x_(1) = -L; y_(1) = 0;
x_back(1) = -L; y_back(1) = 0;

% 뒷바퀴의 이동 각도인 세타를 구함
theta_5(1) = v * tan(delta_5(1))/L * dt;

% 각 바퀴의 이동궤적을 표현할 figure
figure(1);
title('Steering Angle 20º일 경우');
xlabel('바퀴의 궤적 x좌표(m)');
ylabel('바퀴의 궤적 y좌표(m)');

% 바퀴와 차체를 표현할 loop문
 for i = 1:1:2000
    % 기존 delta에는 theta값이 포함되어있으니 빼줌
    delta_5(i) =  delta_5(i) - theta_5(i);
    
    % (v * tan(delta_5(i)))/L * dt 이 공식은 변화량이므로,
    % 이전값과 더하면서 누적값을 구해줌
    theta_5(i+1) = theta_5(i) + (v * tan(delta_5(i)))/L * dt;
    
    % 앞바퀴의 궤적을 구함
    % 이때도 변화량이므로, 이전값과 함치며 누적값을 구함
    x_front(i+1)  = x_front(i) + (v * cos(theta_5(i) + delta_5(i)) * dt);
    y_front(i+1)  = y_front(i) + (v * sin(theta_5(i) + delta_5(i)) * dt); 
    
    % 뒷바퀴
    x_back(i+1) = x_(1) * cos(theta_5(i)) - y_(1) * sin(theta_5(i)) + x_front(i);
    y_back(i+1) = x_(1) * sin(theta_5(i)) + y_(1) * cos(theta_5(i)) + y_front(i);
    
    % 바퀴 궤적과 동시에 차체를 보여주기 위해 설정
    hold on;
    a = line([x_front(i) x_back(i)],[y_front(i) y_back(i)], 'Color', 'k', 'LineWidth', 30); % 차체 
    c = line([x_front(i) x_back(i)],[y_front(i) y_back(i)],'Color', 'y');   % 차 축
    a.Color=[0,0,0,0.5];   % 차체의 투명도 조절
    
    % 실시간으로 바퀴의 궤적을 찍음
    plot(x_front(i),y_front(i),'r-o');  
    plot(x_back(i),y_back(i),'b-o');
    grid on; axis on;
    hold off;
    xlim([-3 20]);
    ylim([-1.5 1.5]);
    
    % 50개마다 잠시 pause하며 실시간으로 이동하는것처럼 보이게 함
    if mod(i,50) == 0     
        pause(0.0001);
    end
     
    % 이전에 출력한 차체를 삭제하고 다시 출력하기 위함
    if i~=2000
         delete(a);
         delete(c);
    end
 end