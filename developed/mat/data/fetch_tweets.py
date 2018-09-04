import tweepy
import time

tweets_file = 'tweets.txt'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

with open(tweets_file,'a') as f:
    tweets = tweepy.Cursor(api.user_timeline,'autoTraderLife').items()
    count = 1
    while True:
        try:
            tweet = tweets.next()
            isRetweet = int(hasattr(tweet,'retweeted_status'));
            print("%d" % (count))
            f.write("%40s\t%40s\t%10d\t%10d\t%1d\t%s\n" % (tweet.id_str.encode("utf-8"), tweet.created_at, tweet.retweet_count, tweet.favorite_count, isRetweet, tweet.text.encode("utf-8").replace('|', ' ').replace('\n', ' ')))
            count += 1
        except tweepy.RateLimitError:
            print("RateLimitError: pause for 1 minute")
            print(time.ctime())
            time.sleep(60)
            continue
        except StopIteration:
            break
        except tweepy.TweepError:
            break

