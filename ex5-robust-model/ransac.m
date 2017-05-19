% Q5-6
N = 10; thres = .1;
% x = RanLine(30, 40);
% close all;
for i = 1:9
  [l,m] = ransacFn(x,N,thres);
  subplot(3,3,i), scatter(x(1,:),x(2,:));
  DrawLine([l(1) -1 l(2)],'r');
  title(sprintf('Consensus: %d/%d',m,length(x)));
end
suptitle(sprintf('Ransac Line Fitting (N_{iteration} = %d, Threshold = %.2f)', N,thres));
% Q1
function l = estimateLine(p1, p2)
  v = [p1(1)-p2(1); p1(2)-p2(2)];
  b = v(2)/v(1);
  c = p1(2) - b * p1(1);
  l = [b c];
end

% Q2
function in = inlier(p, l, threshold)
  b = l(1); c = l(2);
  d = abs(b*p(1)-p(2)+c)/sqrt(b*b+1);
  in = d <= threshold;
end

% Q3
function v = consensus(P, l, threshold)
  v = 0;
  for i=1:size(P, 2)
    if inlier(P(:,i),l,threshold)
      v = v + 1;
    end
  end
end

% Q4
function p = rand2D(P, n)
  p = P(:,randperm(length(P),n));
end

% Q5
function [l,m] = ransacFn(x,N,thres)
  Line = [];
  Score = [];
  for i=1:N
    sample = rand2D(x,2);
    l = estimateLine(sample(:,1), sample(:,2));
    v = consensus(x,l,thres);
    Line{i} = l;
    Score = [Score v];
  end
  [m,arg_m] = max(Score);
  l = Line{arg_m};
end
