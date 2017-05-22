%% Q2 HSV Histogram Matching
% ex4
clear all, close all;
im = imread('data/dturoad1.jpg');
imobj = imread('data/sign1_64.jpg');
im = imresize(im, [240 320]);

figure;
subplot(2,2,1), imshow(im), title('Original image');
subplot(2,2,2), imshow(rgb2hsv(im)), title('Original image (HSV)');
subplot(2,2,3), imshow(imobj), title('Object of interest');
subplot(2,2,4), imshow(rgb2hsv(imobj)), title('Object of interest (HSV)');

ds

% ex5
figure;
subplot(2,3,1), histogram(im(:,:,1),256), title('Orig (R)');
subplot(2,3,2), histogram(im(:,:,2),256), title('Orig (G)');
subplot(2,3,3), histogram(im(:,:,3),256), title('Orig (B)');
subplot(2,3,4), histogram(imobj(:,:,1),256), title('Object (R)');
subplot(2,3,5), histogram(imobj(:,:,2),256), title('Object (G)');
subplot(2,3,6), histogram(imobj(:,:,3),256), title('Object (B)');
suptitle('RGB channel histograms of the orig image and object of interest');
figure;
im_hsv = rgb2hsv(im); imobj_hsv = rgb2hsv(imobj);
subplot(2,3,1), histogram(im_hsv(:,:,1),256), title('Orig (H)');
subplot(2,3,2), histogram(im_hsv(:,:,2),256), title('Orig (S)');
subplot(2,3,3), histogram(im_hsv(:,:,3),256), title('Orig (V)');
subplot(2,3,4), histogram(imobj_hsv(:,:,1),256), title('Object (H)');
subplot(2,3,5), histogram(imobj_hsv(:,:,2),256), title('Object (S)');
subplot(2,3,6), histogram(imobj_hsv(:,:,3),256), title('Object (V)');
suptitle('HSV channel histograms of the orig image and object of interest');

% ex6
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
interactive = true;

Ss = [];
for channel=1:3 % Hue gives highest variance
  if interactive
    figure;
    subplot(2,2,1), imagesc(im), title('Original (RGB)'); hold on;
    subplot(2,2,3), imagesc(imobj_hsv), title('Object (HSV)'); hold on;
  end
  ylim = size(im,1) - wsize(1) + 1;
  xlim = size(im,2) - wsize(2) + 1;
  S = [];
  for row = 1:stepy:ylim
    for col = 1:stepx:xlim
      % Display in RGB
      window = im(row:row+wsize(2), col:col+wsize(1), :);
      win_hsv = im_hsv(row:row+wsize(2), col:col+wsize(1), :);
      % Calculate distance in HSV
      hist_win = histcounts(win_hsv(:,:,channel),256);
      hist_win = hist_win/sum(hist_win);
      d = pdist2(hist_obj(channel,:), hist_win);
      S = [S; col row d];
      if interactive
        subplot(2,2,1), rectangle('Position', [col row wsize(1) wsize(2)]);
        subplot(2,2,2), imagesc(window), title('Window (RGB)');
        subplot(2,2,4), imagesc(win_hsv), title('Window (HSV)');
        fprintf('[%d:%d][%d:%d]\tDist = %f\n',...
          row, row+wsize(2), col, col+wsize(1), d);
        % pause;
      end
    end
  end
  fprintf('Variance of d(win, img) = %.5f\n', var(S(:,3)));
  Ss{channel} = S;
end

figure;
for channel=1:3
  % Draw Rectangles
  S = Ss{channel};
  [s,idx] = sort(S(:,3));
  subplot(1,3,channel), imagesc(im), hold on;
  for i = fliplr(1:10)
    x = S(idx(i),:); % [col row d]
    rectangle('Position',[x(1) x(2) wsize(1) wsize(2)],...
      'EdgeColor',[1/i, .8, .3],'LineWidth',2);
  end
  title(sprintf('Detected window (yellow) using %s / Variance = %.5f\n',...
    hsv{channel}, var(S(:,3))));
end
