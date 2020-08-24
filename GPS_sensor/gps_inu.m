%% 초기 설정
axesm utm
title('GPS 이광우');
%% gps 그래프 가져와서 그리기
load ('gps_wgs84.mat');
len=length(gps(:,1));
start_point=gps(1,:);
end_point=gps(len,:);
[utmX,utmY,utmzone,utmhemi] = wgs2utm(gps(:,1),gps(:,2),52,'s');

hold on;
plot(utmX,utmY,'Linewidth',5);
plot(utmX(1,1),utmY(1,1),'o','MarkerFaceColor','b');
plot(utmX(len,1),utmY(len,1),'o','MarkerFaceColor','r');

%% 그림 불러와서 그리기
im = imread('INU_road.png');
im = flipud(im);
im = imresize(im,1.2);
image(utmX(1)-850,utmY(1)-520,im,'AlphaData',0.6); 
hold off;

axis tight;
