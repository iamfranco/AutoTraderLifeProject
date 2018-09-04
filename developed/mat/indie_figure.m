% independent figures that doesn't depend on any data

%% weight w(k)
mydefaults
t = linspace(0.05,5);
k_range = 1:5;

w_e = zeros(length(k_range),length(t));
w_r = zeros(length(k_range),length(t));

for i = 1:length(k_range)
  k = k_range(i);
  w_e(i,:) = t.^k ./ factorial(k);
  w_r(i,:) = t.^k;
end

legend_cell = cellstr(num2str(k_range','k=%.0f'));
figure()
hold on
for i = 1:length(k_range)
  plot(t,w_e(i,:));
end
legend(legend_cell);
xlabel('t');
ylabel('t^k/k!');

legend_cell = cellstr(num2str(k_range','k=%.0f'));
figure()
hold on
for i = 1:length(k_range)
  plot(t,w_e(i,:)./w_e(1,:));
end
legend(legend_cell);
xlabel('t');
ylabel('t^{k-1}/k!');


%% weight w(k)
k = 1:10;
w_e = @(t) t.^k ./ factorial(k);
w_r = @(alpha) alpha.^k;

t_arr = [0.25, 0.5, 1, 2, 4];
legend_cell = cellstr(num2str(t_arr','t=%.2f'));
figure()
hold on
for i = 1:length(t_arr)
  plot(k,w_e(t_arr(i)));
end
legend(legend_cell);
xlabel('k');
ylabel('t^k/k!');

figure()
hold on
for i = 1:length(t_arr)
  vals = w_e(t_arr(i));
  plot(k,vals/vals(1));
end
legend(legend_cell);
xlabel('k');
ylabel('t^k/k!');

%% calculate fetch time
if ~exist('followers_count_array','var')
  mydefaults
  T = readtable('data/nodes_info.txt','Format','%s%s%d%d','ReadVariableNames',false);
  T = T(1:end-1,:); % remove last empty row
  followers_count_array = double(table2array(T(:,3)));
  followers_count_array = followers_count_array(2034:3343755); % only include fofoa
end

[~,followers_count_array_sort_ind] = sort(followers_count_array,'descend');
figure()
plot(followers_count_array(followers_count_array_sort_ind));
set(gca,'yscale','log');
xlabel('Layer-2 followers');
ylabel('Followers counts');
set(gcf, 'Position', [0, 350, 600, 350])
print('-depsc', '../fig/layer3/followers_count.eps');

if ~exist('cumulative_fetch_time_minutes','var')
  fetch_time_minutes = ceil(followers_count_array/5000);
  cumulative_fetch_time_minutes = zeros(1,length(fetch_time_minutes));
  cumulative_fetch_time_minutes(1) = fetch_time_minutes(followers_count_array_sort_ind(1));
  for i = 2:length(followers_count_array_sort_ind)
    cumulative_fetch_time_minutes(i) = cumulative_fetch_time_minutes(i-1) + fetch_time_minutes(followers_count_array_sort_ind(i));
    disp(i);
  end
end

figure()
plot(fetch_time_minutes(followers_count_array_sort_ind))
xlabel('Layer-2 followers');
ylabel('Fetch times (minutes)');
set(gca,'yscale','log');
set(gca,'YTick',10.^[0:5])
set(gcf, 'Position', [0, 260, 600, 260])
print('-depsc', '../fig/layer3/fetch_time.eps');

figure()
plot(cumulative_fetch_time_minutes/60/24)
xlabel('Layer-2 followers');
ylabel('Cumulative fetch times (days)');
set(gcf, 'Position', [0, 320, 600, 320])
print('-depsc', '../fig/layer3/cumulative_fetch_time.eps');

figure()
plot(cumulative_fetch_time_minutes(1:100)/60/24)
xlabel('Top 10 layer-2 followers with most followers counts');
ylabel('Cumulative fetch times (days)');
set(gcf, 'Position', [0, 320, 600, 320])
print('-depsc', '../fig/layer3/cumulative_fetch_time_100.eps');