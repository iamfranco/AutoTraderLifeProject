import tweepy
import time
import csv

layer1_in = 'followers_info.txt'
layer1_out = 'followers.txt'
layer2_out = 'followers_friends.csv'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)

def appendFriends(id, i, total_i, total_count):
	count = 0
	with open(layer2_out,'a') as f:
		friendsIds = tweepy.Cursor(api.friends_ids,id).items()
		while True:
			try:
				friendsId = friendsIds.next()
				print("%d/%d\t %d/%d" % (i, total_i, count, total_count))
				f.write("%s,%s\n" % (str(id),str(friendsId)))
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

def getLayer1():
	layer1 = []
	with open(layer1_in,'rb') as f:
		fvar = csv.reader(f, delimiter='\t')
		for row in fvar:
			layer1.append([int(row[0]),int(row[2]),int(row[3])])
	return layer1

def showTimeRequired(layer1):
	minutes_required = 0
	for i in range(len(layer1)):
		minutes_required += layer1[i][2] / 5000 + 1
	print("# friends above threshold: %d" % (len(layer1)))
	print("minutes required: %d" % (minutes_required))
	print("hours required: %f" % (float(minutes_required)/float(60)))

def writeLayer1(layer1):
	with open(layer1_out,'a') as f:
		for id in layer1:
			f.write("%d\n" % (id[0]))

layer1 = getLayer1()

# showTimeRequired(layer1)

# writeLayer1(layer1)

for i in range(len(layer1)):
	appendFriends(layer1[i][0],i,len(layer1),layer1[i][2])

