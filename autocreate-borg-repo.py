#!/usr/bin/python3
from borgbase_api_client.client import GraphQLClient
from borgbase_api_client.mutations import *
import os
import pprint

TOKEN = os.environ.get("BORGBASE_KEY")
#MYSQL_USER = os.environ.get("MYSQL_USER")
#MYSQL_DB = os.environ.get("MYSQL_DB")
BACKUP_NAME = os.environ.get("BORGBASE_NAME")
client = GraphQLClient(TOKEN)

new_key_vars = {
    'name': 'Key for ' + os.environ.get("BORGBASE_NAME"),
    'keyData': open('/storage/id_ed25519.pub').readline()
}
res = client.execute(SSH_ADD, new_key_vars)
new_key_id = res['data']['sshAdd']['keyAdded']['id']

new_repo_vars = {
    'name': BACKUP_NAME,
    'quotaEnabled': False,
    'appendOnlyKeys': [new_key_id],
    'region': 'eu'
}
res = client.execute(REPO_ADD, new_repo_vars)
pp = pprint.PrettyPrinter(indent=4)
pp.pprint(res)
new_repo_path = res['data']['repoAdd']['repoAdded']['repoPath']
print('Added new repo with path:', new_repo_path)
with open('/config/borgmatic/config.yaml', 'w') as FILE:
    FILE.write("""
location:
    source_directories:
        - /storage
        - /config
    repositories:
        - """ + new_repo_path + """
retention:
    keep_within: 48H
    keep_daily: 7
    keep_weekly: 4
    keep_monthly: 12
    keep_yearly: 1
""")
