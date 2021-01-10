clc;clear;close all;  
 

%����ͼƬ
im=imread('/Users/Martin/Downloads/lsm111.jpeg'); 
figure,
subplot(2,2,1);imshow(im);title('Դͼ��');

 
%ѡȡͼ���ϵ�һ�������ε�ROI����  
%im0 = imcrop(im,[1198 54 2210 2210]);  
im0 = imcrop(im,[80 66 522 522]);
subplot(2,2,2);imshow(im0,'DisplayRange',[]);title('ѡȡROI���ͼ��');


 
%%%%%��˹�˲�%%%%%
sigma = 1.6;
gausFilter = fspecial('gaussian',[5 5],sigma);
blur=imfilter(im0,gausFilter,'replicate');
%figure,imshow(blur);
%title('��˹�˲����ͼ��');
subplot(2,2,3);imshow(blur);title('��˹�˲����ͼ��');
 
level = graythresh(blur);   %%%ostu�㷨����ֵ���ж�ֵ��
im1 = im2bw(blur,level);
%figure,imshow(im1);
%title('��ֵͼ��');
subplot(2,2,4);imshow(im1);title('��ֵͼ��');
 
bw1=bwlabel(im1,8);
stats=regionprops(bw1,'Area');
bw2 = ismember(bw1, find([stats.Area]) == max([stats.Area])); %%�ҵ�������Ķ���
figure,
%imshow(bw2);
%title('��ֵͼ��');

subplot(2,2,1);imshow(bw2);title('��ֵͼ��(����)');

Ezhimg = bw2;
se=strel('disk',5);%����Բ�� rΪ5
%Ezhimg = imclose(Ezhimg,se);
%Ezhimg = imopen(Ezhimg,se);

%figure,
%imshow(Ezhimg);title('��̬ѧ�������ͼ��');
subplot(2,2,2);imshow(Ezhimg);title('��̬ѧ�������ͼ��');

[mark_image,num] = bwlabel(Ezhimg,4);

status=regionprops(mark_image,'BoundingBox');
 
centroid = regionprops(mark_image,'Centroid');


%figure;

subplot(2,2,3);imshow(mark_image);title('��Ǻ��ͼ��');
%imshow(mark_image);title('��Ǻ��ͼ��');
 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','r');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
    
end

copy_mark_image = mark_image;
image_part1 = (copy_mark_image == 1);



%figure,
subplot(2,2,3);imshow(image_part1);title('��Բ');
%imshow(image_part1);title('��');

tuxZC = regionprops(image_part1,'Perimeter');
fprintf('�ܳ����� = %f\n', tuxZC.Perimeter);
banjin =  (tuxZC.Perimeter/pi)/2;
fprintf('�뾶���� = %f\n', banjin);
bw2 = image_part1;



[B L] = bwboundaries(bw2);  %Ѱ�ұ�Ե����������,L�Ǳ�Ǿ���
figure,   %%%�����հ׵�ͼ��
hold on
for k = 1:length(B)
    boundary = B{k};  %B��һ����Ԫ���飬������B{k}
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);%% ������Ե
end%����ѭ����ʾ�������
 
 
%% 
%%%%%Ѱ��houghԲ��Բ��%%%%%%%
Rmin = 100;
Rmax = 200;
[centersBright, radiiBright] = imfindcircles(im1,[Rmin Rmax],'ObjectPolarity' ,'bright');
viscircles(centersBright,radiiBright,'EdgeColor','b');
hold on 
plot(centersBright(1),centersBright(2),'*');
fprintf('Բ������x = %f\n', centersBright(1));
fprintf('Բ������y = %f\n', centersBright(2));

hold off;
 
%% �ȷ�Բ
R=246; t=0:pi/5:2*pi; %2*pi*(0:40)/40
x=R*cos(t);
y=R*sin(t);
axis equal
n=10;a=2*pi/n;
for k=0:n-1
    hold on         %R�ǵȷֻ��ߵĳ���һ�룬��banjin�Ǵ�Բ�İ뾶
    plot([centersBright(1)-banjin*cos(pi+k*a),centersBright(1)+banjin*cos(pi+k*a)],[centersBright(2)-banjin*sin(pi+k*a),centersBright(2)+banjin*sin(pi+k*a)])
end