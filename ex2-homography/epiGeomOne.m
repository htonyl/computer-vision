% Q5
A = [100 0 300; 0 1000 200; 0 0 1];
R = Rot(-.1, .1, 0);
t = [.2; 2; .1];
Q = [1; .5; 4; 1];

cam1 = A*[diag(ones(1, 3), 0), zeros(3, 1)];
cam2 = A*[R t];

q1 = cam1*Q;
q2 = cam2*Q;
q1 = q1 / q1(3, 1)
q2 = q2 / q2(3, 1)

% Q6
F = transpose(inv(A))*CrossOp(t)*inv(A)

% Q7
l2 = F*q1

% Q8
is_q2_on_l2 = transpose(q2)*l2
