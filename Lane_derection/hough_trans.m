clear all; close all; figure(1); clf; grid on;

X = []; Y = [];
% 각 x값, y값을 저장하는 행렬

while (length(X) < 11)
    % 최대 10개의 점을 찍음
    
    figure(1);
    set(gca,'Ydir','reverse');
    set(gca,'XAxisLocation','top'); 
    % y축을 아래로쪽으로 내린다.
    
    xlim([0 100]); ylim([0 100]);
    % 각 x, y 축의 범위를 0 ~ 100으로 설정함
    
    [x, y] = getpts;
    % getpts를 실행
    % getpts -> 찍은 점의 좌표를 저장하는 함수
    
    x = ceil(x); y = ceil(y);
    % x, y값을 올림한 값으로 저장.
    
    X = [X; x]; Y =[Y; y];
    % X에 새로 찍은 좌표를 계속해서 추가시킴
    
    clf;
    % clf를 실행하여 figure창을 reset해줌
    
    
    for i = 1:length(x)
        plot(X(i),Y(i),'.','MarkerSize',20); hold on; grid on;
        % (x,y)를 20 Size의 점으로 표현해준다.
    end
    theta = -90:0.1:90;
    
    Rho = X*cos(theta*pi/180) + Y*sin(theta*pi/180);
    % Rho의 값은 수식에 의해 위와같이 나타낼 수 있음
    
    figure(2); clf; plot(theta, Rho); hold on; grid on;
    %theta와 Rho를 기준으로 그래프를 그려준다.
    
    xlim([-91 91]); ylim([-sqrt(2)*100 sqrt(2)*100]);
    
end