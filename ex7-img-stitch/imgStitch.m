%% Homography Estimation
Htrue=[10 0 -1; 1 10 20; .01 0 3];

q1 = wDivide(rand(3,10));
q2 = wDivide(Htrue * q1);

figure, axis equal;
subplot(1,2,1), scatter(q1(1,:),q1(2,:));
subplot(1,2,2), scatter(q2(1,:),q2(2,:));
H = Hest(q1, q2);

%% Display SIFT features
ImL = imread('ImL.jpg');
ImR = imread('ImR.jpg');
[fa, da] = vl_sift(single(rgb2gray(ImL)));
[fb, db] = vl_sift(single(rgb2gray(ImR)));
[matches, scores] = vl_ubcmatch(da, db);
nMatch = size(matches,2);

[M, argm] = max(scores);
ida = fa(1:2,matches(1,argm-1));
idb = fb(1:2,matches(2,argm-1));

subplot(1,2,1), imshow(ImL), title('ImL w/ SIFT features');
perm = randperm(size(fa,2));
sift = vl_plotframe(fa(:,perm(1:50)));
set(sift,'color','y','linewidth',2); hold on;
scatter(ida(1), ida(2), 'g');
subplot(1,2,2), imshow(ImR), title('ImL w/ SIFT features');
perm = randperm(size(fb,2));
sift = vl_plotframe(fb(:,perm(1:50)));
set(sift,'color','y','linewidth',2); hold on;
scatter(idb(1), idb(2), 'g');

figure;
lmatch = fa(1:2,matches(1,:));
rmatch = fb(1:2,matches(2,:));
showMatchedFeatures(ImL,ImR,lmatch', rmatch', 'montage');

%% Apply Ransac to homography
N = 1; Hs = []; Score = [];
Ia = fa(1:2,matches(1,:));
Ib = fb(1:2,matches(2,:));
for n = 1:N
  r_matches = matches(:,randperm(nMatch,5));
  H = Hest(fa(1:2,r_matches(1,:)), fb(1:2,r_matches(2,:)));
  Ea = wDivide(inv(H) * [Ib; ones(1,length(Ib))]);
  Eb = wDivide(H * [Ia; ones(1,length(Ia))]);
  v = 0;
  for i = 1:nMatch
    d1 = ImL(round(Ia(2,i)), round(Ia(1,i)), :) - ImR(round(Eb(2,i)), round(Eb(1,i)), :);
    d2 = ImL(round(Ea(2,i)), round(Ea(1,i)), :) - ImR(round(Ib(2,i)), round(Ib(1,i)), :);
    if sqrt(d1) + sqrt(d2) < 3
      v = v + 1;
    end
  end
  Hs{n} = H;
  Score{n} = v;
end
