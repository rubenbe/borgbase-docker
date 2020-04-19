# Borgbase docker image

## Building
```shell
docker build -t backup .
```

## Running
```shell
docker run --read-only -it -v ./config/:/config/borgmatic/:z -v ./storage/:/storage:Z -v ./cache/:/cache:Z -e 'BORGBASE_KEY=<borgbase create-only API key>' -e 'BORGBASE_NAME=<backupname>' backup /usr/local/bin/backup
```
