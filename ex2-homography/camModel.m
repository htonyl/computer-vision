% Q1
A = constructInner(1000, 300, 200);
R = Rot(.2, -.3, .1);
t = [.8866; .5694; .1911];
P = A * [R t]
project(P, 'Original');

% Q2 (Barrel distortion)
Ap = [1000 0 0; 0 1000 0; 0 0 1];
Aq = [1 0 300; 0 1 200; 0 0 1];
Q = Box3D;
pd = Ap * [R t] * [Q;ones(1,size(Q,2))];
pd(1,:) = pd(1,:)./pd(3,:);
pd(2,:) = pd(2,:)./pd(3,:);
pd(3,:) = pd(3,:)./pd(3,:);
for i = 1:size(pd,2)
  r = sqrt(pd(1,i)*pd(1,i)+pd(2,i)*pd(2,i));
  dr = -1e-6 * power(r, 2) + -1e-12 * power(r, 4);
  pd(1,i) = pd(1,i) * (1+dr);
  pd(2,i) = pd(2,i) * (2+dr);
end
q = Aq * pd;
figure;
title('k_3 = -1e-6, k_5 = -1e-12'); axis equal;
plot(q(1,:),q(2,:),'.');

% Q3 (Barrel distortion)
pd = Ap * [R t] * [Q;ones(1,size(Q,2))];
pd(1,:) = pd(1,:)./pd(3,:);
pd(2,:) = pd(2,:)./pd(3,:);
pd(3,:) = pd(3,:)./pd(3,:);
for i = 1:size(pd,2)
  r = sqrt(pd(1,i)*pd(1,i)+pd(2,i)*pd(2,i));
  dr = -1e-6 * power(r, 2);
  pd(1,i) = pd(1,i) * (1+dr);
  pd(2,i) = pd(2,i) * (2+dr);
end
q = Aq * pd;
figure;
title('k_3 = -1e-6'); axis equal;
plot(q(1,:),q(2,:),'.');

% Extra (Pincushion)
pd = Ap * [R t] * [Q;ones(1,size(Q,2))];
pd(1,:) = pd(1,:)./pd(3,:);
pd(2,:) = pd(2,:)./pd(3,:);
pd(3,:) = pd(3,:)./pd(3,:);
for i = 1:size(pd,2)
  r = sqrt(pd(1,i)*pd(1,i)+pd(2,i)*pd(2,i));
  dr = 1e-6 * power(r, 2) + 1e-10 * power(r, 4);
  pd(1,i) = pd(1,i) * (1+dr);
  pd(2,i) = pd(2,i) * (2+dr);
end
q = Aq * pd;
figure;
title('k_3 = 1e-6'); axis equal;
plot(q(1,:),q(2,:),'.');

function x = project(P, cap)
  figure;
  Q = Box3D;
  q = P*[Q;ones(1,size(Q,2))];
  q(1,:) = q(1,:)./q(3,:);
  q(2,:) = q(2,:)./q(3,:);
  q(3,:) = q(3,:)./q(3,:);
  plot(q(1,:),q(2,:),'.');
  title(cap); axis equal;
  axis([0 640 0 480]);
end

function A = constructInner(f, dx, dy)
A = [f 0 dx; 0 f dy; 0 0 1];
end
