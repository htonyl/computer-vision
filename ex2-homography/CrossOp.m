function C=CrossOp(t)

if size(t, 2) == 3
  t = transpose(t);
end

C=zeros(size(t, 1), size(t, 1));

C(1, 2) =-t(3, 1);
C(1, 3) = t(2, 1);
C(2, 1) = t(3, 1);
C(2, 3) =-t(1, 1);
C(3, 1) =-t(2, 1);
C(3, 2) = t(1, 1);
