clear; clc;
load ('gps_wgs84.mat');

len=length(gps(:,1));
start_point=gps(1,:);
end_point=gps(len,:);

figure(1); zlim([0 100]); hold on; grid on; title('GPS wgs84 201601784 이광우');
xlabel('latitude');ylabel('longitude');zlabel('altitude');
plot3(start_point(1), start_point(2), start_point(3),'o','MarkerFaceColor', 'b');
plot3(end_point(1), end_point(2), end_point(3),'o','MarkerFaceColor', 'r');

for t = 1:len
    if(gps(t,4)==2)
        plot3(gps(t,1), gps(t,2), gps(t,3),'.y','MarkerSize',5);
    elseif(gps(t,4) == 5)
        plot3(gps(t,1), gps(t,2), gps(t,3),'.g','MarkerSize',5);
    elseif(gps(t,4) == 4)
        plot3(gps(t,1), gps(t,2), gps(t,3),'.m','MarkerSize',5);
    elseif(gps(t,4) == 1)
        plot3(gps(t,1), gps(t,2), gps(t,3),'.k','MarkerSize',5);
    end
end
view(45,45);


