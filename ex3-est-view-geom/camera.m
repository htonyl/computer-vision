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

q1 = cam1 * Q1; q1 = q1 / q1(3);
q2 = cam2 * Q1; q2 = q2 / q2(3);
q3 = cam3 * Q1; q3 = q3 / q3(3);
disp(sprintf('Q1.1.2\tq1 = (%.4f, %.4f)\n\tq2 = (%.4f, %.4f)\n\tq3 = (%.4f, %.4f)',...
  q1(1), q1(2), q2(1), q2(2), q3(1), q3(2)));

% Q1.3
% q3 is quite close to q1 as it translates slightly
% q2 has a negative x value as it looks from the left

% Q2.1
q21 = [-.1667 .3333 1]';
q22 = [-.5 .2857 1]';
Q2 = Est3D(q21,cam1,q22,cam2);

% Q2.2
q23 = cam3 * Q2; q23 = q23 / q23(3);
disp(sprintf('Q1.2.2\tProjection of Q_2 into Cam3, q23 = (%f,%f)',...
  q23(1), q23(2)));

% Q3.1
N = 10;
for i = 1:N
  q22cell{i} = q22 + [.1 .1 0]' * (i-1);
  q23cell{i} = q23 + [.1 .1 0]' * (i-1);
end

% Q3.2 - 3.3
disp(sprintf('Q1.3.3\tEstimated 3D pos of Q_2 based on'));
disp(sprintf('\tq21\t\tq22\t\tq21,22\t\tq23\t\tq21,23'));
for i = 1:N
  est1 = Est3D(q21,cam1,q22cell{i},cam2);
  est2 = Est3D(q21,cam1,q23cell{i},cam3);
  q22_ = q22cell{i}; q23_ = q23cell{i};
  disp(sprintf('\t(%.2f,%.2f)\t(%.2f,%.2f)\t(%.2f,%.2f)\t(%.2f,%.2f)\t(%.2f,%.2f)',...
    q21(1),q21(2),q22_(1),q22_(2),est1(1),est1(2),q23_(1),q23_(2),est2(1),est2(2)));
end
