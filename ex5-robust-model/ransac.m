% Q5-6
[t, r] = estimateLine([3; 4], [1; 1])
dot([cos(t) sin(t)], [2 3])
% Q1

function [t, r] = estimateLine(p1, p2)
v = [p1(1)-p2(1); p1(2)-p2(2)];
t = atand(v(1)/v(2));
b = p1(2) - v(1)/v(2) * p1(2);
r = b * sin(t);
end

% Q2

function i = inlier(threshold)
end

% Q3

function v = consensus(t, r)
end

% Q4

function p = rand2D(P, n)
  r = randi([1 length(P)],1,n)
  p = P(:,r)
end
