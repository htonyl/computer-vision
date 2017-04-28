% Section 1
Qtest = load('Qtest.mat');
Fest = Fest_8point(Qtest.q1, Qtest.q2);
zero_vec = diag(Qtest.q1'*Fest*Qtest.q2);

% Section 2
im1 = imread('House1.bmp');
im2 = imread('House2.bmp');

[fa,da] = vl_sift(single(im1));
[fb,db] = vl_sift(single(im2));
[matches,scores] = vl_ubcmatch(da,db);
nMatch=size(matches,2);
