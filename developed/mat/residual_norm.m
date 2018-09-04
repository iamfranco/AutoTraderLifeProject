function res_norm = residual_norm(H,v,alpha,m)
  e1 = eye(m,1);
  em = zeros(m,1); em(m) = 1;
  res_norm = norm(v) * alpha * abs( H(m+1,m) * em'* ((eye(m) - alpha*H(1:m, 1:m))\e1) );
end