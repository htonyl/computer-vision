D = load('TwoImageData','-mat');
global im1 im2;
im1 = D.im1;
im2 = D.im2;
A = D.A;
R1 = D.R1;
R2 = D.R2;
t1 = D.T1;
t2 = D.T2;

% Q11
R2cap = R2 * transpose(R1);
t2cap = t2 - R2 * transpose(R1) * t1;

F = transpose(inv(A))*CrossOp(t2cap)*R2cap*inv(A)

% Q12
validateLine(F);

% Q13

function x = validateLine(F)
  global im1 im2;
  figure, imshow(im1)
  q1 = [ginput(1) 1]'
  l2 = F * q1;

  figure, imshow(im2), hold on
  DrawImageLine(q1(1), q1(2), l2);
end
