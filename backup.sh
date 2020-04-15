#!/bin/sh
set -x
[ -e /storage/id_ed25519 ] || ssh-keygen -t ed25519 -f /storage/id_ed25519 -N ''
cat /storage/id_ed25519.pub
[ -e /config/borgmatic/config.yaml ] || generate-borgmatic-config
