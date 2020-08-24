%% hough transform
% xy 좌표계를 r-theta 좌표계로 domain을 옮겨서 겹치는 직선을 검출

img = imread('lanedetect.bmp');
img_ori = imresize(img,0.5);

col = length(img_ori(:,1));
row = length(img_ori(1,:));
img_ori = imcrop(img_ori, [1 col/2 row col/2]);
% 사진의 절반을 잘라냄

img_gray = rgb2gray(img_ori);
img_gray = double(img_gray);
 BW1 = canny_acl(img_gray, 3, 10, 0.3, 0.05);

[H, T, R] = hough(BW1);
% Hough : n개의 점을 동시에 지나는 직선에 대해 r-thta domain에서 n-1의 값을 가짐
% T(theta) : hough 변환을 위해 sampling된 -90 ~ 90(도)의 각도
% R(rho) : hough 변환을 위해 sampling된 min(r) ~ mas(r), 원점으로부터의 길이

P = houghpeaks(H, 35, 'threshold', ceil(0.3*max(H(:))));
% P(peak) : hough 변환을 한 결과, 최대 peak의 개수를 35개로 한정시킴
%           또한 그 신뢰도를, 최대치의 0.3으로 한계치를 설정한다.

[lines] = houghlines(BW1, T, R, P, 'FillGap', 10, 'MinLength', 25);
% FillGap : 직선과 직선 사이의 거리며, 잢이 작을수록 촘촘해진다. (점을 기준으로 하기 때문)
% MinLength : hough 변환의 결과로 직선인 R,T가 나오므로, 그 최소길이가 8 이상인 선분만을 검출한다.
% lines : line의 시작점과 끝점, 각도와 길이값이 들어있는 변수

%% Lane selection
c1 = [];
c2 = [];
l = [];

for k=1:length(lines)
    if( lines(k).theta< 60 && lines(k).theta > -60 )
       % lane detect를 위해서 -75도 ~ 75도로 각도를 제한하여 필요한 line만을 검출함
       c1 = [c1; [lines(k).point1 3]];
       % plot에서 원을 그리기 위해서 좌표(c1, lines(k).point1)에 반지름이 3인 점을 그린다.
       % lines(k).point1에 의해서 line의 시작점이 표시됨
       
       c2 = [c2; [lines(k).point2 3]];
       % plot에서 원을 그리기 위해서 좌표(c2, lines(k).point2)에 반지름이 3인 점을 그린다.
       % lines(k).point2에 의해서 line의 끝점이 표시됨
       
       l = [l; lines(k).point1 lines(k).point2];
       % l : line의 시작점과 끝점을 이은 직선   
    end
end

img_line2 = insertShape(uint8(img_gray), 'Line', l, 'Color', 'green', 'Linewidth', 3);
% l좌표에 line을 초록색선으로 그림
img_line2 = insertShape(uint8(img_line2), 'Circle', c1, 'Color', 'red');
% l의 시작점에 빨간 점을 그림
img_line2 = insertShape(uint8(img_line2), 'Circle', c2, 'Color', 'yellow');
% l의 끝점에 노란점을 그림

figure();
imshow(img_line2);
