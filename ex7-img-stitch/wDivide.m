function q1 = wDivide(q1)
  for i=1:size(q1,1)
    q1(i,:) = q1(i,:)./q1(end,:);
  end
end
