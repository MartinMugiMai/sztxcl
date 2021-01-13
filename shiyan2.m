clc;clear;close all; 
img = imread('/Users/Martin/Downloads/rbjd002.jpg'); 
figure,
%imshow(img);

subplot(2,2,1);imshow(img);title('原图');

grayimg = rgb2gray(img); %转灰度
Ezhimg = grayimg;
[width,height] = size(grayimg);

subplot(2,2,2);imshow(grayimg);title('灰度');

T1 = 80;
%此循环二值化
for i = 1:width
    for j = 1:height
        if(grayimg(i,j)<T1)
            Ezhimg(i,j)= 255;
        else
            Ezhimg(i,j)= 0;
        end
    end
end

%figure,
%imshow(Ezhimg);
subplot(2,2,3);imshow(Ezhimg);title('二值化');

se=strel('disk',5);%创建圆盘 r为5
Ezhimg = imclose(Ezhimg,se);
Ezhimg = imopen(Ezhimg,se);


subplot(2,2,4);imshow(Ezhimg);title('形态学操作后的图像');

[mark_image,num] = bwlabel(Ezhimg,4);

status=regionprops(mark_image,'BoundingBox');
 
centroid = regionprops(mark_image,'Centroid');


figure;

subplot(2,2,1);imshow(mark_image);title('标记后的图像');
 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    
end

copy_mark_image = mark_image;
image_part8 = (copy_mark_image == 8);

%figure;右上角图形标记为8
%imshow(image_part8);
subplot(2,2,2);imshow(image_part8);title('右上角椭圆');



%%求质心
[L,num]=bwlabel(image_part8,8);     %%标注二进制图像中已连接的部分
plot_x=zeros(1,1);         %%用于记录质心位置的坐标
plot_y=zeros(1,1);

sum_x=0;sum_y=0;area=0;
[height,width]=size(image_part8);
for i=1:height
    for j=1:width
        if (L(i,j)==1)
            sum_x=sum_x+i;
            sum_y=sum_y+j;
            area=area+1;
        end
    end
end
%%质心坐标
plot_x(1)=fix(sum_x/area);
plot_y(1)=fix(sum_y/area);
%figure;imshow(image_part8);
subplot(2,2,3);imshow(image_part8);title('质心');

%%标记质心点
hold on
plot(plot_y(1) ,plot_x(1), '*')




%HUimg=invariable_moment(image_part8);
%subplot(2,2,3);imshow(HUimg);title('HU');

%求面积

tuxMJ = regionprops(image_part8,'Area');
fprintf('面积等于 = %f\n', tuxMJ.Area);
%求周长
tuxZC = regionprops(image_part8,'Perimeter');

fprintf('周长等于 = %f\n', tuxZC.Perimeter);
%离心率
tuxLXL = regionprops(image_part8,'Eccentricity');

fprintf('离心率 = %f\n', tuxLXL.Eccentricity);






