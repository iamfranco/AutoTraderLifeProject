% based on Arnoldi alogrithm from Saad92 page 210

function [V, H] = arnoldi(A,v,m)
  V = zeros(size(A,1),m+1);
  V(:,1) = v / norm(v);
  H = zeros(m+1,m);
  wb = waitbar(0,'Arnoldi: Please wait');
  for j = 1:m
      waitbar(j/m,wb)
    w = A * V(:,j);
    for i = 1:j
      H(i,j) = dot(w,V(:,i));
      w = w - H(i,j) * V(:,i);
    end
    H(j+1,j) = norm(w);
    V(:,j+1) = w / H(j+1,j);
  end
  close(wb)
end