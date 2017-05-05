N = 20;
Images = [];
SIFTdescr = [];
for i = 1:N
  name = sprintf('ukbench%05d.jpg', i-1);
  Images{i} = im2single(rgb2gray(imread(name)));
  [img, descrips] = vl_sift(Images{i});
  SIFTdescr{i} = descrips;
end
