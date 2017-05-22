%% Q3 Object Detection Using HOG
% ex13-14
clear all, close all;
im = imread('data/dturoad1.jpg');
imobj = imread('data/sign1_64.jpg');
im = imresize(im, [240 320]);

figure;
[orig_vec, orig_vis] = extractHOGFeatures(im);
subplot(2,2,1), imagesc(im), title('Original w/ HOG');
hold on; plot(orig_vis);
subplot(2,2,2), plot(orig_vis), title('Original HOG');

[obj_vec, obj_vis] = extractHOGFeatures(imobj);
subplot(2,2,3), imagesc(imobj), title('Object w/ HOG');
axis equal; hold on; plot(obj_vis);
subplot(2,2,4), plot(obj_vis), title('Object HOG');

% ex15
wsize = [size(imobj,1) size(imobj,2)];
stepx = 17;
stepy = 17;

figure;
subplot(2,2,1), imagesc(im), title('Original');
subplot(2,2,3), imagesc(imobj), title('Object w/ HOG');
axis equal; hold on; plot(obj_vis);
ylim = size(im,1) - wsize(1) + 1;
xlim = size(im,2) - wsize(2) + 1;

S = [];
for row = 1:stepy:ylim
  for col = 1:stepx:xlim
    % Display in RGB
    subplot(2,2,1);
    rectangle('Position', [col row wsize(1) wsize(2)]);
    window = im(row:row+wsize(2), col:col+wsize(1), :);
    [win_vec, win_vis] = extractHOGFeatures(window);
    subplot(2,2,2), imagesc(window), title('Window w/ HOG');
    hold on; plot(win_vis);
    subplot(2,2,4), plot(win_vis), title('Window HOG');
    % Calculate distance in HOG
    d = pdist2(obj_vec, win_vec);
    S = [S; col row d];
    fprintf('[%d:%d][%d:%d]\tDist = %f\n',...
      row, row+wsize(2), col, col+wsize(1), d);
    pause;
  end
end

% Draw Rectangles
[s,idx] = sort(S(:,3));
figure; imagesc(im); hold on;
for i = fliplr(1:10)
  x = S(idx(i),:); % [col row d]
  rectangle('Position',[x(1) x(2) wsize(1) wsize(2)],...
    'EdgeColor',[1/i, .3+.5*1/i, .3],'LineWidth',2);
end
title(sprintf('Detected window (yellow) using HOG features / Variance = %.5f\n',...
  var(S(:,3))));
