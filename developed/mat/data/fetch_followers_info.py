import tweepy
import time

followers_id100 = 'followers_id100.csv'
followers_info = 'followers_info.txt'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

with open(followers_id100,'rb') as fin, open(followers_info,'w') as fout:
    count = 0
    for row in fin:
        followers_100 = api.lookup_users(user_ids=[row])
        for i in range(len(followers_100)):
            follower = followers_100[i]
            print(count*100 + i)
            fout.write("%30s\t%20s\t%10d\t%10d\n" % (
                follower.id_str, follower.screen_name, follower.followers_count, follower.friends_count))
        count += 1
