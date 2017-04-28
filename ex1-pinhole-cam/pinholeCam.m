Q = Box3D;
plot3(Q(1,:),Q(2,:),Q(3,:),'.');
title('Original block');
axis equal;
axis([-1 1 -1 1 -1 5]);
xlabel('x'); ylabel('y'); zlabel('z');

% Q10
A = [1 0 0; 0 1 0; 0 0 1];
R = [1 0 0; 0 1 0; 0 0 1];
t = [0; 0; 0];
P = A * [R t]
project(P, 'Projection from (0, 0, 0)');

% Q11
R = [.9397 .3420 0;
    -.3420 .9397 0;
      0     0    1];
P = A * [R t]
project(P, 'Rotate along z-axis by 20 degrees');

% Q12
t = [0; 0; 2];
P = A * [R t]
project(P, 'Translate along z-axis by 2 units');

% Q13
A = constructInner(1000, 200, 200);
P = A * [R t]
project(P, 'Large focus => zoom in, dxdy translates the orientation');
axis equal; axis([0 640 0 480]);

% Q14
A = constructInner(1000, 300, 200);
P = A * [R t]
project(P, 'Inner(f, dx, dy) = (1000, 300, 200)');
axis equal; axis([0 640 0 480]);

% Q15
A = constructInner(1200, 300, 200);
P = A * [R t]
project(P, 'Inner(f, dx, dy) = (1200, 300, 200)');
axis equal; axis([0 640 0 480]);

% Q16
A = constructInner(2000, 300, 200);
t = [0; 0; 3];
P = A * [R t]
project(P, 'Inner(f, dx, dy) = (2000, 300, 200), translate along z by 3');
axis equal; axis([0 640 0 480]);

function x = project(P, cap)
  figure;
  Q = Box3D;
  q = P*[Q;ones(1,size(Q,2))];
  q(1,:) = q(1,:)./q(3,:);
  q(2,:) = q(2,:)./q(3,:);
  q(3,:) = q(3,:)./q(3,:);
  plot(q(1,:),q(2,:),'.');
  title(cap);
  axis([-0.3 0.3 -0.3 0.3]);
end

function A = constructInner(f, dx, dy)
A = [f 0 dx; 0 f dy; 0 0 1];
end
