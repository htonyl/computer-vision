sigma = 3;
im = imread('TestIm1.bmp');

% Setup Gausian kernel
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

subplot(2,2,1), imagesc(im);
title('Original')
subplot(2,2,2), imagesc(Ix);
title('Gausian kernel x')
subplot(2,2,3), imagesc(Iy);
title('Gausian kernel y')
subplot(2,2,4), imagesc(Ig);
title('Gausian blur')

% C(x, y)
xx = filter2(g, Ix.*Ix);
xx = filter2(g', xx);
yy = filter2(g, Iy.*Iy);
yy = filter2(g', yy);
xy = filter2(g, Ix.*Iy);
xy = filter2(g', xy);
C = [xx xy; yy xy];

figure()
subplot(2,2,1), imagesc(xx);
title('g * Ixx')
subplot(2,2,2), imagesc(yy);
title('g * Iyy')
subplot(2,2,3), imagesc(xy);
title('g * Ixy')

% Harris score r(x, y)
k = 0.2;
r = xx.*yy - xy.*xy - k.*(xx+yy).*(xx+yy);
r = -r;
max(r(:))
subplot(2,2,4), imagesc(r);
title('Harris score')

% Different threshold
figure()
for t = 1:10
  threshold = r > t/10.0*max(r(:));
  threshold = r.*threshold;
  subplot(5,2, t), imagesc(threshold);
  title(t/10.0);
end

threshold = r > 6/10.0*max(r(:));
threshold = r.*threshold;
figure()
imagesc(im);
hold on
imagesc(threshold)
hold off
