data = load('CamMotionData.mat');
im1 = data.Im1; im2 = data.Im2; im3 = data.Im3;
K = data.K; Sigma = 3.0;

subplot(1,3,1), imagesc(im1), title('Image 1');
subplot(1,3,2), imagesc(im2), title('Image 2');
subplot(1,3,3), imagesc(im3), title('Image 3');

% Extract matched features
[f1,d1] = vl_sift(im1,'FirstOctave',1);
[f2,d2] = vl_sift(im2,'FirstOctave',1);
[f3,d3] = vl_sift(im3,'FirstOctave',1);
[m12,E12,R12,t12] = MatchImagePair(f1,d1,f2,d2,K,Sigma);
[m23,E23,R23,t23] = MatchImagePair(f2,d2,f3,d3,K,Sigma);

% Correspondences between 1,2 and 2,3
[C,idx12,idx23] = intersect(m12(3:4,:)',m23(1:2,:)','rows');
figure; subplot(2,1,1);
showMatchedFeatures(im1,im2,m12(1:2,idx12)', m12(3:4,idx12)', 'montage');
title(sprintf('M12 (%d correspondences)', length(idx12)));
subplot(2,1,2);
showMatchedFeatures(im2,im3,m23(1:2,idx23)', m23(3:4,idx23)', 'montage');
title(sprintf('M23 (%d correspondences)', length(idx23)));

% Reconstruct camera matrices given F
F12 = inv(K)'*E12*inv(K);
epipole = null(F12);
Cam1 = K * [ones(3) zeros(3,1)];
Cam2 = [CrossOp(epipole)*F12 epipole];

% Point triangulation
Q = [];
for i=idx12'
  Q = [Q Triangulation3D(m12(1:2,i), m12(3:4,i),Cam1,Cam2)];
end

% Camera resectioning
Cam2 = CamResection([m12(3:4,idx12); ones(1,length(idx12))], Q);

% Recover Cam3 using Q
Cam3 = CamResection([m23(3:4,idx23); ones(1,length(idx23))], Q);

% Reprojection error
q_true = [m23(3:4,idx23); ones(1,length(idx23))];
q_reproj = wDivide(Cam3 * Q);
q_diff = sqrt(sum((q_true - q_reproj).^2,1));
disp(sprintf('Mean of reprojection error = %f (Cam3 computed from all correspondences)', mean(q_diff)));

% Recompute Cam3 using reproj_err < 30
idx_robust = [];
for i=1:length(idx23)
  Cam3_est = CamResection([m23(3:4,idx23(i)); 1], Q(:,i));
  % q_true(:,i)
  q_reproj = wDivide(Cam3_est * Q(:,i));
  % reproj_err = norm(q_true(:,i) - q_reproj_est);
  if norm(q_true(:,i) - q_reproj) < 100
    idx_robust = [idx_robust i];
  end
end

% Ransac
N = 40; thres = 30;
nIn = 0; in = [];
Cam3_ransac = []; Score = [];
for i=1:N
  sample = randperm(length(idx23), 3);
  Cam3_est = CamResection([m23(3:4,idx23(sample)); ones(1,length(sample))], Q(:,sample));
  q_reproj_est = wDivide(Cam3_est * Q);
  nIn = 0;
  for j=1:length(q_true)
    if norm(q_true(:,j) - q_reproj_est(:,j)) < thres
      nIn = nIn + 1;
    end
  end
  Cam3_ransac{i} = Cam3_est;
  Score = [Score nIn];
end

[m,argm] = max(Score);
q_reproj_est = wDivide(Cam3_ransac{argm} * Q);
q_diff = sqrt(sum((q_true - q_reproj_est).^2,1));
disp(sprintf('Mean of reprojection error = %f (Cam3 computed from inliers)', mean(q_diff)));

% Display inliers
in = [];
for j=1:length(q_true)
  if norm(q_true(:,j) - q_reproj_est(:,j)) < thres
    in = [in j];
  end
end
figure;
showMatchedFeatures(im2, im3, m23(1:2,idx23(in))', m23(3:4,idx23(in))', 'montage');
title(sprintf('Correspondences w/ small reprojection errors\n# of inliers = %d / Threshold = %.2f / Mean projection error = %f', length(in), thres, mean(q_diff)));
