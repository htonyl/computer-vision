function Q = triangulation3D(p1, p2, A1, A2)
  B = [
    A1(3,:)*p1(1)-A1(1,:);
    A1(3,:)*p1(2)-A1(2,:);
    A2(3,:)*p2(1)-A2(1,:);
    A2(3,:)*p2(2)-A2(2,:);
  ];
  [u,s,v] = svd(B);
  Q = v(:,end);
  Q = Q./Q(4);
end
