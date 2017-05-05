%% Q2 HSV Histogram Matching
% ex4
clear all, close all;
im = imread('data/dturoad1.jpg');
imobj = imread('data/sign1_64.jpg');
im = imresize(im, [240 320]);

figure;
subplot(1,2,1), imshow(im);
subplot(1,2,2), imshow(imobj);

% ex5
figure;
subplot(2,2,1), histogram(im,256), title('Orig (RGB)');
subplot(2,2,2), histogram(rgb2hsv(im),256), title('Orig (HSV)');
subplot(2,2,3), histogram(imobj,256), title('Window (RGB)');
subplot(2,2,4), histogram(rgb2hsv(imobj),256), title('Window (HSV)');

% ex6
im_hsv = rgb2hsv(im); imobj_hsv = rgb2hsv(imobj);

hist_obj = zeros(3,256);
for ch = 1:3
  hist_ = histcounts(imobj_hsv(:,:,ch),256);
  hist_ = hist_/sum(hist_);
  hist_obj(ch,:) = hist_;
end

% ex7-10
wsize = [size(imobj,1) size(imobj,2)];
stepx = 17;
stepy = 17;

figure;
subplot(2,2,1), imagesc(im), title('Original (RGB)'); hold on;
subplot(2,2,3), imagesc(imobj_hsv), title('Object (HSV)'); hold on;
ylim = size(im,1) - wsize(1) + 1;
xlim = size(im,2) - wsize(2) + 1;

S = [];
channel = 1; % Hue gives highest variance
for row = 1:stepy:ylim
  for col = 1:stepx:xlim
    % Display in RGB
    subplot(2,2,1);
    rectangle('Position', [col row wsize(1) wsize(2)]);
    window = im(row:row+wsize(2), col:col+wsize(1), :);
    subplot(2,2,2), imagesc(window), title('Window (RGB)');
    win_hsv = im_hsv(row:row+wsize(2), col:col+wsize(1), :);
    subplot(2,2,4), imagesc(win_hsv), title('Window (HSV)');
    % Calculate distance in HSV
    hist_win = histcounts(win_hsv(:,:,channel),256);
    hist_win = hist_win/sum(hist_win);
    d = pdist2(hist_obj(channel,:), hist_win);
    S = [S; col row d];
    fprintf('[%d:%d][%d:%d]\tDist = %f\n',...
      row, row+wsize(2), col, col+wsize(1), d);
    % pause;
  end
end

% Draw Rectangles
[s,idx] = sort(S(:,3));
figure; imagesc(im); hold on;
for i = 1:10
  x = S(idx(i),:); % [col row d]
  rectangle('Position',[x(1) x(2) wsize(1) wsize(2)],...
    'EdgeColor',[1/i, .3, .3],'LineWidth',3);
end
