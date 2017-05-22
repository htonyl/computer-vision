function [m,E,R,t] = MatchImagePair(f1,d1,f2,d2,K,Sigma)
  % Extract correspondences
  [match, score] = vl_ubcmatch(d1,d2);
  q1 = f1(1:2,match(1,:)); q1in = [q1; ones(1, length(q1))];
  q2 = f2(1:2,match(2,:)); q2in = [q2; ones(1, length(q2))];
  % Robust estimation of Essential matrix
  [E,R,t,nIn] = Eest(K,q1in,q2in,Sigma);
  % Calculate Fundamental matrix
  F = inv(K)'*E*inv(K);
  % Record inliers match
  m = [];
  for i=1:length(match)
    if FSampDist(F,q1(:,i),q2(:,i))<3.84*3^2
      tmp = [q1; q2];
      m = [m tmp];
    end
  end
end
