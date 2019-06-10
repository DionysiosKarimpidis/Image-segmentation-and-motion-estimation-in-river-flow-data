%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Προγραμματιστική εργαστηριακή άσκηση   %
% KARIMPIDIS DIONISIS    2011030009      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
clc;

%image reading----------------------------------------------------------
original_im = imread('MVI_4117_frame_0677.bmp');
double_im = im2double(original_im);
imshow(original_im), title('original image');
text(size(original_im,2),size(original_im,1)+15,'specific frame given','FontSize',8,'HorizontalAlignment','right');

% __________________________________________________________________________
% --------------------------1st method--------------------------------------
% __________________________________________________________________________

%convert from rgb to lab model------------------------------------------
cform = makecform('srgb2lab');
lab_icon = applycform(double_im,cform);
%-----------------------------------------------------------------------

%classify using k-means clustering--------------------------------------
ab = double(lab_icon(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 5;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
%-----------------------------------------------------------------------
pixel_labels = reshape(cluster_idx,nrows,ncols);
figure();
imshow(pixel_labels,[]), title('image labeled by cluster index');
%-----------------------------------------------------------------------

segmented_images = cell(1,5);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = double_im;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

%provoli twn apotelesmatwn
for i = 1:nColors
    figure();
    imshow(segmented_images{i}), title('objects in cluster i');
end

% ----sto command window
% x = (segmented_images{} > 0.85);  %segmented_images{} dialegoume to
%                                     cluster pou periexei tin pliroforia 
%                                     pou 8elouyme
% figure();
% imshow(im2double(x))

%__________________________________________________________________________
%----------------------------2nd method------------------------------------
%__________________________________________________________________________


%org to hsv model----------------------------------------------
HSV = rgb2hsv(original_im);
h_Image = HSV(:, :, 1);  % Extract the h image.
s_Image = HSV(:, :, 2);  % Extract the s image.
v_Image = HSV(:, :, 3);  % Extract the v image.

figure();
imshow(h_Image), title('h channel');
figure();
imshow(s_Image), title('s channel');
figure();
imshow(v_Image), title('v channel');
figure();
imhist(v_Image), title('histogramm of v channel');
%----------------------------------------------

[x,y,w] = find(v_Image<0.85);   %threshold
num = size(x,1);
for i=1:num
       original_im(x(i),y(i),:)=0;
end
   
figure();
imshow(original_im), title('v channel with threshold');

se1 = strel('diamond',1);
morph_im = imopen(original_im, se1);

figure();
imshow(morph_im), title('morphologically segmented image');
