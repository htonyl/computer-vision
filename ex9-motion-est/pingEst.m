data = load('Ex9_PingData.mat');

% Background subtraction
ptL = cell(24,2,1); ptR = cell(24,2,1);
for i = 1:24
  data.ImL{i} = double(abs(data.ImL{i}-data.BaseL));
  data.ImR{i} = double(abs(data.ImR{i}-data.BaseR));
  [m,a] = max(reshape(data.ImL{i},[],1));
  ptL{i} = [floor(a/640/3); rem(floor(a/3),640)]
  [m,a] = max(reshape(data.ImR{i},[],1));
  ptR{i} = [floor(a/640/3); rem(floor(a/3),640)]
end

function x = triangulation3D(p1, p2, A1, A2)
  B = [
    A1(3,:)*p1(1)-A1(1,:);
    A1(3,:)*p1(2)-A1(2,:);
    A2(3,:)*p2(1)-A2(1,:);
    A2(3,:)*p2(2)-A2(2,:);
  ]
end
