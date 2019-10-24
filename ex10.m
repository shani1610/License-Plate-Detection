close all; clear; clc;

plate1 = imread('plate01.jpg'); imshow(plate1);
figure(1); title('original'); imshow(plate1); impixelinfo;

%%converting to HSV
hsv1=rgb2hsv(plate1);

%figure(1); title('HSV'); imshow(hsv1); impixelinfo;

%HSV FILTERS
bw1=(hsv1(:,:,1)>0.10)&(hsv1(:,:,1)<0.19)&(hsv1(:,:,2)>0.38)&(hsv1(:,:,3)>0.61);
%figure(3);imshow(bw1);title('filter by HSV');

%regionprops FILTERS
mask = bwpropfilt(bw1,'Eccentricity',[0.89 0.99]); %0.8 1
%figure(4);imshow(mask);title('filter by Eccentricity');

mask = bwpropfilt(mask,'Extent',[0.45 0.93]); %%0.3 0.93
%figure(6);imshow(mask);title('filter by Extent');

mask = bwpropfilt(mask,'Orientation',[-20 20]); %%-5 5
%figure(7);imshow(mask);title('filter by Orientation');

%s=regionprops(mask,'all')

SE=strel('disk', 4 );
mask=imdilate(mask,SE);
mask=imdilate(mask,SE);
mask=imdilate(mask,SE);

mask=imfill(mask,'holes');
%figure(10);imshow(mask,[]);title('after fiiling holes');

mask = bwpropfilt(mask,'Solidity',[0.6 1]); %%0.6 0.95
%figure(5);imshow(mask);title('filter by Solidity');

mask = bwpropfilt(mask,'Perimeter',[50 1100]);
%figure(8);imshow(mask);title('filter by Perimeter');

mask = bwpropfilt(mask,'Area',1); %%picking the biggest plate 

%%s=regionprops(mask,'all');

%final result
mask=uint8(repmat(mask,[1 1 3]));
result=plate1.*mask; 
figure(11); imshow(result,[]);title('result');