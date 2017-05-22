function P = CamResection(qs, Qs)
  if size(qs,2)~=size(Qs,2)
    disp(sprintf('# of 2D/3D points does not match (%d/%d)', length(qs), length(Qs)));
  elseif size(qs,2)==1
    B = constraint(qs,Qs);
    [u,s,v] = svd(B);
    P = reshape(v(:,end),3,4);
  else
    B = [];
    for i=1:length(qs)
      b = constraint(qs(:,i), Qs(:,i));
      B = [B; b];
    end
    [u,s,v] = svd(B);
    P = reshape(v(:,end),3,4);
  end
end

function b = constraint(q,Q)
  b = [
    0 -Q(1) q(2)*Q(1) 0 -Q(2) q(2)*Q(2) 0 -Q(3) q(2)*Q(3) 0 -1 q(2);
    Q(1) 0 -q(1)*Q(1) Q(2) 0 -q(1)*Q(2) Q(3) 0 -q(1)*Q(3) 1 0 -q(1);
    -q(2)*Q(1) q(1)*Q(1) 0 -q(2)*Q(2) q(1)*Q(2) 0 -q(2)*Q(3) q(1)*Q(3) 0 -q(2) q(1) 0
  ];
end
