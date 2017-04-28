function est = Fest_8point(q1s, q2s)
  if size(q1s) ~= size(q2s)
    est = []; return;
  end

  B = [];
  for i = 1:size(q1s,2)
    q1 = q1s(:,i); q2 = q2s(:,i);
    b = [
          q1(1)*q2(1) q1(1)*q2(2) q1(1)
          q1(2)*q2(1) q1(2)*q2(2) q1(2)
          q2(1)       q2(2)       1
        ]; b = reshape(b, [1,9]);
    B = [B; b];
  end
  [u,s,v] = svd(B);
  est = reshape(v(:,end), [3,3]);
end
