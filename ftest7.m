clc;clear;close all;
%����ͼƬ
im=imread('/Users/Martin/Downloads/lsm111.jpeg'); 

figure,
subplot(2,2,1);imshow(im);title('Դͼ��');
%��ȡһ��������ѡȡROI����Ȥ����ͼ������˿ñͼ�ξ���ռ�뻭��  
im0 = imcrop(im,[80 66 522 522]);

subplot(2,2,2);imshow(im0,'DisplayRange',[]);title('��ͼѡȡROI����Ȥ����');

im0 = rgb2gray(im0); %ת�Ҷ�
 
%��˹�˲�
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

[mark_image,num] = bwlabel(Ezhimg,4);
%�����ο�סͼ��
status=regionprops(mark_image,'BoundingBox');
%�ҵ�ͼ�ε�����
centroid = regionprops(mark_image,'Centroid');
%����˿ñ����ͼ�α��
subplot(2,2,2);imshow(mark_image);title('����˿ñ����ͼ�α��'); 
for i=1:num
    rectangle('position',status(i).BoundingBox,'edgecolor','g');
    
    text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'y') 
    
end


copy_mark_image = mark_image;
%����˿ñ��ͼ�η���
image_part1 = (copy_mark_image == 2);
subplot(2,2,3);imshow(image_part1);title('СԲ');

image_part1 = (copy_mark_image == 1);

%figure,
subplot(2,2,4);imshow(image_part1);title('��Բ');

%�����ܳ������Բ�İ뾶
tuxZC = regionprops(image_part1,'Perimeter');
fprintf('�ܳ����� = %f\n', tuxZC.Perimeter);
banjin =  (tuxZC.Perimeter/pi)/2;
fprintf('�뾶���� = %f\n', banjin);
bw2 = image_part1;


%��Բ�ȷ�
[B L] = bwboundaries(bw2);  %Ѱ�ұ�Ե
figure,   
hold on
for k = 1:length(B)
    boundary = B{k};  %B��һ����Ԫ���飬������B{k}
    plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2);%% ������Ե
end%����ѭ����ʾ�������
 
 
%ȷ��Բ��Բ������ 
Rmin = 100;
Rmax = 200;
[centersBright, radiiBright] = imfindcircles(im1,[Rmin Rmax],'ObjectPolarity' ,'bright');
viscircles(centersBright,radiiBright,'EdgeColor','b');
hold on 
plot(centersBright(1),centersBright(2),'*');
fprintf('Բ������x = %f\n', centersBright(1));
fprintf('Բ������y = %f\n', centersBright(2));
hold off;
 
% �ȷ�Բ
R=246; t=2*pi*(0:40)/40; 
x=R*cos(t);
y=R*sin(t);
axis equal
n=20;a=2*pi/n;
for k=0:n-1
    hold on   %R�ǵȷֻ��ߵĳ���һ�룬��banjin�Ǵ�Բ�İ뾶
    plot([centersBright(1)-banjin*cos(pi+k*a),centersBright(1)+banjin*cos(pi+k*a)],[centersBright(2)-banjin*sin(pi+k*a),centersBright(2)+banjin*sin(pi+k*a)])
end