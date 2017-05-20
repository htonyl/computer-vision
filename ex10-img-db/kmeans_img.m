N = 10;
K = 30;

if ~exist('Images') Images = []; end;
if ~exist('SIFTdescr') SIFTdescr = []; end;
if ~exist('bins') bins = []; end;
if ~exist('centers') centers = []; end;

%% Extract SIFT features for each train img
if size(SIFTdescr,2) ~= N
  disp('Extracting SIFT features...')
  Images = [];
  SIFTdescr = [];
  for i = 1:N
    name = sprintf('ukbench%05d.jpg', i-1);
    Images{i} = im2single(rgb2gray(imread(name)));
    [img, descrips] = vl_sift(Images{i});
    SIFTdescr{i} = descrips;
  end
end

%% Isolate test img
q_idx = 8;
q_sift = SIFTdescr{q_idx};
d_range = [1:(q_idx-1) (q_idx+1):size(SIFTdescr, 2)];

descriptors = [];
for i = d_range
  descriptors = [descriptors; SIFTdescr{i}'];
end

%% Calculate K means clusters
% centers[K, n_sift_bins = 128] = K sift descriptors calculated as means
% mincenter[n_sift_feat, 1] = centers each sift feat. belongs to
% mindist[n_sift_feat, 1] = distance between data and it's center
disp('Calculate K means clusters...')
[centers,mincenter,mindist,q2,quality] = kmeans(descriptors, K, 0);
h = histogram(mincenter, K);
bins = h.Values;

disp('Matching query image...')
m_score = intmax;
q_bin = imgDescrBin(q_sift, centers);
for i = d_range
  t_bin = imgDescrBin(SIFTdescr{i}, centers);
  score = distBin(q_bin, t_bin, []);
  if m_score > score
    m_idx = i;
    m_score = score;
  end
end
figure;
subplot(1,2,1), imagesc(Images{q_idx}), title(sprintf('Query Image [ukbench%05d.jpg]', q_idx));
subplot(1,2,2), imagesc(Images{m_idx}), title(sprintf('Match [ukbench%05d.jpg]', m_idx));
suptitle(sprintf('Distance score %f', m_score), 'VerticalAlignment', 'bottom');

function b = imgDescrBin(query, centers)
  d = [];
  for i = 1:size(centers,1)
    d = [d calcdist(query', centers(i,:))];
  end
  [m,idx] = min(d,[],2);
  h = histogram(idx,size(centers,1)); b = h.Values;
end

function d = distBin(x, y, w)
  if isempty(w)
    % chi-squared distance
    d = nansum((x-y).^2./(x+y));
  else
    % Weighted by the frequency of visual word occurence
    d = 2 * nansum((x-y).^2./(x+y).*w);
  end
end
