#!/usr/bin/python3
import os, random, time
seed=os.environ["BORGBASE_NAME"]
random.seed(seed)
backoff=random.randrange(0,3600*3,60)
print("Backing off", backoff, "seconds")
time.sleep(backoff)
os.execl("/usr/local/bin/backup", "/usr/local/bin/backup")
