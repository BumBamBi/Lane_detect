clear; clc;
load ('gps_wgs84.mat');

len=length(gps(:,1));

start_point=gps(1,:);
end_point=gps(len,:);

[utmX,utmY,utmzone,utmhemi] = wgs2utm(gps(:,1),gps(:,2),52,'s');
figure(1);hold on; grid on; title('GPS UTM 201601784 이광우');
xlabel('x(m)'); ylabel('y(m)'); plot(utmX,utmY);
plot(utmX(1,1),utmY(1,1),'o','MarkerFaceColor','b');
plot(utmX(len,1),utmY(len,1),'o','MarkerFaceColor','r');




