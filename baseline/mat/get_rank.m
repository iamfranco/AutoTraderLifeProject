function x_rank = get_rank(x)
  [~, x_ind] = sort(x,'descend');
  x_rank(x_ind) = 1:length(x);
end