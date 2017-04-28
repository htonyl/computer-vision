im1 = imread('House1.bmp');
im2 = imread('House2.bmp');
im2 = transform(im2, 20);
correlationMatch(im1, im2, 10, 10);

function im_result = transform(im, a)
  a=a*pi/180;
  s=sin(a);
  c=cos(a);
  H=[c s 0; -s c 0; 0 0 1];
  % try s = .7
  % H=[1 0 0; 0 .7 0; 0 0 1];
  % Note That H has to be transposed here if column vectors are used for points
  Tr=maketform('projective', H');
  im_result=imtransform(im,Tr);
end
