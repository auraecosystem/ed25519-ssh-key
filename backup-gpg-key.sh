#!/bin/bash

# usage
# $ curl -sL https://gist.github.com/grenade/6318301/raw/backup-gpg-key.sh?$(uuidgen) | bash

backup_dir=${HOME}/key-backup

# backup existing gpg key
fingerprint=$(if [[ $(gpg --list-keys rthijssen@gmail.com) =~ ([A-F0-9]{40}) ]]; then echo ${BASH_REMATCH[1]}; fi)
if [ -n "${fingerprint}" ]; then
  timestamp=$(date -u --iso-8601=seconds)
  mkdir -p ${backup_dir}/${timestamp}/${fingerprint}
  gpg --export --armor ${fingerprint} > ${backup_dir}/${timestamp}/${fingerprint}/public.asc
  gpg --export-secret-keys --armor ${fingerprint} > ${backup_dir}/${timestamp}/${fingerprint}/private.asc
  gpg --export-secret-subkeys --armor ${fingerprint} > ${backup_dir}/${timestamp}/${fingerprint}/subkeys.private.asc
  gpg --export-ownertrust > ${backup_dir}/${timestamp}/${fingerprint}/ownertrust.txt
  tar -C ~/ -zcvf ${backup_dir}/${timestamp}/${fingerprint}/.gnupg.tar.gz .gnupg
fi