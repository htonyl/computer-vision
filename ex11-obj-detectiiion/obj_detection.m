% Q1 Sliding Window Loop
clear all, close all;
im = imread('data/dturoad1.jpg');
im = imresize(im, [240 320]);

wsize = [30 30];
stepx = 20;
stepy = 20;

figure;
subplot(1,2,1), imagesc(im); hold on;
ylim = size(im,1) - wsize(1) + 1;
xlim = size(im,2) - wsize(2) + 1;
for row = 1:stepy:ylim
  for col = 1:stepx:xlim
    subplot(1,2,1);
    rectangle('Position', [col row wsize(1) wsize(2)]);
    % fprintf('%d %d %d %d\n', col, row, size(im,2), size(im,2));
    window = im(row:row+wsize(2), col:col+wsize(1), :);
    subplot(1,2,2), imagesc(window);
    pause;
  end
end
