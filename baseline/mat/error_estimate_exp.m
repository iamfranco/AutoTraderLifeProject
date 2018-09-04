function [er1, gammak] = error_estimate_exp(H,v,m,varargin)
  e1 = eye(m,1);
  em = zeros(m,1);
  em(m) = 1;
  if (nargin == 4 && varargin{1}) % if user wants er1 to be scaled (to avoid inf problem)
    [s_expm, gammak] = scaled_expm(H(1:m,1:m),25);
    er1 = H(m+1,m) * abs(em' * ((H(1:m,1:m))\(s_expm - eye(m)/gammak)) * norm(v) * e1); % scaled_expm to avoid inf problem
  else % compute er1 normally
    er1 = H(m+1,m) * abs(em' * ((H(1:m,1:m))\(expm(H(1:m,1:m)) - eye(m))) * norm(v) * e1);
    gammak = 1;
  end
end