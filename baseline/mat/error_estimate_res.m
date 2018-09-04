function er1 = error_estimate_res(H,v,m,alpha)
  e1 = eye(m,1);
  em = zeros(m,1);
  em(m) = 1;
  er1 = H(m+1,m) * abs(em' * ((H(1:m,1:m))\(inv(eye(m)-alpha*H(1:m,1:m)) - eye(m))) * norm(v) * e1);
end