#!/usr/bin/python3
from borgbase_api_client.client import GraphQLClient
from borgbase_api_client.mutations import *
import os

TOKEN = os.environ.get("BORGBASE_KEY")
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
print(res)
new_repo_path = res['data']['repoAdd']['repoAdded']['repoPath']
print('Added new repo with path:', new_repo_path)
with open('./config/') as FILE
