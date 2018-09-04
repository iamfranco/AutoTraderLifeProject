function ind = influential_users(centralities,k,T,cent_name,error_estimate,varargin)
  [~, ind] = sort(centralities,'descend');
  disp(['Most influential users based on ' cent_name ':'])
  fprintf("\n");
  fprintf("rank   node-index          screen_name    followers     friends      centrality\n");
  fprintf("-------------------------------------------------------------------------------\n");
  for i = 1:k
    index = ind(i);
    screen_name = string(table2cell(T(index,2)));
    followers_count = table2val(T(index,3));
    friends_count = table2val(T(index,4));
    fprintf("%3d  %10d   %20s    %8d     %8d    %10e\n" , i, index, screen_name, followers_count, friends_count, centralities(index));
  end
  fprintf("\n");
  disp(['                  error estimate = ' num2str(error_estimate)]);
  disp(['         relative error estimate = ' num2str(error_estimate/norm(centralities))]);
  if (nargin == 6)
    disp(['relative residual bound estimate = ' num2str(varargin{1}/norm(centralities))]);
  end
  fprintf("\n");
  disp("- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -");
end