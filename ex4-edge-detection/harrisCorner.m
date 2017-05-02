im = imread('TestIm1.bmp');
sigma = 3;

% Setup Gaussian kernel
t = sigma * sigma;
x = -3*ceil(sigma):3*ceil(sigma);
g = exp(-x.*x./ (2 * t)) / sqrt(2*pi*t);
gx = (-x/t).*g;

% Apply filter to image
Ix = filter2(gx, im, 'same');
Ix = filter2(g', Ix, 'same');
Iy = filter2(g, im, 'same');
Iy = filter2(gx', Iy, 'same');

Ig = filter2(g, im, 'same');
Ig = filter2(g', Ig, 'same');

figure;
subplot(2,2,1), imagesc(im), title('Original');
subplot(2,2,2), imagesc(Ix), title('Gaussian kernel x');
subplot(2,2,3), imagesc(Iy), title('Gaussian kernel y');
subplot(2,2,4), imagesc(Ig), title('Gaussian blur');
suptitle('Gaussian Filters');

% C(x, y)
xx = filter2(g, Ix.*Ix);
xx = filter2(g', xx);
yy = filter2(g, Iy.*Iy);
yy = filter2(g', yy);
xy = filter2(g, Ix.*Iy);
xy = filter2(g', xy);
C = [xx xy; yy xy];

figure;
subplot(2,2,1), imagesc(xx), title('g * Ixx');
subplot(2,2,2), imagesc(yy), title('g * Iyy');
subplot(2,2,3), imagesc(xy), title('g * Ixy');

% Harris score r(x, y)
k = 0.2;
r = xx.*yy - xy.*xy - k.*(xx+yy).*(xx+yy);
r = -r;
max(r(:))
subplot(2,2,4), imagesc(r), title('Harris score');

% Different threshold
figure;
for t = 1:10
  threshold = r > t/10.0*max(r(:));
  threshold = r.*threshold;
  subplot(5,2,t), imagesc(threshold);
  title(t/10.0);
end
suptitle('Harris Corner w/ different thresholds');

th = .6;
threshold = r > th*max(r(:));
threshold = r.*threshold;
name = sprintf('Non-minimum suppression at threshold = %.2f', th);
figure, imagesc(imfuse(im,threshold, 'diff')), title(name);

im1 = imread('House1.bmp');
im2 = imread('House2.bmp');
h1 = harrisC(im1, .3, 'Harris Corner of House1');
h2 = harrisC(im2, .3, 'Harris Corner of House2');
function Q = harrisC(im, th, name)
  sigma = 3;
  t = sigma * sigma;
  x = -3*ceil(sigma):3*ceil(sigma);
  g = exp(-x.*x./ (2 * t)) / sqrt(2*pi*t);
  gx = (-x/t).*g;

  Ix = filter2(gx, im, 'same');
  Ix = filter2(g', Ix, 'same');
  Iy = filter2(g, im, 'same');
  Iy = filter2(gx', Iy, 'same');

  xx = filter2(g, Ix.*Ix);
  xx = filter2(g', xx);
  yy = filter2(g, Iy.*Iy);
  yy = filter2(g', yy);
  xy = filter2(g, Ix.*Iy);
  xy = filter2(g', xy);
  C = [xx xy; yy xy];

  k = 0.2;
  r = xx.*yy - xy.*xy - k.*(xx+yy).*(xx+yy);
  r = -r;

  Q = r > th*max(r(:));
  Q = r.*Q;
  figure, imagesc(imfuse(im,Q, 'blend'));
  title(sprintf('%s (Threshold = %.2f)', name, th));
end
