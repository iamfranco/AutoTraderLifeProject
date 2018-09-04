function k = scale_approx(x,y)
  k = dot(x/norm(y), y/norm(y));
end