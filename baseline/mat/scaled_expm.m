function [expm_approx, gammak] = scaled_expm(A,k)
  expm_approx = expm(A/k); % prevent expm(A) inf problem
  gamma = mean(mean(expm_approx));
  expm_approx = expm_approx/gamma; % prevent expm_approx^k inf problem
  expm_approx = expm_approx^k;
  gammak = gamma^k;
end