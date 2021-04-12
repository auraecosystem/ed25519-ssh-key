#!/bin/bash

ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "rob thijssen <rthijssen@gmail.com>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub