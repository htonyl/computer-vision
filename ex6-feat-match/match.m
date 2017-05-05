im1 = imread('House1.bmp');
im2 = imread('House2.bmp');
% im2 = transform(im2, 20, 20);
% correlationMatch(im1, im2, 10, 10);
figure;
H_deform = [1 0 0; .7 1 0; 0 0 1];
subplot(1,3,1), sift(im2), title('Original w/ sift');
subplot(1,3,2), sift(transform(im2, 5)), title('Rotate 5degs w/ sift');
subplot(1,3,3), sift(transform2(im2, H_deform)), title('Deform w/ sift');

function im_result = transform(im, a, s)
  a = a*pi/180;
  s = sin(a);
  c = cos(a);
  H = [c s 0; -s c 0; 0 0 1];
  % try s = .7
  % H = [1 0 0; .7 1 0; 0 0 1];
  % Note That H has to be transposed here if column vectors are used for points
  Tr = maketform('projective', H');
  im_result = imtransform(im,Tr);
end

function im_result = transform2(im, H)
  Tr = maketform('projective', H');
  im_result = imtransform(im,Tr);
end

function sift(im)
  imshow(im);
  [f,d] = vl_sift(single(im));
  perm = randperm(size(f,2)) ;
  sel = perm(1:50) ;
  h1 = vl_plotframe(f(:,sel)) ;
  h2 = vl_plotframe(f(:,sel)) ;
  set(h1,'color','k','linewidth',3) ;
  set(h2,'color','y','linewidth',2) ;
end
