im = imread('petergade.png');
imagesc(im);
% X = ginput(4)
Mean = mean(X')';
X(1,:) = X(1,:) - Mean(1);
X(2,:) = X(2,:) - Mean(2);
S = mean(sqrt(diag(X'*X)))/sqrt(2);
X(1:2,:) = X(1:2,:)/S;
% T = [eye(2)/S -Mean(1:2)/S; 0 0 1];
Y = [0 0 1; 610 0 1; 610 1340 1; 0 1340 1]';
H = Hest(X,Y);

figure;
% Note That H has to be transposed here if column vectors are used for poin
% Tr = maketform('projective',H');
tform = projective2d(H');
% tform = fitgeotrans(X,Y(1:2,:)','projective');
% XData and YData need to be specified to get the output coordinate system
% WarpIm=imtransform(im,Tr,'YData',[-1 3],'XData',[-100 5]);
WarpIm = imwarp(im,tform);
imagesc(WarpIm);
