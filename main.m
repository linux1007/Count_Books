clc;
clear all;
close all;
img=imread("image.jpg");    % read an input image
subplot(2,2,1); 
imshow(img);
title('original image');

r2g=rgb2gray(img);

% Edge Detection using canny method
r2g= edge(r2g,'sobel');
subplot(2,2,2);
imshow(r2g);
title('edge detected image');

% Hough Transform
[H,theta,rho] = hough(r2g);

P = houghpeaks(H,25,'threshold',ceil(0.3*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));

lines = houghlines(r2g,theta,rho,P,'FillGap',15);
subplot(2,2,3);
imshow(r2g), 
hold on

title('hough transformed image');

max_len = 0;
cnt_ver=0;
cnt_hrz=0;
max_len=0;
tht=0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','blue');
    
   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','red');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   if (lines(k).theta>=-100 & lines(k).theta<=-80)
        cnt_hrz=cnt_hrz+1;
   end
   
   if lines(k).theta<=10 & lines(k).theta>=-10
       cnt_ver=cnt_ver+1;
   end
   
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len)
      max_len = len;
      tht=lines(k).theta;
      xy_long = xy;
   end
   
end

plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','red');
ans=0;
chck=max_len/2;

% to count vertical and horizontal lines 
% as well as find their inclinations
if(tht<=10 && tht>=-10)
    for k=1:length(lines)
        len = norm(lines(k).point1 - lines(k).point2);
        if (max_len-len>=0 & max_len-len<=chck & lines(k).theta>=-10 & lines(k).theta<=10)
            ans=ans+1;
        end
    end 
end
if (tht>=-100 && tht<=-80)
    for k=1:length(lines)
        len = norm(lines(k).point1 - lines(k).point2);
        if (max_len-len>=0 & max_len-len<=chck & lines(k).theta>=-100 & lines(k).theta<=-80)
            ans=ans+1;
        end
    end   
end

ans=ans-2; % to wipe out the border lines of the books.