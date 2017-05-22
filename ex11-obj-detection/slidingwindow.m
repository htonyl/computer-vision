clear all; close all; clc;

% -----------------------------------------------------------
% DOWNLOAD AND INITIALIZE VL_FEAT BEFORE RUNNING THIS SCRIPT.
% -----------------------------------------------------------
% stet, Technical University of Denmark, 06-05-2016

% Settings:
cellSize = 8;    %hog cell size (8)
scalesize = 0.07; %scale of input image
im_q = imread('data/dturoad2.jpg'); %Query Image
im_q = imresize(im_q,scalesize);

% Read Object Image:
im_obj = imread('data/sign2_64.jpg');


% Calculate HOG on Object- and Query-Image:
hog_obj = vl_hog(single(im_obj), cellSize);
hog_q = vl_hog(single(im_q), cellSize);


% Sliding Window: The Result is a distancescore matrix:
fun = @(block_struct) compareHog(block_struct.location,hog_q,hog_obj,cellSize);
d_scores = blockproc(zeros([size(hog_q,1) size(hog_q,2)]),[1 1],fun);


%Visualize Distance Scores:
figure;
imagesc(d_scores);
title('Match Distance Scores'); colorbar;


% Find lowest distance
[lowest, idx] = min(d_scores(:)) ;
% Find position (in HOG cells) of lowest score
[hogy, hogx] = ind2sub(size(d_scores), idx) ;
x = (hogx - 1) * cellSize + 1 ;
y = (hogy - 1) * cellSize + 1 ;


% Visualize Detection
figure;
imagesc(im_q);
hold on;
rectangle('Position',[x-0.5 y-0.5 size(im_obj,1)-0.5 size(im_obj,2)-0.5],'EdgeColor','y');
title('Detection');
