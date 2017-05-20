function H = Hest(P1, P2)
  % B = [
  %   0 P(1,2) -P(1,2)*P(2,1);
  %   -P(1,2) 0 P(1,2)*P(1,1);
  %   P(1,2)*P(2,1) -P(1,2)*P(1,1) 0;
  %   0 P(2,2) -P(2,2)*P(2,1);
  %   P(2,2) 0 P(2,2)*P(1,1);
  %   P(2,2)*P(2,1) -P(2,2)*P(1,1) 0;
  %   0 1 -P(2,1);
  %   -1 0 P(1,1);
  %   P(2,1) -P(1,1) 0;
  % ]';
  B = [];
  for i = 1:size(P1,2)
    B = [B; constraint(P1(:,i), P2(:,i))];
  end
  [u,s,v] = svd(B);
  H = reshape(v(:,end),3,3)';
end

function v = constraint(p, q)
  u=p(1); v=p(2); x=q(1); y=q(2);
  v = [
    0 0 0 -u -v -1 y*u y*v y;
    u v 1 0  0  0 -x*u -x*v -x;
  ];
end
