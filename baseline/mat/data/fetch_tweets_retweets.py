import tweepy
import time
import csv

tweets_file = 'tweets.txt'
retweets_file = 'tweets_retweets.txt'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

def getTweets():
    tweets = []
    with open(tweets_file,'rb') as f:
    	fvar = csv.reader(f, delimiter='\t')
    	for row in fvar:
            if row[4] != 1: # if it is not retweet
                tweets.append([int(row[0]),int(row[2])])
    return tweets

def appendRetweets(tweet_id,i,total_i,total_count):
    with open(retweets_file,'a') as f:
        not_done = True
        while not_done:
            try:
                retweets = api.retweets(tweet_id,100)
                for count in range(len(retweets)):
                    retweet = retweets[count]
                    print("%d/%d\t %d/%d" % (i, total_i, count+1, total_count))
                    f.write("%40d\t%40s\t%40s\t%20s\t%6d\t%6d\n" % (tweet_id, retweet.id_str, retweet.user.id_str, retweet.created_at, retweet.retweet_count, retweet.favorite_count))
                not_done = False
            except tweepy.RateLimitError:
                print("RateLimitError: pause for 1 minute")
                print(time.ctime())
                time.sleep(60)
                continue
            except tweepy.error.TweepError:
				print("TweepError: pause for 1 minute")
				print(time.ctime())
				time.sleep(60)
				continue


tweets = getTweets()

for i in range(len(tweets)):
    appendRetweets(tweets[i][0],i,len(tweets),tweets[i][1])