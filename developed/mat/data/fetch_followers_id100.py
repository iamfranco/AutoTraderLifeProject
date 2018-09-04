import tweepy
import time

followers_id100 = 'followers_id100.csv'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

with open(followers_id100,'a') as f:
    followerIds = tweepy.Cursor(api.followers_ids,'autoTraderLife').items()
    count = 1
    while True:
        try:
            followerId = followerIds.next()
            print("%d" % (count))
            if (count % 100 == 0):
                f.write("%d\n" % (followerId))
            else:
                f.write("%d, " % (followerId))
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

