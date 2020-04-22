#!/bin/sh
set -xe
mkdir -p /config/borgmatic/ /storage/ssh/
[ -e /storage/ssh/id_ed25519 ] || ssh-keygen -t ed25519 -f /storage/ssh/id_ed25519 -N ''
cat /storage/ssh/id_ed25519.pub
[ -e /config/borgmatic/config.yaml ] || autocreate-borg-repo
BORG_NEW_PASSPHRASE="" borgmatic -c /config/borgmatic init --append-only --encryption keyfile-blake2 --storage-quota 2G -v2
borgmatic -c /config/borgmatic create
if [ ! -e /repo/keyexport ]; then
	mkdir -p /repo/keyexport
	cd /repo/keyexport
	export BORG_BASE_DIR=/repo
	borg key export $(ls -1 /repo/.config/borg/security/*/location | head -n1 | xargs cat) ${BORGBASE_NAME}.key
	borg key export --paper $(ls -1 /repo/.config/borg/security/*/location | head -n1 | xargs cat) ${BORGBASE_NAME}.paperkey
	borg key export --qr-html $(ls -1 /repo/.config/borg/security/*/location | head -n1 | xargs cat) ${BORGBASE_NAME}.html
fi
