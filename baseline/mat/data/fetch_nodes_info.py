import tweepy
import time

nodes_ids = 'nodes_ids.txt'
nodes_id100 = 'nodes_id100.csv'
nodes_info = 'nodes_info.txt'

execfile("api_keys.py")
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)


def writeNodes100():
    with open(nodes_ids, 'rb') as fin, open(nodes_id100, 'a') as fout:
        count = 1
        for row in fin:
            if (count % 100 == 0):
                fout.write("%s\n" % (str(row).strip()))
            else:
                fout.write("%s," % (str(row).rstrip()))
            print(count)
            count += 1

def writeNodeInfo():
    row_paused = 0
    row_index = 0
    with open(nodes_id100, 'rb') as fin, open(nodes_info, 'a') as fout:
        count = 0
        for row in fin:
			row_index += 1
			if (row_index > row_paused):
				arr = row.split(",")
				arr[-1] = arr[-1].strip()
				try:
					nodes_100 = api.lookup_users(user_ids=[row])
					arr_point = 0
					miss_count = 0
					for i in range(len(nodes_100)):
						node = nodes_100[i]
						while (arr_point < len(arr) and node.id_str != arr[arr_point]):
							fout.write("%30s\t%20s\t%10d\t%10d\n" % (
								arr[arr_point].strip(), "---", 0, 0))
							arr_point += 1
							miss_count += 1
						fout.write("%30s\t%20s\t%10d\t%10d\n" % (
							node.id_str, node.screen_name, node.followers_count, node.friends_count))
						arr_point += 1
					for j in range(len(arr) - miss_count - len(nodes_100)):
						fout.write("%30s\t%20s\t%10d\t%10d\n" % (
							arr[arr_point].strip(), "---", 0, 0))
					count += 1
					print(row_paused + count)
				except tweepy.RateLimitError:
					print("RateLimitError: pause for 1 minute")
					print(time.ctime())
					time.sleep(60)
					continue
				except StopIteration:
					print("StopIteration")
					break
				except tweepy.TweepError:
					print("TweepyError")
					break


writeNodes100()
writeNodeInfo()


