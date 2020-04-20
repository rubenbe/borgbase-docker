# Borgbase docker image

[![](https://images.microbadger.com/badges/image/rubenbe/borgbase-backup.svg)](https://hub.docker.com/repository/docker/rubenbe/borgbase-backup)

## Building
```shell
docker build -t backup .
```

## Running
```shell
docker run --read-only -it -v ./config/:/config/borgmatic/:z -v ./borgrepo/:/repo:Z -v ./storage/:/storage:Z,ro -v ./cache/:/cache:Z -e 'BORGBASE_KEY=<borgbase create-only API key>' -e 'BORGBASE_NAME=<backupname>' backup
```
