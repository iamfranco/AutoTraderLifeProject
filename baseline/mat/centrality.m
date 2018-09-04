if ~exist('A','var')
  mydefaults
  load('adjacency.mat');
end

v = ones(length(A),1);
m = 20;
[V,H] = arnoldi(A,v,m);

exp_cent = exponential_centrality(V,H,v,m,true);
exp_cent_er1 = error_estimate_exp(H,v,m,true);

lambda1 = eigs(H(1:m,:),1);
alpha_min = (1 - exp(-lambda1))/lambda1; % alpha_min
alpha_099 = 0.99 / lambda1;
alpha_085 = 0.85 / lambda1;
alpha_05 = 0.5 / lambda1;

res_cent_min = resolvent_centrality(V,H,v,m,alpha_min);
res_cent_099 = resolvent_centrality(V,H,v,m,alpha_099);
res_cent_085 = resolvent_centrality(V,H,v,m,alpha_085);
res_cent_05 = resolvent_centrality(V,H,v,m,alpha_05);

res_cent_min_er1 = error_estimate_res(H,v,m,alpha_min);
res_cent_099_er1 = error_estimate_res(H,v,m,alpha_099);
res_cent_085_er1 = error_estimate_res(H,v,m,alpha_085);
res_cent_05_er1 = error_estimate_res(H,v,m,alpha_05);

residual_bound_estimate_min = residual_bound_est(H,v,alpha_min,m);
residual_bound_estimate_099 = residual_bound_est(H,v,alpha_099,m);
residual_bound_estimate_085 = residual_bound_est(H,v,alpha_085,m);
residual_bound_estimate_05 = residual_bound_est(H,v,alpha_05,m);


%% display users (sort by centrality high to low)
if ~exist('T','var')
  T = readtable('data/nodes_info.txt','Format','%s%s%d%d');
end

influential_users(exp_cent,10,T,'exponential-based centrality',exp_cent_er1);
influential_users(res_cent_min,10,T,'resolvent-based centrality with alpha_min',res_cent_min_er1,residual_bound_estimate_min);
influential_users(res_cent_099,10,T,'resolvent-based centrality with alpha_0.99',res_cent_099_er1,residual_bound_estimate_099);
influential_users(res_cent_085,10,T,'resolvent-based centrality with alpha_0.85',res_cent_085_er1,residual_bound_estimate_085);
influential_users(res_cent_05,10,T,'resolvent-based centrality with alpha_0.5',res_cent_05_er1,residual_bound_estimate_05);

%% check node orderings between exp_cent and res_cent
exp_cent_rank = get_rank(exp_cent);
res_cent_min_rank = get_rank(res_cent_min);
res_cent_05_rank = get_rank(res_cent_05);
res_cent_085_rank = get_rank(res_cent_085);
res_cent_099_rank = get_rank(res_cent_099);

scatter_rank(exp_cent_rank,res_cent_min_rank, ...
  'ranking(exp\_cent)','ranking(res\_cent)','exp','res_min',100);

scatter_rank(exp_cent_rank,res_cent_05_rank, ...
  'ranking(exp\_cent)','ranking(res\_cent)','exp','res_05',100);

scatter_rank(exp_cent_rank,res_cent_085_rank, ...
  'ranking(exp\_cent)','ranking(res\_cent)','exp','res_085',100);

scatter_rank(exp_cent_rank,res_cent_099_rank, ...
  'ranking(exp\_cent)','ranking(res\_cent)','exp','res_099',100);

%% identify users with lots of followers and few friends
fo_fr_ratio = 10;
if ~exist('nodes_friends_count','var')
  T = readtable('data/nodes_info.txt','Format','%s%s%d%d');
  T = T(1:end-1,:); % remove last empty row
  nodes_followers_count = table2array(T(:,3));
  nodes_friends_count = table2array(T(:,4));
end
nodes_passed = nodes_followers_count > fo_fr_ratio * nodes_friends_count;

ind = influential_users(exp_cent.*nodes_passed,10,T,'exponential-based centrality, filter: followers/friends > 10',exp_cent_er1);

%% 