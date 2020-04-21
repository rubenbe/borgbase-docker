#!/bin/sh
set -xe
mkdir -p /config/borgmatic/ /storage/ssh/
[ -e /storage/ssh/id_ed25519 ] || ssh-keygen -t ed25519 -f /storage/ssh/id_ed25519 -N ''
cat /storage/ssh/id_ed25519.pub
[ -e /config/borgmatic/config.yaml ] || autocreate-borg-repo
BORG_NEW_PASSPHRASE="" borgmatic -c /config/borgmatic init --append-only --encryption keyfile-blake2 --storage-quota 2G -v2
borgmatic -c /config/borgmatic create
