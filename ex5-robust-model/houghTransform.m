% Q1 Compare different edge detection algorithms

filename = 'BookImage.jpg';
im = imread(filename);
I = rgb2gray(im);
figure();
subplot(2,3,1), imshow(I), title('Gray scale');
subplot(2,3,2), imshow(edge(I, 'Sobel')), title('Sobel (default)');
subplot(2,3,3), imshow(edge(I, 'Prewitt')), title('Prewitt');
subplot(2,3,4), imshow(edge(I, 'Roberts')), title('Roberts');
subplot(2,3,5), imshow(edge(I, 'log')), title('log');
subplot(2,3,6), imshow(edge(I, 'Canny')), title('Canny');

% Q2 Compute Hough space

BW = edge(I);
[H,T,R] = hough(BW);
% T = theta, angle of normal vector
% R = rho, length of normal vector
% H = intensity, size: N(rho)*N(theta)

% Q3 Display Hough space

figure();
subplot(3,2,1);
imshow(im);
title(filename);
subplot(3,2,3);
imshow(imadjust(mat2gray(H)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough space');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% Q4 Apply transformation to Hough space

H2 = H / max(H(:));
H2 = H2.^.5;
subplot(3,2,5);
imshow(imadjust(mat2gray(H2)),'XData',T,'YData',R,...
      'InitialMagnification','fit');
title('Hough space (normalized & elem-wise squared rooted)');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal, hold on;

% Q5-6 Extract peaks from Hough space

P = houghpeaks(H,6);
subplot(3,2,3);
plot(T(P(:,2)),R(P(:,1)),'s','color','red', 'LineWidth', 2);

P2 = houghpeaks(H2,6);
subplot(3,2,5);
plot(T(P2(:,2)),R(P2(:,1)),'s','color','red', 'LineWidth', 2);

% Q7 Annotate extracted lines on original image

subplot(3,2,4), imshow(im), title('Line detection');
axis on, axis normal, hold on;
for i = 2:length(P)
  DrawImageLine(cos(P(i,2)), sin(P(i,2)), [0.0; 0.0; P(i,1)])
end

% Q8 Compare edge detection algos' effect on Hough trans
