function d = FSampDist(F,p1,p2)
  M = [1 1 0]; p1 = [p1; 1]; p2 = [p2; 1];
  est1 = (F*p1).^2; est2 = (p2'*F)'.^2;
  d = (p2'*F*p1)^2/(M*est1+M*est2);
end
