data = load('Ex9_PingData.mat');

% Background subtraction
ptL = cell(24,2,1); ptR = cell(24,2,1);
ImL = []; ImR = [];
for i = 1:24
  ImL{i} = double(abs(data.ImL{i}-data.BaseL));
  ImR{i} = double(abs(data.ImR{i}-data.BaseR));
  [mr,ar] = max(ImL{i}(:,:,1)); [mc,ac] = max(mr);
  ptL{i} = [ar(ac); ac];
  [m,a] = max(reshape(data.ImR{i},[],1));
  ptR{i} = [floor(a/640/3); rem(floor(a/3),640)];
end
