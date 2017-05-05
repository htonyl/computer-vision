function correlationMatch(im1, im2, p, N)
global psize
psize = p;

corners1 = detectHarrisFeatures(im1);
subplot(1,2,1), imshow(im1), title('House 1'), hold on;
plot(corners1.selectStrongest(N));

corners2 = detectHarrisFeatures(im2);
subplot(1,2,2), imshow(im2), title('House 2'), hold on;
plot(corners2.selectStrongest(N));

% correct match; 9 2
% Q4
c1 = zeros(N,2);
c2 = zeros(N,2);
cg1 = corners1.selectStrongest(N);
cg2 = corners2.selectStrongest(N);
for i = 1:N
  c1(i,:) = cg1(i).Location;
  c2(i,:) = cg2(i).Location;
end

% Q5 For each feature in im1, find best match in im2
for i = 1:N
  c = covCorners(im1, im2, c1(i,:), c2);
  drawComparison(im1, im2, c1(i,:), c2(c,:), 'ONE to TWO');
end

% Q6 For each feature in im2, find best match in im1
for i = 1:N
  c = covCorners(im2, im1, c2(i,:), c1);
  drawComparison(im1, im2, c1(c,:), c2(i,:), 'TWO to ONE');
end

% Q7 Find best match for each other
for i = 1:N
  x = covCorners(im1, im2, c1(i,:), c2);
  y = covCorners(im2, im1, c2(x,:), c1);
  if y == i
    drawComparison(im1, im2, c1(i,:), c2(x,:), 'BEST match');
  end
end
end

% Q1-2 Extracts patch centered at P and span 2n+1
function p = getPatch(im, P, n)
  for i = 1:n
    im = [zeros(1, size(im, 2)); im; zeros(1, size(im, 2))];
  end
  for i = 1:n
    im = [zeros(1, size(im, 1))', im, zeros(1, size(im, 1))'];
  end
  P = int64(P + [n n]);
  p = im((P(2)-n):(P(2)+n), (P(1)-n):(P(1)+n));
end

% Q3 Calculates cross-correlation of patch p1 and p2
function c = correlation(p1, p2)
  m = cov(double(p1), double(p2));
  c = m(1,2) / sqrt(m(1, 1)*m(2, 2));
end

% Q4 Given a corner in im1, rank all corners in im2
function m = covCorners(im1, im2, c, corners)
  global psize
  m = zeros(1, size(corners, 1));
  p1 = getPatch(im1, c, psize);
  for i = 1:size(corners, 1)
    p2 = getPatch(im2, corners(i,:), psize);
    m(i) = correlation(p1, p2);
  end
  [M, argM] = max(m);
  m = argM;
end

% Returns coordinates of the best corner
function [c1, c2] = bestCorner(m)
 [M, argM] = max(m(:));
 c1 = floor(argM / size(m, 1)) + 1;
 c2 = mod(argM, size(m, 1));
end

function drawComparison(im1, im2, p1, p2, t)
  global psize
  mid = psize + 1;
  figure();
  subplot(2,2,1), imshow(im1), hold on;
  title(strcat(t, ' Img 1')), plot(p1(1), p1(2), 'ro', 'LineWidth', 2);
  subplot(2,2,2), imshow(im2), hold on;
  title(strcat(t, ' Img 2')), plot(p2(1), p2(2), 'ro', 'LineWidth', 2);
  subplot(2,2,3), imshow(getPatch(im1, p1, psize)), hold on;
  title(strcat(t, ' Patch 1')), plot(mid, mid, 'm+', 'LineWidth', 2);
  subplot(2,2,4), imshow(getPatch(im2, p2, psize)), hold on;
  title(strcat(t, ' Patch 2')), plot(mid, mid, 'm+', 'LineWidth', 2);
end
