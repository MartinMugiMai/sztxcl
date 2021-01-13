clc;clear;close all; 
img = imread('/Users/Martin/Downloads/rbjd002.jpg'); 
figure,
%imshow(img);

subplot(2,2,1);imshow(img);title('ԭͼ');

grayimg = rgb2gray(img); %ת�Ҷ�
Ezhimg = grayimg;
[width,height] = size(grayimg);

subplot(2,2,2);imshow(grayimg);title('�Ҷ�');

T1 = 80;
%��ѭ����ֵ��
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
subplot(2,2,3);imshow(Ezhimg);title('��ֵ��');

se=strel('disk',5);%����Բ�� rΪ5
Ezhimg = imclose(Ezhimg,se);
Ezhimg = imopen(Ezhimg,se);


subplot(2,2,4);imshow(Ezhimg);title('��̬ѧ�������ͼ��');

[mark_image,num] = bwlabel(Ezhimg,4);

status=regionprops(mark_image,'BoundingBox');
 
centroid = regionprops(mark_image,'Centroid');


figure;

subplot(2,2,1);imshow(mark_image);title('��Ǻ��ͼ��');
 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    
end

copy_mark_image = mark_image;
image_part8 = (copy_mark_image == 8);

%figure;���Ͻ�ͼ�α��Ϊ8
%imshow(image_part8);
subplot(2,2,2);imshow(image_part8);title('���Ͻ���Բ');



%%������
[L,num]=bwlabel(image_part8,8);     %%��ע������ͼ���������ӵĲ���
plot_x=zeros(1,1);         %%���ڼ�¼����λ�õ�����
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
%%��������
plot_x(1)=fix(sum_x/area);
plot_y(1)=fix(sum_y/area);
%figure;imshow(image_part8);
subplot(2,2,3);imshow(image_part8);title('����');

%%������ĵ�
hold on
plot(plot_y(1) ,plot_x(1), '*')




%HUimg=invariable_moment(image_part8);
%subplot(2,2,3);imshow(HUimg);title('HU');

%�����

tuxMJ = regionprops(image_part8,'Area');
fprintf('������� = %f\n', tuxMJ.Area);
%���ܳ�
tuxZC = regionprops(image_part8,'Perimeter');

fprintf('�ܳ����� = %f\n', tuxZC.Perimeter);
%������
tuxLXL = regionprops(image_part8,'Eccentricity');

fprintf('������ = %f\n', tuxLXL.Eccentricity);






