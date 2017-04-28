% Q1.1
A = diag(ones(3, 1));
R = diag(ones(3, 1));
t1 = [0 0 0]';
t2 = [-5 0 2]';
t3 = [.1 0 .1]';
cam1 = A * [R t1];
cam2 = A * [R t2];
cam3 = A * [R t3];

% Q1.2
Q1 = [2 4 10 1]';

q1 = cam1 * Q1; q1 = q1 / q1(3)
q2 = cam2 * Q1; q2 = q2 / q2(3)
q3 = cam3 * Q1; q3 = q3 / q3(3)

% Q1.3
% q3 is quite close to q1 as it translates slightly
% q2 has a negative x value as it looks from the left

% Q2.1
q21 = [-.1667 .3333 1]';
q22 = [-.5 .2857 1]';
Q2 = Est3D(q21,cam1,q22,cam2);

% Q2.2
q23 = cam3 * Q2; q23 = q23 / q23(3)

% Q3.1
N = 3;
for i = 1:N
  q22cell{i} = q22 + [.1 .1 0]' * i;
  q23cell{i} = q23 + [.1 .1 0]' * i;
end

% Q3.2 - 3.3
for i = 1:N
  Q2est1{i} = Est3D(q21,cam1,q22cell{i},cam2);
  Q2est2{i} = Est3D(q21,cam1,q23cell{i},cam3);

  Q2est1{i}
  Q2est2{i}
end

% Q4
