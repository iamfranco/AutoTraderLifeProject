mydefaults
showErrorDetail = false;
tol = 10^-10;

m = 20;
N = 1000;
A = round(rand(N,N)*1);
for i=1:N
  A(i,i) = 0; % remove self-cycle edge
end
v = ones(N,1);

[V,H] = arnoldi(A,v,m);

% check columns of V being orthonormal basis
if all(all(V'*V - eye(m+1) < tol))
  disp(" V orthonormal : TRUE");
else
  if showErrorDetail
    disp("V'*V = ");
    disp(V'*V);
  end
  disp(" V orthonormal : FALSE");
end

% check H = V'AV 
if all(all(H(1:m,1:m) - V(:,1:m)'*A*V(:,1:m) < tol)) 
  disp("      H = V'AV : TRUE");
else
  if showErrorDetail
    disp(" ");
    disp("H = ");
    disp(H);
    disp("V'AV = ");
    disp(V'*A*V);
  end
  disp("      H = V'AV : FALSE");
end

% check if e^A v is approximately norm(v)V_m e^H e1
eAv = expm(A)*v; % true value

eAv_approx = exponential_centrality(V,H,v,m); % approximation
disp(['relative error : ' num2str( norm(eAv - eAv_approx)/norm(eAv) ) ' (eAv and eAv_approx)']);

% check if resolvent centrality is approximately norm(v)V_m(I-alpha*H)^{-1}e1 
lambda1 = eigs(A,1);
alpha = (1 - exp(-lambda1))/lambda1; % alpha_min
% alpha = 0.5 / lambda1; % alpha_0.5
resolvent = (eye(N) - alpha * A) \ v;
resolvent_approx = resolvent_centrality(V,H,v,m,alpha);
disp(['relative error : ' , num2str(norm(resolvent - resolvent_approx)/norm(resolvent)) , ' (resolvent and resolvent_approx)']);
scale_r = scale_approx(resolvent_approx, resolvent);
disp(['relative error : ' , num2str(norm(scale_r*resolvent - resolvent_approx)/norm(scale_r*resolvent)), ' (scaled_resolvent and resolvent_approx)']);

%% watch how the leading eigenvalue gets captured
lambda1_A = eigs(A,1);
figure()
scatter(real(lambda1_A),imag(lambda1_A),200,'o','MarkerEdgeColor',[0.8, 0.2, 0.2]);
hold on

m_i_range = 1:m;
spectral_A_H_diff = zeros(1,length(m_i_range));
count = 1;
for m_i = m_i_range
  lambda1_H = eigs(H(1:m_i,1:m_i),1);
  fprintf("lambda_H_%d = %f\n", m_i, lambda1_H);
  scatter(real(lambda1_H),imag(lambda1_H),'x','MarkerEdgeColor',[0.2, 0.0, 0.8],'LineWidth',2);
  if (m_i <= 3)
    text(real(lambda1_H), imag(lambda1_H)+0.2, ['m = ' num2str(m_i)],'Rotation',90,'Color',[0.2, 0.0, 0.8]);
  end
  spectral_A_H_diff(count) = abs(lambda1_H)-abs(lambda1_A);
  count = count + 1;
end
set(gcf, 'Position', [0, 250, 700, 250])
xlabel('real part')
ylabel('imaginary part')
legend('\lambda_A = leading eigenvalue of A','\lambda_{H_m} = leading eigenvalue of H_m','Location','N');
print('-depsc', '../fig/ritz/cross_and_circle.eps');

spectral_A_H_diff_abs = abs(spectral_A_H_diff);

figure()
plot(m_i_range,spectral_A_H_diff_abs);
hold on
scatter(m_i_range,spectral_A_H_diff_abs,'k','.');
set(gcf, 'Position', [0, 330, 800, 330])
set(gca,'yscale','log');
set(gca,'YTick',10.^[-12:2:0])
ylim(10.^[-12;0]);
xlabel('m');
ylabel('|\rho(H_m) - \rho(A)|');
print('-depsc', '../fig/ritz/lambda1_diff.eps');

%% plot m v error estimate (exp)
m_start = 2;
m_range = m_start:m;
abs_ers = zeros(size(m_range));
er1s = zeros(size(m_range));
rel_ers = zeros(size(m_range));
rel_er1s = zeros(size(m_range));
for m_i = m_range
  i = m_i-m_start+1;
  eAv_approx = exponential_centrality(V,H,v,m_i);
  abs_ers(i) = norm(eAv - eAv_approx);
  er1s(i) = error_estimate_exp(H,v,m_i);
  rel_ers(i) = abs_ers(i) / norm(eAv);
  rel_er1s(i) = er1s(i) / norm(eAv_approx);
end

figure()
plot(m_range,rel_ers,'b*-');
hold on
plot(m_range,rel_er1s,'r*-');
set(gca,'yscale','log')
title('Error of Arnoldi approximants of exponential-based centrality vector');
legend('relative error','relative error estimate');
xlabel('m');
print('-depsc', '../fig/error_estimate/rel_er1_exp.eps');

%% plot m v error estimate (res)
m_start = 2;
m_range = m_start:m;
abs_ers = zeros(size(m_range));
er1s = zeros(size(m_range));
rel_ers = zeros(size(m_range));
rel_er1s = zeros(size(m_range));
residual_bound_estimate = zeros(size(m_range));
rel_residual_bound_estimate = zeros(size(m_range));

MA_norm = norm(eye(N) - alpha*A);
MH_norm = zeros(size(m_range));

scs = zeros(size(m_range));
for m_i = m_range
  i = m_i-m_start+1;
  resolvent_approx = resolvent_centrality(V,H,v,m_i,alpha);
  scale = scale_approx(resolvent_approx,resolvent);
  scs(i) = scale;
  abs_ers(i) = norm(scale*resolvent - resolvent_approx);
  er1s(i) = error_estimate_res(H,v,m_i,alpha);
  rel_ers(i) = abs_ers(i) / norm(scale*resolvent);
  rel_er1s(i) = er1s(i) / norm(resolvent_approx);
  
  MH_norm(i) = norm(eye(m_i) - alpha*H(1:m_i,1:m_i));
  residual_bound_estimate(i) = residual_norm(H,v,alpha,m_i) / MH_norm(i);
  rel_residual_bound_estimate(i) = residual_bound_estimate(i) / norm(resolvent_approx);
  
  
%   rel_residuals_bound(i) = rel_residuals_norm(i) / MA_norm;
%   rel_residuals_bound_approx(i) = rel_residuals_norm(i) / MH_norm(i);
  
end

figure()
plot(m_range,rel_ers,'b*-');
hold on
plot(m_range,rel_er1s,'r*-');
set(gca,'yscale','log')
title('Error of Arnoldi approximants of resolvent-based centrality vector');
legend('relative error','relative error estimate');
xlabel('m');
print('-depsc', '../fig/error_estimate/rel_er1_res.eps');

figure()
plot(m_range,rel_ers,'b*-');
hold on
plot(m_range,rel_er1s,'r*-');
plot(m_range,rel_residual_bound_estimate,'g*-');
set(gca,'yscale','log')
title('Error of Arnoldi approximants of resolvent-based centrality vector');
legend('relative error','relative error estimate','relative residual bound estimate');
xlabel('m');
print('-depsc', '../fig/error_estimate/rel_er1_res_residual.eps');

figure()
plot(MA_norm - MH_norm)