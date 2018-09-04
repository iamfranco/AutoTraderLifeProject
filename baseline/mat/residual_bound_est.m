function res_bd_est = residual_bound_est(H,v,alpha,m)
  res_bd_est = residual_norm(H,v,alpha,m) / norm(eye(m) - alpha*H(1:m,1:m));
end