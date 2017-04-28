function Q = Est3D(q1, P1, q2, P2)
  % q1, q2 = 2D projection of 3D points
  % P1, P2 = camera matrices
  B = [
    P1(3,:) * q1(1) - P1(1,:);
    P1(3,:) * q1(2) - P1(2,:);
    P2(3,:) * q2(1) - P2(1,:);
    P2(3,:) * q2(2) - P2(2,:);
  ];
  [u,s,v] = svd(B);
  Q = v(:,end);
  Q = Q / Q(4);
end
