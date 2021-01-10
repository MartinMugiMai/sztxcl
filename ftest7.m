clc;clear;close all;  
 

%载入图片
im=imread('/Users/Martin/Downloads/lsm111.jpeg'); 
figure,
subplot(2,2,1);imshow(im);title('源图像');

 
%选取图像上的一个正方形的ROI区域；  
%im0 = imcrop(im,[1198 54 2210 2210]);  
im0 = imcrop(im,[80 66 522 522]);
subplot(2,2,2);imshow(im0,'DisplayRange',[]);title('选取ROI后的图像');


 
%%%%%高斯滤波%%%%%
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
se=strel('disk',5);%创建圆盘 r为5
%Ezhimg = imclose(Ezhimg,se);
%Ezhimg = imopen(Ezhimg,se);

%figure,
%imshow(Ezhimg);title('形态学操作后的图像');
subplot(2,2,2);imshow(Ezhimg);title('形态学操作后的图像');

[mark_image,num] = bwlabel(Ezhimg,4);

status=regionprops(mark_image,'BoundingBox');
 
centroid = regionprops(mark_image,'Centroid');


%figure;

subplot(2,2,3);imshow(mark_image);title('标记后的图像');
%imshow(mark_image);title('标记后的图像');
 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    
end

copy_mark_image = mark_image;
image_part1 = (copy_mark_image == 1);



%figure,
subplot(2,2,3);imshow(image_part1);title('大圆');
%imshow(image_part1);title('大');

tuxZC = regionprops(image_part1,'Perimeter');
fprintf('周长等于 = %f\n', tuxZC.Perimeter);
banjin =  (tuxZC.Perimeter/pi)/2;
fprintf('半径等于 = %f\n', banjin);
bw2 = image_part1;



[B L] = bwboundaries(bw2);  %寻找边缘，不包括孔,L是标记矩阵
figure,   %%%创建空白的图像
hold on
for k = 1:length(B)
    boundary = B{k};  %B是一个胞元数组，所以是B{k}
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);%% 画出边缘
end%整个循环表示的是描边
 
 
%% 
%%%%%寻找hough圆的圆心%%%%%%%
Rmin = 100;
Rmax = 200;
[centersBright, radiiBright] = imfindcircles(im1,[Rmin Rmax],'ObjectPolarity' ,'bright');
viscircles(centersBright,radiiBright,'EdgeColor','b');
hold on 
plot(centersBright(1),centersBright(2),'*');
fprintf('圆心坐标x = %f\n', centersBright(1));
fprintf('圆心坐标y = %f\n', centersBright(2));

hold off;
 
%% 等分圆
R=246; t=0:pi/5:2*pi; %2*pi*(0:40)/40
x=R*cos(t);
y=R*sin(t);
axis equal
n=10;a=2*pi/n;
for k=0:n-1
    hold on         %R是等分划线的长度一半，而banjin是大圆的半径
    plot([centersBright(1)-banjin*cos(pi+k*a),centersBright(1)+banjin*cos(pi+k*a)],[centersBright(2)-banjin*sin(pi+k*a),centersBright(2)+banjin*sin(pi+k*a)])
end