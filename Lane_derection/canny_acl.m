function output_img = Canny_acl(src_img ,filtersz, gamma, th_h, th_l)
%% gaussian filter
% noise를 없애고, 데이터를 약간 희미하게 만들면서, detail edge를 제거하는 과정이다.
% 기존 사진 데이터가 double형으로 변환된 채로 입력되었다.

g1 = fspecial('gaussian', [filtersz, filtersz], gamma);
% filtersz = 3으로 입력받아왔고, gamma = 10으로 입력받았다.
% 따라서 3x3 픽셀 크기를 가진, sigma = 10인 가우시안 필터(g1)을 생성했다.

img1 = filter2(g1,src_img);
% img1에 입력받아온 사진에 g1필터를 적용시킨 값을 대입한다.

%% Calculating gradient with sobel mask
% Gradient : 가중치(edge일 가능성을 보여주는 값)를, sobel mask로 판단함
% sobel mask는 각 수평, 수직으로 미분을 함.

sobelMaskX = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sobelMaskY = [1, 2, 1; 0, 0, 0; -1, -2, -1];
% 각 x, y의 sobel mask를 설정해줌
% 각x, y는 다음과 같은 모양을 함(사진 참조)

% Convolution by image by horizontal and vertical filter
G_X = conv2(img1, sobelMaskX, 'same');
G_Y = conv2(img1, sobelMaskY, 'same');
% Convolution 연산을 통하여 각 수평과 수직에 대해 필터 적용하기

% Calcultae magnitude of edge
magnitude = (G_X.^2) + (G_Y.^2);
magnitude = sqrt(magnitude);
% edge의 magnitude(수평/수직 성분의 기울기 크기)를 계산하여, edge의 가능성을 판단한다.
% x축일때의 가능성과, y축일때의 가능성을 제곱하여 더하고, 루트를 씌움으로 계산함

%Calculate directions/orientations
theta = atan2(G_Y, G_X);
theta = theta*180/pi;
% gradient(가중치)의 방향
% x, y축의 가능성 그래프의 기울기를 이용하여 구한 값(도)를 radian으로 변환

%Adjustment for negative directions, making all directions positive
col = length(src_img(:,1));
row = length(src_img(1,:));
% 이미지의 가로/세로 길이값

for i=1:col
    for j=1:row
        if (theta(i,j)<0) 
            % 각 이미지 픽셀당, gradient의 방향을 검출함
            theta(i,j)=360+theta(i,j);
            % 방향 radian이 음수라면, 360과 합하여, 시계방향으로 각도를 구함
        end
    end
end
%% quantization theta
% 위에서 구한, theta의 값을 quantization(양자화) 시킴

qtheta = zeros(col, row);
% qtheta는, 각 픽셀에 대한 gradient의 방향을 quantization한 값 (q + theta)
% gradient의 방향을 4개로 quantization 함(음/양수 구분X)

% Adjusting directions to nearest 0, 45, 90, or 135 degree
% 360도를 8등분하여, 하나당 45도 간격으로 나눠진 기준을, 22.5도 기울여서 quantization 함.
% 같은 값을 가지는 2개의 조각들, 즉 4(0~3)의 값을 가지는 조각들로 나누어짐

for i = 1  : col
    for j = 1 : row
        if ((theta(i, j) >= 0 ) && (theta(i, j) < 22.5) || (theta(i, j) >= 157.5) && (theta(i, j) < 202.5) || (theta(i, j) >= 337.5) && (theta(i, j) <= 360))
            qtheta(i, j) = 0; % 0 조각에 위치    (-22.5 ~ 22.5)
        elseif ((theta(i, j) >= 22.5) && (theta(i, j) < 67.5) || (theta(i, j) >= 202.5) && (theta(i, j) < 247.5))
            qtheta(i, j) = 1; % 1 조각에 위치    (22.5 ~ 67.5)
        elseif ((theta(i, j) >= 67.5 && theta(i, j) < 112.5) || (theta(i, j) >= 247.5 && theta(i, j) < 292.5))
            qtheta(i, j) = 2; % 2 조각에 위치    (67,5 ~ 112.5)
        elseif ((theta(i, j) >= 112.5 && theta(i, j) < 157.5) || (theta(i, j) >= 292.5 && theta(i, j) < 337.5))
            qtheta(i, j) = 3; % 3 조각에 위치    (112.5 ~ 157.5)
        end
    end
end
% 강의 자료에 나온 사진을 참고하면 설명하기 편함 

%% Non-Maximum Supression
% gradient 방향에 따라 픽셀 값을 비교하여 edge인지 아닌지 판단하기
BW = zeros (col, row);

for i=2:col-1
    for j=2:row-1
        % qtheta 값에 따라, gradient값을 비교하는 픽셀을 정함.
        % 최대값과 현재 칙셀값이 일치하면 edge라고 판단(1), 아니면 edge가 아니라고 판단(0)함.
        if (qtheta(i,j)==0) 
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i,j+1), magnitude(i,j-1)]));
        elseif (qtheta(i,j) == 1)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j-1), magnitude(i-1,j+1)]));
        elseif (qtheta(i,j) == 2)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j), magnitude(i-1,j)]));
        elseif (qtheta(i,j) == 3)
            BW(i,j) = (magnitude(i,j) == max([magnitude(i,j), magnitude(i+1,j+1), magnitude(i-1,j-1)]));
        end
    end
end
BW = BW.*magnitude;
% 위 과정을 거치며 나온 BW값은 0, 1 둘 중 하나임(1->edge / 0->not edge)
% 이 값에 magnitude(edge의 가능성)값을 곱한다.

%% Hysteresis Thresholding
% 상대적으로 높은 가능성의 edge만 남기는 과정
% 이 과정을 거치기 위해 일정 임계값(신뢰도)을 미리 정한다.
% 일정 값 이하는 제거하므로, noise도 함께 많이 줄어듬

T_min = th_h;
T_max = th_l;
% 두 값 모두, 함수의 인자로 받아온다.
% 최소임계값보다 작으면 edge로 생각하지 않음
% 최대임계값보다 크면 Strong edge로 생각함
% 그 외는 Weak edge로 생각함


%Hysteresis Thresholding
T_min = T_min * max(max(BW));
T_max = T_max * max(max(BW));
% gradient(edge의 가능성)의 최댓값에 임계값을 곱함

edge_final = zeros (col, row);
% 최종 값을 저장할 배열

for i = 1  : col
    for j = 1 : row
        % no edge
        if (BW(i, j) < T_min) 
            edge_final(i, j) = 0;
            % 최소 임계값보다 작은 경우, edge로 판단X(0)
            
        % Strong edge
        elseif (BW(i, j) > T_max)
            edge_final(i, j) = 1;
            % 최대 임계값보다 작은 경우, Strong edge로 판단(1)
            
        % Weak edge
        elseif ( BW(i+1,j)>T_max || BW(i-1,j)>T_max || BW(i,j+1)>T_max || BW(i,j-1)>T_max || BW(i-1, j-1)>T_max || BW(i-1, j+1)>T_max || BW(i+1, j+1)>T_max || BW(i+1, j-1)>T_max)
            edge_final(i,j) = 1;
            % 해당 픽셀 주변의 8픽셀 중, Strong Edge가 있다면, Weak edge로 판단(1)
        end
    end
end

img_canny = uint8(edge_final.*255);
% 위 과정으로 구한 edge(0과 1)의 값에 255를 곱하여
% 흑과 백으로 edge를 표현한다.(0 or 255)

output_img = img_canny;
% edge를 흑백으로 표현한사진을 return 한다.
end