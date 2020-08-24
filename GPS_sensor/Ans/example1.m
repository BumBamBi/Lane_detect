%% 지도위에 overlay
close all; clear; clc;
load('gps_wgs84.mat'); 
img = imread('inu.jpg');
image(img)
title('image');
xlabel('x (pixel)'); ylabel('y (pixel)'); 
%% 실험적으로 UTM 좌표값 선정
X = 2.90030*10^5:2.90800*10^5;
Y = 4.1388*10^6:4.13938*10^6;

[utmX, utmY, utmzone, utmhemi] = wgs2utm(gps(:,1), gps(:,2), 52,'s'); 
figure; hold on; grid on; axis equal; 
title('GPS UTM');
xlabel('x (m)'); ylabel('y (m)'); 
flip_img = flipud(img); 
image(X,Y,flip_img);
plot(utmX, utmY,'r','LineWidth',5);