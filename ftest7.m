clc;clear;close all;
%载入图片
im=imread('/Users/Martin/Downloads/lsm111.jpeg'); 

figure,
subplot(2,2,1);imshow(im);title('源图像');
%截取一个正方形选取ROI感兴趣区域图像让螺丝帽图形尽量占入画面  
im0 = imcrop(im,[80 66 522 522]);

subplot(2,2,2);imshow(im0,'DisplayRange',[]);title('截图选取ROI感兴趣区域');

im0 = rgb2gray(im0); %转灰度
 
%高斯滤波
sigma = 1.6;
gausFilter = fspecial('gaussian',[5 5],sigma);
blur=imfilter(im0,gausFilter,'replicate');
%figure,imshow(blur);
%title('高斯滤波后的图像');
subplot(2,2,3);imshow(blur);title('高斯滤波后的图像');
 
level = graythresh(blur);   %%%ostu算法求阈值进行二值化
im1 = im2bw(blur,level);
%figure,imshow(im1);
%title('二值图像');
subplot(2,2,4);imshow(im1);title('二值图像');
 
bw1=bwlabel(im1,8);
stats=regionprops(bw1,'Area');
bw2 = ismember(bw1, find([stats.Area]) == max([stats.Area])); %%找到面积最大的对象
figure,
%imshow(bw2);
%title('二值图像');

subplot(2,2,1);imshow(bw2);title('二值图像(反相)');

Ezhimg = bw2;

[mark_image,num] = bwlabel(Ezhimg,4);
%正方形框住图形
status=regionprops(mark_image,'BoundingBox');
%找到图形的质心
centroid = regionprops(mark_image,'Centroid');
%将螺丝帽所含图形标出
subplot(2,2,2);imshow(mark_image);title('将螺丝帽所含图形标出'); 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','g');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'y') 
    
end


copy_mark_image = mark_image;
%将螺丝帽的图形分离
image_part1 = (copy_mark_image == 2);
subplot(2,2,3);imshow(image_part1);title('小圆');

image_part1 = (copy_mark_image == 1);

%figure,
subplot(2,2,4);imshow(image_part1);title('大圆');

%利用周长计算大圆的半径
tuxZC = regionprops(image_part1,'Perimeter');
fprintf('周长等于 = %f\n', tuxZC.Perimeter);
banjin =  (tuxZC.Perimeter/pi)/2;
fprintf('半径等于 = %f\n', banjin);
bw2 = image_part1;


%画圆等分
[B L] = bwboundaries(bw2);  %寻找边缘
figure,   
hold on
for k = 1:length(B)
    boundary = B{k};  %B是一个胞元数组，所以是B{k}
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);%% 画出边缘
end%整个循环表示的是描边
 
 
%确定圆的圆心坐标 
Rmin = 100;
Rmax = 200;
[centersBright, radiiBright] = imfindcircles(im1,[Rmin Rmax],'ObjectPolarity' ,'bright');
viscircles(centersBright,radiiBright,'EdgeColor','b');
hold on 
plot(centersBright(1),centersBright(2),'*');
fprintf('圆心坐标x = %f\n', centersBright(1));
fprintf('圆心坐标y = %f\n', centersBright(2));
hold off;
 
% 等分圆
R=246; t=2*pi*(0:40)/40; 
x=R*cos(t);
y=R*sin(t);
axis equal
n=20;a=2*pi/n;
for k=0:n-1
    hold on   %R是等分划线的长度一半，而banjin是大圆的半径
    plot([centersBright(1)-banjin*cos(pi+k*a),centersBright(1)+banjin*cos(pi+k*a)],[centersBright(2)-banjin*sin(pi+k*a),centersBright(2)+banjin*sin(pi+k*a)])
end