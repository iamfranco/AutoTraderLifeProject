function [eAv_approx, gammak] = exponential_centrality(V,H,v,m,varargin)
  V_crop = V(:,1:m);
  H_crop = H(1:m,1:m);
  e1 = eye(length(H_crop),1);
  if (nargin == 5 && varargin{1}) % if user wants eAv_approx to be scaled (to avoid inf problem)
    [s_expm, gammak] = scaled_expm(H_crop,25);
    eAv_approx = norm(v)*V_crop*s_expm*e1; % scaled_expm avoid inf problem
  else % compute eAv_approx normally
    eAv_approx = norm(v)*V_crop*expm(H_crop)*e1;
    gammak = 1;
  end
end