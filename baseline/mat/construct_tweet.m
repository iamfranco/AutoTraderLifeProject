% NEED TO USE STRING INSTEAD OF UINT64
T = readtable('data/tweets.txt','Format','%s%{yyyy-MM-dd HH:mm:ss}D%d%d%d%s');
T.Properties.VariableNames = {'tweet_id','time','retweets','favorites','isretweet','content'};
TM = table2array(T(:,{'retweets','favorites'}));
tweet_ids_cell = table2cell(T(:,{'tweet_id'}));
tweet_ids = string(tweet_ids_cell);
isRetweet = boolean(table2array(T(:,{'isretweet'})));
tweet_times = table2array(T(:,{'time'}));
tweet_content = string(table2cell(T(:,{'content'})));
tweet_ids_ind = containers.Map(tweet_ids_cell,1:length(tweet_ids_cell));

OT = T(~isRetweet,:);
OTM = TM(~isRetweet,:);
otweet_ids_cell = tweet_ids_cell(~isRetweet);
otweet_ids = string(otweet_ids_cell);
otweet_ids_ind = containers.Map(otweet_ids_cell,1:length(otweet_ids_cell));

RT = readtable('data/tweets_retweets.txt','Format','%s%s%s%{yyyy-MM-dd HH:mm:ss}D%d%d');
RT.Properties.VariableNames = {'tweet_id','retweet_id','user_id','retweet_time','retweets','favorites'};
retweet_ids_cell = table2cell(RT(:,{'tweet_id'}));
retweet_ids = string(retweet_ids_cell);
retweeter_ids_cell = table2cell(RT(:,{'user_id'}));
retweeter_ids = string(retweeter_ids_cell);
retweet_times = table2array(RT(:,{'retweet_time'}));

tweet_retweet_time_diff = hours(zeros(length(retweet_ids),1));
for n = 1:length(retweet_ids)
  tweet_retweet_time_diff(n) = retweet_times(n) - tweet_times(tweet_ids_ind(retweet_ids_cell{n}));
end

retweet_ids_ind = containers.Map(retweet_ids_cell,1:length(retweet_ids_cell));

save('tweet_objects.mat','isRetweet','OT','OTM','otweet_ids','otweet_ids_cell','otweet_ids_ind','retweet_ids','retweet_ids_cell','retweet_ids_ind','retweet_times','retweeter_ids','retweeter_ids_cell','RT','T','TM','tweet_content','tweet_ids','tweet_ids_cell','tweet_ids_ind','tweet_retweet_time_diff','tweet_times');