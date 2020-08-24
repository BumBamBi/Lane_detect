function idx = find_closest_point(vx, vy, px, py)


for i = 1:length(px)
    dist(i) = sqrt( (px(i)-vx)^2 + (py(i)-vy)^2 );
end

[m,idx] = min(dist);

