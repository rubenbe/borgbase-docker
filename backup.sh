#!/bin/sh
set -x
mkdir -p /config/borgmatic/ /storage/ssh/
[ -e /storage/ssh/id_ed25519 ] || ssh-keygen -t ed25519 -f /storage/ssh/id_ed25519 -N ''
cat /storage/ssh/id_ed25519.pub
[ -e /config/borgmatic/config.yaml ] || autocreate-borg-repo
