function res = resolvent_centrality(V,H,v,m,alph)
  e1 = zeros(m,1);
  e1(1) = 1;
  res = norm(v) * (V(:,1:m) * ( (speye(m) - alph* H(1:m,1:m)) \ e1));
end