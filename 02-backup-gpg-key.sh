#!/bin/bash

# usage
# $ curl -sL https://gist.github.com/grenade/6318301/raw/02-backup-gpg-key.sh?$(uuidgen) | bash

backup_dir=${HOME}/key-backup

# backup old gpg key
key_name="Rob Thijssen (https://grenade.github.io) <rthijssen@gmail.com>"
key_fingerprint=$(if [[ $(gpg --list-keys "${key_name}") =~ ([A-F0-9]{40}) ]]; then echo ${BASH_REMATCH[1]}; fi)
if [ -n "${key_fingerprint}" ]; then
  timestamp=$(date -u --iso-8601)
  mkdir -p ${backup_dir}/${timestamp}/${key_fingerprint}
  gpg --export --armor ${key_fingerprint} > ${backup_dir}/${timestamp}/${key_fingerprint}/public.asc
  gpg --export-secret-keys --armor ${key_fingerprint} > ${backup_dir}/${timestamp}/${key_fingerprint}/private.asc
  gpg --export-secret-subkeys --armor ${key_fingerprint} > ${backup_dir}/${timestamp}/${key_fingerprint}/subkeys.private.asc
  gpg --export-ownertrust > ${backup_dir}/${timestamp}/${key_fingerprint}/ownertrust.txt
  tar -C ~/ -zcvf ${backup_dir}/${timestamp}/${key_fingerprint}/.gnupg.tar.gz .gnupg
fi