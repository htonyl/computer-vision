Q = PointsInPlane(), title('Original');

A = [1000 0 300; 0 1000 200; 0 0 1];
R = Rot(.2, -.3, .1);
t = [.8866; .5694; .1911];

% Q14: Plot P given A R t
P = A*[R t]*[Q; ones(1, size(Q, 2))];
figure, hold on, title('Project by cam1'); 
plot(P(1,:), P(2,:), '.');

% Q15: Compute H st. P = HQ
H = P(1:3, 1:3) * inv(Q(1:3, 1:3))

% Q16: Compute H st. Q = HP
Hinv = inv(H)

% Transform back to Q
P_transform = Hinv*P
figure, hold on, title('Homography');
plot(Q(1,:), Q(2,:), '+')
plot(P_transform(1,:), P_transform(2,:), 'o')
