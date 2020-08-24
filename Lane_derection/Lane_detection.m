clear; clc;
%% 파일 불러오기 및 변수 설정

% 불러올 파일 이름 지정
% filename = 'solidWhiteRight.mp4';
% filename = 'challenge.mp4';
% filename = 'solidYellowLeft.mp4';
filename = 'my.mp4';

% 파일을 double형식으로 불러온 후, 보여줄 파일 창을 설정한다.
VideoSource = vision.VideoFileReader(filename, 'VideoOutputDataType','double');
VideoOut = vision.VideoPlayer('Name', 'Output');    % Output 창
VideoOut2 = vision.VideoPlayer('Name', 'Canny');    % Canny 창

% 새로 생성할 파일 이름 지정
% vidName = 'solidWhiteRight_LKW';
% vidName = 'challenge_LKW';
% vidName = 'solidYellowLeft_LKW';
vidName = 'my_LKW';

frmRate = 10;
% 프레임 간격 설정

video = VideoWriter(vidName);
% 파일 이름으로 비디오 작성

video.FrameRate = (frmRate);
%프레임 간격을 비디오에 적용시킴

open(video);
% 파일 열기(녹화시작)

%% Canny edge 적용

while ~isDone(VideoSource)
   img = step(VideoSource);
   img_ori = imresize(img,0.5);
   col = length(img_ori(:,1));
   row = length(img_ori(1,:));
   
   img_ori = imcrop(img_ori, [1 col/2 row col/2]);
   % 사진의 절반을 잘라냄
   
   img_gray = rgb2gray(img_ori);
   img_gray = double(img_gray);
   % 사진을 흑백으로 바꾸고, double형 변수로 변환시킴
   % canny_acl()은 사진 그대로를 가져와서 사용할 수 없기 때문.
   % canny_acl은 cannt edge검출을 위해 아까 설명한 함수
   
   BW1 = canny_acl(img_gray, 3, 10, 0.3, 0.05);
   % 이미지를 3x3 size, sigma는 10인 가우시안 필터를 적용시킨 채로
   % 0.05 ~ 0.3의 threshold를 가지는 canny-edge detection 알고리즘을 실행
   
   %% Hough 변환
   [H, T, R] = hough(BW1);
   % H : hough의 theta와 r을 대응하는, x-y 공간에 놓여진 점의 개수 (=edgeㄹ로 판단되는 픽셀의 개수)
   % T : theta, 180(-90 ~ 90)
   % R : 픽셀의 대각선의 길이
   
   P = houghpeaks(H, 10, 'threshold', ceil(0.4*max(H(:))));
   [lines] = houghlines(BW1, T, R, P, 'FillGap', 10, 'MinLength', 5);
   % Max number of peaks =  점들이 만나는 선(접점)의 개수를 제한함으로써 line검출에 용이하도록 함.
   %                        값이 작아질수록 겹치는 선의 개수를 제한하므로 더 적은 선이 검출되지만, 일정 값
   %                        이상이면 큰 차이가 없다.
   %                        따라서, 곡선의 경우는 이 값이 커질수록 보다 자연스러운 선이 검출된다.
   % threshold = hough() 를 거친 H의 값의 최대값을 기준으로, 그 신뢰도를 할당하는 것.
   %             결국 검출한 선이 해당 값만큼 line으로써 신뢰도가 있는지 확인한다.
   %             따라서, 값이 낮을수록 많은 line들이 검출되고, 값이 높을수록 line이 검출되지 않는다.
   %             곡선의 경우는 신뢰도가 낮을 경우 더 잘 검출되고, 값이 커지면 선을 거의 검출하지 않음
   % FillGap = 분리된 선을 하나의 직선으로 이어주기 위한 최대 간격
   %           따라서, 값이 작을수록 선이 분리된채로 표현되고, 
   %           값이 클수록 연관성이 없더라도 선끼리 연결되어 하나의 직선으로 표현됨
   %           곡선의 경우에는 이 값이 커질수록 더 자연스러운 값을 얻을 수 있지만,
   %           너무 커지면, 불필요한 선까지 연결되어 표현하게된다.
   % MinLength = 가장 짧은 선의 길이를 정하는것이다.
   %             따라서 값이 작으면 짧은 선들이 많이 검출되고, 클수록 짧은 선은 덜 검출되지만 필요한 선이 검출되지 않을 수 있다.

   % 각 파라미터 값을 여러번 비교해서 가장 최적의 값을 뽑아 적용시킴   
   
   c1 = [];
   c2 = [];
   l = [];
   
   for k = 1:length(lines)
      if (lines(k).theta < 70 && lines(k).theta > -70)
          c1 = [c1; [lines(k).point1 2]];
          c2 = [c2; [lines(k).point2 2]];
          l = [l; lines(k).point1 lines(k).point2];
          % point1은 시작점의 x, y좌표,
          % point2는 끝점의 x, y 좌표가 들어있음
      end
   end
   
   img_ori = insertShape(img_ori, 'Line', l, 'Color', 'green', 'LineWidth', 3);
   img_ori = insertShape(img_ori, 'Circle', c1, 'Color', 'red');
   img_ori = insertShape(img_ori, 'Circle', c2, 'Color', 'yellow');
   % 차선은 green, 시작점은 red, 끝점은 yellow로 표현
   
   step(VideoOut2, BW1);
   step(VideoOut, img_ori);
   % VideoOut창과, VideoOut2 창에 각각 img_ori와 BW1을 보여준다.
   
   img_ori = im2double(img_ori);
   img_ori(img_ori>1) = 1;
   img_ori(img_ori<0) = 0;
   % img_ori를 double형으로 [0 1] 범위에 존재하도록 range를 조정한다.
   
   writeVideo(video, img_ori);
   % video에 img_ori로 파일을 작성한다.
      
end

close(video);