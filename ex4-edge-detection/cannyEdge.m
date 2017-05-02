im1 = imread('TestIm1.bmp');
im2 = imread('TestIm2.bmp');
im3 = imread('House1.bmp');
im4 = imread('House2.bmp');

% Visualize canny edge on all imgs
figure, suptitle('Canny Edge Detector');
BW = edge(im1, 'canny');
subplot(4,2,1), imagesc(im1);
subplot(4,2,2), imagesc(BW);
BW = edge(im2, 'canny');
subplot(4,2,3), imagesc(im2);
subplot(4,2,4), imagesc(BW);
BW = edge(im3, 'canny');
subplot(4,2,5), imagesc(im3);
subplot(4,2,6), imagesc(BW);
BW = edge(im4, 'canny');
subplot(4,2,7), imagesc(im4);
subplot(4,2,8), imagesc(BW);

% The method uses two thresholds, to detect strong
%     and weak edges, and includes the weak edges
%     in the output only if they are connected to
%     strong edges. This method is therefore less
%     likely than the others to be "fooled" by
%     noise, and more likely to detect true weak edges.
% Change threshold parameters
L = [.1 .3 .49];
H = [.5 .7 .9];
figure, suptitle('Canny Edge Detector w/ different thresholds');
BW = edge(im2, 'canny', [L(1) H(1)]);
subplot(3,3,1), imagesc(BW), title('I_{11}');
BW = edge(im2, 'canny', [L(1) H(2)]);
subplot(3,3,2), imagesc(BW), title('I_{12}');
BW = edge(im2, 'canny', [L(1) H(3)]);
subplot(3,3,3), imagesc(BW), title('I_{13}');
BW = edge(im2, 'canny', [L(2) H(1)]);
subplot(3,3,4), imagesc(BW), title('I_{21}');
BW = edge(im2, 'canny', [L(2) H(2)]);
subplot(3,3,5), imagesc(BW), title('I_{22}');
BW = edge(im2, 'canny', [L(2) H(3)]);
subplot(3,3,6), imagesc(BW), title('I_{23}');
BW = edge(im2, 'canny', [L(3) H(1)]);
subplot(3,3,7), imagesc(BW), title('I_{31}');
BW = edge(im2, 'canny', [L(3) H(2)]);
subplot(3,3,8), imagesc(BW), title('I_{32}');
BW = edge(im2, 'canny', [L(3) H(3)]);
subplot(3,3,9), imagesc(BW), title('I_{33}');
