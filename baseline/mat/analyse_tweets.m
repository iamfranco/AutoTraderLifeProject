mydefaults % use custom default graphic

%% load tweets and retweets data 
load('tweet_objects.mat');

%% original tweets and retweets
dotsize = 40;
[tweet_retweets_sorted,index_retweets] = sort(TM(:,1),'descend');
original_tweets_sorted = tweet_retweets_sorted(~isRetweet(index_retweets));
retweet_tweets_sorted = tweet_retweets_sorted(isRetweet(index_retweets));
original_tweets_first_zero = find(original_tweets_sorted == 0);
scatter(1:original_tweets_first_zero,original_tweets_sorted(1:original_tweets_first_zero),dotsize,'filled','MarkerFaceColor','b');
hold on
scatter(original_tweets_first_zero:sum(~isRetweet),repelem(0.1,length(original_tweets_first_zero:sum(~isRetweet))),dotsize,'filled','MarkerFaceColor','b','HandleVisibility','off');
scatter(sum(~isRetweet)+1:length(isRetweet),tweet_retweets_sorted(isRetweet(index_retweets)),dotsize,'filled');
set(gcf, 'Position', [0, 400, 800, 400])
ylim([0.1, 1e4])
set(gca,'yscale','log')
legend('Original tweet','Retweet tweet','Location','NE')
xlabel('Tweets');
ylabel('Retweet counts');
a1x = 0.14; a1y = 0.62; % annotation fab goodies
a2x = 0.475; a2y = 0.911; % annotation Orlando
a3x1 = 0.296; a3x2 = 0.465; a3y = 0.17;
annotation('textarrow',[a1x+0.02, a1x], [a1y+0.01, a1y],'String','Tweet about "fab goodies"')
annotation('textarrow',[a2x+0.02, a2x], [a2y-0.02, a2y],'String','Tweet about "Orlando shooting"')
annotation('line',[a3x1, a3x2],[a3y, a3y]);
annotation('line',[a3x1, a3x1],[a3y-0.02, a3y]);
annotation('line',[a3x2, a3x2],[a3y-0.02, a3y]);
text(790, 0.3,'Tweets with zero retweets')
print('-depsc', '../fig/layer3/OTRT.eps');

%% see how many retweeters_ids were already in nodes_ids
if ~exist('foa_cell','var')
  load('layer_cells.mat');
end

[retweeter_ids_unique,retweeter_ids_unique_select] = unique(retweeter_ids);
retweeter_ids_unique_cell = retweeter_ids_cell(retweeter_ids_unique_select);
retweeter_ids_unique_in_foa = zeros(size(retweeter_ids_unique));
retweeter_ids_unique_in_foa_or_fofoa = zeros(size(retweeter_ids_unique));

foa_ids = string(foa_cell);
fofoa_ids = string(fofoa_cell);

wb = waitbar(0,'retweeter in nodes: Please wait');
for n = 1:length(retweeter_ids_unique)
  waitbar(n/length(retweeter_ids_unique),wb)
  retweeter_ids_unique_in_foa(n) = any(foa_ids == retweeter_ids_unique(n));
  if (retweeter_ids_unique_in_foa(n))
    retweeter_ids_unique_in_foa_or_fofoa(n) = 1;
  else
    retweeter_ids_unique_in_foa_or_fofoa(n) = any(fofoa_ids == retweeter_ids_unique(n));
  end
end
retweeter_ids_unique_in_foa = boolean(retweeter_ids_unique_in_foa);
retweeter_ids_unique_in_foa_or_fofoa = boolean(retweeter_ids_unique_in_foa_or_fofoa);
close(wb)

disp("found in fo(a) or fo(fo(a)): " + sum(retweeter_ids_unique_in_foa_or_fofoa) / length(retweeter_ids_unique));
% 0.91849, so 91.849% of our retweeters live in layer 1 union layer 2.

disp("found in fo(a): " + sum(retweeter_ids_unique_in_foa) / length(retweeter_ids_unique));
% 0.55895, so 55.895% of our retweeters are from layer1.

retweeter_ids_count = zeros(size(retweeter_ids_unique_cell));
retweeter_ids_unique_ind = containers.Map(retweeter_ids_unique_cell,1:length(retweeter_ids_unique_cell));
for i = 1:length(retweeter_ids)
  ind = retweeter_ids_unique_ind(retweeter_ids_cell{i});
  retweeter_ids_count(ind) = retweeter_ids_count(ind) + 1;
end

[retweeter_ids_count_sorted, index_retweeter_count] = sort(retweeter_ids_count,'descend');


foa_end_ind = sum(retweeter_ids_unique_in_foa);
nodes_end_ind = sum(retweeter_ids_unique_in_foa_or_fofoa);
retweeter_end_ind = length(retweeter_ids_count_sorted);
retweeter_ids_unique_in_fofoa = retweeter_ids_unique_in_foa_or_fofoa & ~retweeter_ids_unique_in_foa;

figure();
dotsize = 40;
scatter(1:foa_end_ind, retweeter_ids_count_sorted(retweeter_ids_unique_in_foa(index_retweeter_count)),dotsize,'filled');
hold on
scatter(foa_end_ind+1:nodes_end_ind, retweeter_ids_count_sorted(retweeter_ids_unique_in_fofoa(index_retweeter_count)),dotsize,'filled');
scatter(nodes_end_ind+1:retweeter_end_ind, retweeter_ids_count_sorted(~retweeter_ids_unique_in_foa_or_fofoa(index_retweeter_count)),dotsize,'filled');
xlabel('Retweeter');
ylabel('Number of retweets performed');
legend('fo(a)','fo(fo(a))\\fo(a)','external');
set(gca,'yscale','log')
set(gcf, 'Position', [0, 300, 850, 300])
print('-depsc', '../fig/layer3/retweeter_by_layer.eps');

%% retweeters who retweeted the most
% retweeter_ids_unique = unique(retweeter_ids);
% retweeter_ids_count = zeros(size(retweeter_ids_unique));
% retweeter_ids_unique_ind = containers.Map(retweeter_ids_unique,1:length(retweeter_ids_unique));
% for i = 1:length(retweeter_ids)
%   retweeter_id = retweeter_ids(i);
%   ind = retweeter_ids_unique_ind(retweeter_id);
%   retweeter_ids_count(ind) = retweeter_ids_count(ind) + 1;
% end
% 
% [~,index_retweeter_count] = sort(retweeter_ids_count,'descend');
% figure()
% plot(retweeter_ids_count(index_retweeter_count));
% ylabel('retweet counts');
% xlabel('retweeter (sorted by retweet counts)');
% 
% % fprintf("     index              twitter-id           screen_name    followers      friends     retweets\n");
% % fprintf("-----------------------------------------------------------------------------------------------------------------\n");
% % for i = 1:10
% %   index = index_retweeter_count(i);
% %   id = retweeter_ids(index);
% %   [screen_name, followers_count, friends_count] = id2info(id);
% %   if (followers_count == -1)
% %     [screen_name, followers_count, friends_count] = id2info_deep(id);
% %   end
% %   fprintf("%10d    %20d   %20s    %8d     %8d     %8d\n" , index, id, screen_name, followers_count, friends_count, retweeter_ids_count(index));
% % end
% 
% %% correlation between retweet_counts and friends (run previous section first) (takes long time)
% retweeter_followers_count  = zeros(size(retweeter_ids_unique));
% retweeter_friends_count = zeros(size(retweeter_ids_unique));
% for i = 1:length(index_retweeter_count)
%   index = index_retweeter_count(i);
%   id = retweeter_ids(index);
%   [screen_name, followers_count, friends_count] = id2info(id);
%   if (followers_count == -1)
%     [screen_name, followers_count, friends_count] = id2info_deep(id);
%   end
%   retweeter_followers_count(index) = followers_count;
%   retweeter_friends_count(index) = friends_count;
%   fprintf("%10d    %20d   %20s    %8d     %8d     %8d\n" , i, id, screen_name, followers_count, friends_count, retweeter_ids_count(index));
% end
% 
% scatter(retweeter_friends_count,retweeter_ids_count)
% % no strong correlation
% 
% %% sorter for retweet and favorites
% [~,index_retweets] = sort(TM(:,1));
% [~,index_favorites] = sort(TM(:,2));
% [~,index_tweet_retweet_time_diff] = sort(tweet_retweet_time_diff);
% [~,index_retweets_otweets] = sort(OTM(:,1));
% 
% %% plot retweets (ascending)
% figure()
% plot(TM(index_retweets,1));
% set(gca,'yscale','log')
% xlabel('tweet (sorted by retweets count)');
% ylabel('retweets count');
% 
% %% plot favorites (ascending)
% figure()
% plot(TM(index_favorites,2));
% set(gca,'yscale','log')
% xlabel('tweet (sorted by favorites count)');
% ylabel('favorites count');
% 
% %% histo hour of day
% figure()
% histogram(tweet_times.Hour);
% hold on
% histogram(tweet_times(~isRetweet).Hour);
% xlabel('Tweet created at hour of day');
% ylabel('frequency');
% 
% %% scatter hour v retweet
% figure()
% scatter(tweet_times(isRetweet).Hour-0.1, TM(isRetweet,1),'filled','MarkerFaceAlpha',0.1,'MarkerFaceColor','r');
% set(gca,'yscale','log')
% hold on
% scatter(tweet_times(~isRetweet).Hour+0.1, TM(~isRetweet,1),'filled','MarkerFaceAlpha',0.1,'MarkerFaceColor','b');
% xlabel('Tweet created at hour of day');
% ylabel('retweets count');
% legend('Retweet','Original Tweet');
% 
% %% scatter hour v favorite
% figure()
% scatter(tweet_times(isRetweet).Hour-0.1, TM(isRetweet,2),'filled','MarkerFaceAlpha',0.1,'MarkerFaceColor','r');
% hold on
% scatter(tweet_times(~isRetweet).Hour+0.1, TM(~isRetweet,2),'filled','MarkerFaceAlpha',0.1,'MarkerFaceColor','b');
% xlabel('Tweet created at hour of day');
% ylabel('favorites count');
% legend('Retweet','Original Tweet');
% 
% %% plot tweet retweet time difference (sorted)
% figure()
% plot(hours(tweet_retweet_time_diff(index_tweet_retweet_time_diff)))
% set(gca,'yscale','log')
% xlabel('retweets (sorted)')
% ylabel('hours difference')
