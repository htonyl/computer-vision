% Estimate Fundamental Matrix
Qtest = load('Qtest.mat');
Fest = Fest_8point(Qtest.q1, Qtest.q2);
zero_vec = diag(Qtest.q1'*Fest*Qtest.q2);

% SIFT Feature Extraction
im1 = imread('House1.bmp');
im2 = imread('House2.bmp');

[fa,da] = vl_sift(single(im1));
[fb,db] = vl_sift(single(im2));
[matches,scores] = vl_ubcmatch(da,db);
nMatch = size(matches,2);
lmatch = fa(1:2,matches(1,:));
rmatch = fb(1:2,matches(2,:));
showMatchedFeatures(im1,im2,lmatch', rmatch', 'montage');
title('Correspondence w/o refinement');

% Robust F Estimation
N = 100; F = []; Score = [];
for i=1:N
  sample = matches(:,randperm(nMatch,8));
  lsample = fa(1:2,sample(1,:));
  rsample = fb(1:2,sample(2,:));
  F = Fest_8point(lsample, rsample);
  in = 0;
  for cM=1:nMatch
    if FSampDist(F,lmatch(:,cM),rmatch(:,cM))<3.84*3^2
      in = in + 1;
    end
  end
  Fs{i} = F;
  Score = [Score in];
end

[M, argm] = max(Score);
Fest = Fs{argm};
Ftrue = getFtrue();
a = Ftrue(:); b = Fest(:);
a'*b/(norm(a)*norm(b))

%% Refine F Estimate
inlmatch = [];
inrmatch = [];
for cM=1:nMatch
  if FSampDist(F,lmatch(:,cM),rmatch(:,cM))<3.84*3^2
    inlmatch = [inlmatch lmatch(:,cM)];
    inrmatch = [inrmatch rmatch(:,cM)];
  end
end
figure;
showMatchedFeatures(im1,im2,inlmatch', inrmatch', 'montage');
title('Correspondence estimated w/ robust F estimate');

function F = getFtrue()
  % Code from ex2
  D = load('TwoImageData','-mat');
  A = D.A; R1 = D.R1; R2 = D.R2;
  t1 = D.T1; t2 = D.T2;
  R2cap = R2 * transpose(R1);
  t2cap = t2 - R2 * transpose(R1) * t1;
  F = transpose(inv(A))*CrossOp(t2cap)*R2cap*inv(A);
end
