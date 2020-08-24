clear; clc;
load ('gps_wgs84.mat');

len=length(gps(:,1));
start_point=gps(1,:);
end_point=gps(len,:);
[utmX,utmY,utmzone,utmhemi] = wgs2utm(gps(:,1),gps(:,2),52,'k');

g_size = ones(1,length(gps));
real_map = geobubble(gps(:,1), gps(:,2),g_size,'Basemap', 'satellite');


